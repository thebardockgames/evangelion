#!/usr/bin/env python3
"""
Convertidor de imágenes N64 (CI4/CI8/YAY0) a PNG
"""
import sys
import struct
from pathlib import Path
from PIL import Image


def decompress_yay0(data):
    """Descomprime datos YAY0 (algoritmo de Nintendo)."""
    if data[:4] != b'Yay0':
        return data  # No está comprimido
    
    size = struct.unpack('>I', data[4:8])[0]
    link_offset = struct.unpack('>I', data[8:12])[0]
    data_offset = struct.unpack('>I', data[12:16])[0]
    
    src_offset = 16
    link_table = link_offset
    data_table = data_offset
    
    dst = bytearray(size)
    dst_pos = 0
    
    mask_bits = 0
    mask = 0
    
    while dst_pos < size:
        if mask_bits == 0:
            mask = struct.unpack('>I', data[src_offset:src_offset+4])[0]
            src_offset += 4
            mask_bits = 32
        
        if mask & 0x80000000:
            # Byte literal
            dst[dst_pos] = data[data_table]
            data_table += 1
            dst_pos += 1
        else:
            # Referencia
            link = struct.unpack('>H', data[link_table:link_table+2])[0]
            link_table += 2
            
            offset = dst_pos - (link & 0x0FFF) - 1
            length = (link >> 12) + 2
            if length == 2:
                length = data[data_table] + 18
                data_table += 1
            
            for _ in range(length + 1):
                if dst_pos < size:
                    dst[dst_pos] = dst[offset]
                    dst_pos += 1
                    offset += 1
        
        mask <<= 1
        mask_bits -= 1
    
    return bytes(dst)


def read_palette(pal_path):
    """Lee una paleta N64 (formato RGBA16 big-endian)."""
    pal_data = Path(pal_path).read_bytes()
    
    # Descomprimir si es YAY0
    if pal_data[:4] == b'Yay0':
        pal_data = decompress_yay0(pal_data)
    
    palette = []
    for i in range(0, len(pal_data), 2):
        if i + 1 >= len(pal_data):
            break
        # RGBA16: RRRRRGGG GGGBBBBB (5-5-5-1)
        color = struct.unpack('>H', pal_data[i:i+2])[0]
        r = ((color >> 11) & 0x1F) << 3
        g = ((color >> 6) & 0x1F) << 3
        b = ((color >> 1) & 0x1F) << 3
        a = 255 if (color & 0x1) else 0
        palette.append((r, g, b, a))
    
    return palette


def decode_ci8(image_data, palette, width, height):
    """Decodifica imagen CI8 (256 colores indexados)."""
    img = Image.new('RGBA', (width, height))
    pixels = img.load()
    
    for y in range(height):
        for x in range(width):
            idx = y * width + x
            if idx < len(image_data):
                color_idx = image_data[idx]
                if color_idx < len(palette):
                    pixels[x, y] = palette[color_idx]
                else:
                    pixels[x, y] = (255, 0, 255, 255)  # Magenta para error
    
    return img


def decode_ci4(image_data, palette, width, height):
    """Decodifica imagen CI4 (16 colores indexados)."""
    img = Image.new('RGBA', (width, height))
    pixels = img.load()
    
    for y in range(height):
        for x in range(0, width, 2):
            idx = y * (width // 2) + (x // 2)
            if idx < len(image_data):
                byte = image_data[idx]
                # Cada byte tiene 2 píxeles: nibble alto y bajo
                color_idx1 = (byte >> 4) & 0x0F
                color_idx2 = byte & 0x0F
                
                if color_idx1 < len(palette):
                    pixels[x, y] = palette[color_idx1]
                else:
                    pixels[x, y] = (255, 0, 255, 255)
                    
                if x + 1 < width:
                    if color_idx2 < len(palette):
                        pixels[x + 1, y] = palette[color_idx2]
                    else:
                        pixels[x + 1, y] = (255, 0, 255, 255)
    
    return img


def main():
    if len(sys.argv) < 2:
        print("Uso: python n64image_viewer.py <imagen.bin> [paleta.pal.bin]")
        print("Ejemplo: python n64image_viewer.py assets/Images/D09S9A00.pal_554.320x240.ci8.yay0.bin")
        sys.exit(1)
    
    image_path = Path(sys.argv[1])
    
    # Parsear información del nombre del archivo
    # Formato: NOMBRE.pal_XX.WIDTHxHEIGHT.FORMAT.yay0.bin
    parts = image_path.stem.replace('.bin', '').split('.')
    
    # Encontrar dimensiones y formato
    width, height = 320, 240  # Default
    fmt = 'ci8'
    pal_idx = 0
    
    for part in parts:
        if 'x' in part and part[0].isdigit():
            # Es una dimensión como 320x240
            try:
                w, h = part.split('x')
                width, height = int(w), int(h)
            except:
                pass
        elif part in ['ci4', 'ci8', 'rgba16', 'ia8']:
            fmt = part
        elif part.startswith('pal_'):
            try:
                pal_idx = int(part.split('_')[1])
            except:
                pass
    
    print(f"Imagen: {image_path.name}")
    print(f"Formato: {fmt}, Dimensiones: {width}x{height}, Paleta: {pal_idx}")
    
    # Cargar datos de imagen
    image_data = Path(image_path).read_bytes()
    
    # Descomprimir YAY0 si es necesario
    if image_data[:4] == b'Yay0':
        print("Descomprimiendo YAY0...")
        image_data = decompress_yay0(image_data)
        print(f"Tamaño descomprimido: {len(image_data)} bytes")
    
    # Cargar paleta
    if len(sys.argv) >= 3:
        pal_path = sys.argv[2]
    else:
        # Buscar paleta automáticamente
        pal_path = f"assets/Palettes/{pal_idx:04d}.pal.bin"
        if not Path(pal_path).exists():
            # Intentar con .yay0
            pal_path = f"assets/Palettes/{pal_idx:04d}.pal.yay0.bin"
    
    if not Path(pal_path).exists():
        print(f"Error: No se encontró la paleta: {pal_path}")
        print("Generando paleta de prueba (grayscale)...")
        palette = [(i, i, i, 255) for i in range(256)]
    else:
        print(f"Cargando paleta: {pal_path}")
        palette = read_palette(pal_path)
        print(f"Colores en paleta: {len(palette)}")
    
    # Decodificar
    if fmt == 'ci8':
        img = decode_ci8(image_data, palette, width, height)
    elif fmt == 'ci4':
        img = decode_ci4(image_data, palette, width, height)
    else:
        print(f"Formato {fmt} no soportado aún")
        sys.exit(1)
    
    # Guardar
    output_path = image_path.with_suffix('.png')
    img.save(output_path)
    print(f"Guardado: {output_path}")
    
    # Mostrar si hay GUI
    try:
        img.show()
    except:
        pass


if __name__ == '__main__':
    main()
