#!/usr/bin/env python3
"""
Compresión YAY0 simplificada - Versión conservadora
Solo usa literales para asegurar compatibilidad
"""
import struct
from io import BytesIO


def compress_yay0_simple(data):
    """
    Compresión YAY0 que solo usa literales (sin LZ).
    Es segura pero con peor ratio.
    """
    if len(data) == 0:
        return b''
    
    # Todas las operaciones son literales
    control_bits = [1] * len(data)
    literal_data = list(data)
    
    # Rellenar bits a múltiplo de 32
    while len(control_bits) % 32 != 0:
        control_bits.append(0)
    
    # Convertir a words
    control_words = []
    for i in range(0, len(control_bits), 32):
        word = 0
        for j in range(32):
            word = (word << 1) | control_bits[i + j]
        control_words.append(struct.pack('>I', word))
    
    control_data = b''.join(control_words)
    
    # Calcular offsets
    header_size = 16
    code_offset = header_size
    link_offset = code_offset + len(control_data)
    data_offset = link_offset  # No hay tabla de links
    
    # Construir archivo
    output = BytesIO()
    output.write(b'Yay0')
    output.write(struct.pack('>I', len(data)))
    output.write(struct.pack('>I', link_offset))
    output.write(struct.pack('>I', data_offset))
    output.write(control_data)
    # No hay link data
    output.write(bytes(literal_data))
    
    return output.getvalue()


def compress_yay0(data):
    """
    Compresión YAY0 con LZ.
    """
    if len(data) == 0:
        return b''
    
    # Primero paso: identificar todas las operaciones
    ops = []  # (tipo, ...)
    pos = 0
    
    while pos < len(data):
        best_len = 0
        best_offset = 0
        
        # Buscar hacia atrás
        search_start = max(0, pos - 4096)
        for offset in range(search_start, pos):
            if data[offset] != data[pos]:
                continue
                
            length = 1
            max_len = min(273, len(data) - pos, pos - offset + 273)
            
            while length < max_len and data[offset + length] == data[pos + length]:
                length += 1
            
            if length > best_len:
                best_len = length
                best_offset = offset
        
        # Necesitamos al menos 4 bytes para que valga la pena
        # (el formato YAY0 no puede codificar menos de 4 bytes en una referencia)
        if best_len >= 4:
            # Referencia
            ops.append(('R', pos - best_offset - 1, best_len))
            pos += best_len
        else:
            # Literal
            ops.append(('L', data[pos]))
            pos += 1
    
    # Segundo paso: construir tablas
    control_bits = []
    link_table = []
    data_table = []
    
    for op in ops:
        if op[0] == 'L':
            control_bits.append(1)
            data_table.append(op[1])
        else:
            control_bits.append(0)
            offset = op[1]
            length = op[2]
            
            # Codificar
            # length_field = length - 3 (porque copiamos length_field + 3 bytes)
            # Pero length mínimo es 4, así que length_field mínimo es 1
            length_field = length - 3
            
            if length <= 18:
                # Formato corto
                link_word = (length_field << 12) | (offset & 0x0FFF)
                link_table.append(struct.pack('>H', link_word))
            else:
                # Formato largo
                # length_field = 0, longitud extra en data_table
                link_word = (0 << 12) | (offset & 0x0FFF)
                link_table.append(struct.pack('>H', link_word))
                data_table.append(length - 18)
    
    # Rellenar control bits
    while len(control_bits) % 32 != 0:
        control_bits.append(0)
    
    # Convertir a bytes
    control_words = []
    for i in range(0, len(control_bits), 32):
        word = 0
        for j in range(32):
            word = (word << 1) | control_bits[i + j]
        control_words.append(struct.pack('>I', word))
    
    control_data = b''.join(control_words)
    link_data = b''.join(link_table)
    literal_bytes = bytes(data_table)
    
    # Calcular offsets
    header_size = 16
    code_offset = header_size
    link_offset = code_offset + len(control_data)
    data_offset = link_offset + len(link_data)
    
    # Construir
    output = BytesIO()
    output.write(b'Yay0')
    output.write(struct.pack('>I', len(data)))
    output.write(struct.pack('>I', link_offset))
    output.write(struct.pack('>I', data_offset))
    output.write(control_data)
    output.write(link_data)
    output.write(literal_bytes)
    
    return output.getvalue()


def main():
    import sys
    from pathlib import Path
    from n64image_viewer import decompress_yay0
    
    if len(sys.argv) < 2:
        print("Uso: python yay0_compress.py <archivo>")
        sys.exit(1)
    
    input_path = Path(sys.argv[1])
    data = input_path.read_bytes()
    
    print(f"Original: {len(data)} bytes")
    
    # Intentar compresión con LZ
    compressed = compress_yay0(data)
    
    print(f"Comprimido: {len(compressed)} bytes")
    print(f"Ratio: {len(compressed) / len(data):.2%}")
    
    # Verificar
    try:
        decompressed = decompress_yay0(compressed)
        
        if decompressed == data:
            print("[OK] Verificación correcta")
            output_path = Path('assets/Images/D00SSF00.pal_112.112x106.ci4.yay0.bin')
            output_path.write_bytes(compressed)
            print(f"Guardado en: {output_path}")
        else:
            print("[ERR] Error en verificación")
            # Mostrar primeras diferencias
            for i in range(min(len(data), len(decompressed))):
                if data[i] != decompressed[i]:
                    print(f"  Diff en {i}: orig={hex(data[i])} decomp={hex(decompressed[i])}")
                    break
    except Exception as e:
        print(f"[ERR] {e}")
        import traceback
        traceback.print_exc()


if __name__ == '__main__':
    main()
