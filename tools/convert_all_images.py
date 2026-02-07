#!/usr/bin/env python3
"""
Convierte todas las imágenes N64 a PNG
"""
import sys
import struct
from pathlib import Path
from PIL import Image
import multiprocessing
from functools import partial


def decompress_yay0(data):
    """Descomprime datos YAY0."""
    if len(data) < 4 or data[:4] != b'Yay0':
        return data
    
    try:
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
                if src_offset + 4 > len(data):
                    break
                mask = struct.unpack('>I', data[src_offset:src_offset+4])[0]
                src_offset += 4
                mask_bits = 32
            
            if mask & 0x80000000:
                # Byte literal
                if data_table < len(data):
                    dst[dst_pos] = data[data_table]
                    data_table += 1
                    dst_pos += 1
            else:
                # Referencia
                if link_table + 2 > len(data):
                    break
                link = struct.unpack('>H', data[link_table:link_table+2])[0]
                link_table += 2
                
                offset = dst_pos - (link & 0x0FFF) - 1
                length = (link >> 12) + 2
                if length == 2:
                    if data_table >= len(data):
                        break
                    length = data[data_table] + 18
                    data_table += 1
                
                for _ in range(length + 1):
                    if dst_pos < size and 0 <= offset < len(dst):
                        dst[dst_pos] = dst[offset]
                        dst_pos += 1
                        offset += 1
            
            mask <<= 1
            mask_bits -= 1
        
        return bytes(dst)
    except:
        return data


def read_palette(pal_path):
    """Lee una paleta N64."""
    try:
        pal_data = Path(pal_path).read_bytes()
        
        if pal_data[:4] == b'Yay0':
            pal_data = decompress_yay0(pal_data)
        
        palette = []
        for i in range(0, len(pal_data), 2):
            if i + 1 >= len(pal_data):
                break
            color = struct.unpack('>H', pal_data[i:i+2])[0]
            r = ((color >> 11) & 0x1F) << 3
            g = ((color >> 6) & 0x1F) << 3
            b = ((color >> 1) & 0x1F) << 3
            a = 255 if (color & 0x1) else 255  # Normalmente 1 = opaco
            palette.append((r, g, b, a))
        
        return palette
    except:
        return []


def decode_ci8(image_data, palette, width, height):
    """Decodifica CI8."""
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
                    pixels[x, y] = (255, 0, 255, 255)
    
    return img


def decode_ci4(image_data, palette, width, height):
    """Decodifica CI4."""
    img = Image.new('RGBA', (width, height))
    pixels = img.load()
    
    for y in range(height):
        for x in range(0, width, 2):
            idx = y * (width // 2) + (x // 2)
            if idx < len(image_data):
                byte = image_data[idx]
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


def parse_filename(filename):
    """Extrae información del nombre del archivo."""
    parts = filename.replace('.bin', '').split('.')
    
    width, height = 0, 0
    fmt = 'ci8'
    pal_idx = 0
    
    for part in parts:
        if 'x' in part and part[0].isdigit():
            try:
                w, h = part.split('x')
                width, height = int(w), int(h)
            except:
                pass
        elif part in ['ci4', 'ci8']:
            fmt = part
        elif part.startswith('pal_'):
            try:
                pal_idx = int(part.split('_')[1])
            except:
                pass
    
    return width, height, fmt, pal_idx


def process_image(image_path, output_dir, palettes_dir):
    """Procesa una sola imagen."""
    image_path = Path(image_path)
    
    # Parsear nombre
    width, height, fmt, pal_idx = parse_filename(image_path.name)
    
    if width == 0 or height == 0:
        return (image_path.name, "SKIP", "No se pudieron determinar dimensiones")
    
    # Cargar imagen
    image_data = image_path.read_bytes()
    
    # Descomprimir YAY0
    if image_data[:4] == b'Yay0':
        image_data = decompress_yay0(image_data)
    
    # Cargar paleta
    pal_path = palettes_dir / f"{pal_idx:04d}.pal.bin"
    if not pal_path.exists():
        pal_path = palettes_dir / f"{pal_idx:04d}.pal.yay0.bin"
    
    palette = []
    if pal_path.exists():
        palette = read_palette(pal_path)
    
    if not palette:
        # Paleta por defecto (grayscale)
        palette = [(i, i, i, 255) for i in range(256)]
    
    # Decodificar
    try:
        if fmt == 'ci8':
            img = decode_ci8(image_data, palette, width, height)
        elif fmt == 'ci4':
            img = decode_ci4(image_data, palette, width, height)
        else:
            return (image_path.name, "SKIP", f"Formato no soportado: {fmt}")
        
        # Guardar PNG
        output_path = output_dir / image_path.with_suffix('.png').name
        img.save(output_path)
        return (image_path.name, "OK", str(output_path.name))
        
    except Exception as e:
        return (image_path.name, "ERROR", str(e))


def main():
    # Directorios
    images_dir = Path("assets/Images")
    palettes_dir = Path("assets/Palettes")
    output_dir = Path("assets/Images_preview")
    
    # Crear directorio de salida
    output_dir.mkdir(exist_ok=True)
    
    # Buscar todas las imágenes
    image_files = list(images_dir.glob("*.bin"))
    
    print(f"Encontradas {len(image_files)} imágenes")
    print(f"Convirtiendo a: {output_dir}")
    print("-" * 60)
    
    # Procesar en paralelo
    with multiprocessing.Pool() as pool:
        process_func = partial(process_image, output_dir=output_dir, palettes_dir=palettes_dir)
        results = pool.map(process_func, image_files)
    
    # Mostrar resultados
    ok_count = 0
    skip_count = 0
    error_count = 0
    
    for name, status, msg in sorted(results):
        if status == "OK":
            ok_count += 1
            print(f"[OK] {name}")
        elif status == "SKIP":
            skip_count += 1
            print(f"[SKIP] {name}: {msg}")
        else:
            error_count += 1
            print(f"[ERR] {name}: {msg}")
    
    print("-" * 60)
    print(f"Convertidas: {ok_count}, Saltadas: {skip_count}, Errores: {error_count}")
    print(f"Imágenes guardadas en: {output_dir}")


if __name__ == '__main__':
    main()
