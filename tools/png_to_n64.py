#!/usr/bin/env python3
"""
Convierte PNG a formato N64 (CI4/CI8 con paleta RGBA16)
"""
import sys
import struct
from pathlib import Path
from PIL import Image


def compress_yay0(data):
    """
    Compresión YAY0 simplificada (LZ77).
    Retorna los datos comprimidos o los originales si es más grande.
    """
    # Por ahora retornamos sin comprimir si es más pequeño
    # La compresión YAY0 real es compleja
    return data


def rgb_to_rgba16(r, g, b, a=255):
    """Convierte RGB a formato RGBA16 N64 (big-endian)."""
    # RGBA16: RRRRRGGG GGGBBBBB A (5-5-5-1)
    r5 = (r >> 3) & 0x1F
    g5 = (g >> 3) & 0x1F
    b5 = (b >> 3) & 0x1F
    a1 = 1 if a > 127 else 0
    return (r5 << 11) | (g5 << 6) | (b5 << 1) | a1


def create_palette(image, max_colors=16):
    """
    Crea una paleta optimizada para la imagen.
    Retorna (paleta_bytes, indexed_image)
    """
    # Convertir a modo P (paleta) con cuantización
    img_p = image.convert('P', palette=Image.ADAPTIVE, colors=max_colors)
    
    # Obtener la paleta
    palette_rgb = img_p.getpalette()
    
    # Convertir a RGBA16
    palette_rgba16 = []
    for i in range(max_colors):
        r = palette_rgb[i * 3]
        g = palette_rgb[i * 3 + 1]
        b = palette_rgb[i * 3 + 2]
        color = rgb_to_rgba16(r, g, b)
        palette_rgba16.append(struct.pack('>H', color))
    
    palette_bytes = b''.join(palette_rgba16)
    
    return palette_bytes, img_p


def encode_ci4(img_p):
    """
    Codifica imagen indexada a CI4 (2 píxeles por byte).
    """
    width, height = img_p.size
    data = bytearray()
    
    for y in range(height):
        for x in range(0, width, 2):
            idx1 = img_p.getpixel((x, y))
            idx2 = img_p.getpixel((min(x + 1, width - 1), y)) if x + 1 < width else 0
            byte = ((idx1 & 0x0F) << 4) | (idx2 & 0x0F)
            data.append(byte)
    
    return bytes(data)


def encode_ci8(img_p):
    """
    Codifica imagen indexada a CI8 (1 byte por píxel).
    """
    width, height = img_p.size
    data = bytearray()
    
    for y in range(height):
        for x in range(width):
            data.append(img_p.getpixel((x, y)))
    
    return bytes(data)


def main():
    if len(sys.argv) < 3:
        print("Uso: python png_to_n64.py <input.png> <output_base>")
        print("Ejemplo: python png_to_n64.py mi_imagen.png D00SSF00_new")
        sys.exit(1)
    
    png_path = Path(sys.argv[1])
    output_base = sys.argv[2]
    
    if not png_path.exists():
        print(f"Error: No se encontró {png_path}")
        sys.exit(1)
    
    # Cargar imagen
    img = Image.open(png_path)
    
    # Asegurar que tiene transparencia
    if img.mode != 'RGBA':
        img = img.convert('RGBA')
    
    width, height = img.size
    print(f"Imagen: {width}x{height}")
    
    # Determinar formato basado en la imagen original que estamos reemplazando
    # D00SSF00 es CI4 (16 colores)
    max_colors = 16
    
    print(f"Convirtiendo a CI{max_colors}...")
    
    # Crear paleta y versión indexada
    palette_bytes, img_p = create_palette(img, max_colors)
    
    # Codificar
    if max_colors == 16:
        image_data = encode_ci4(img_p)
        fmt = "ci4"
    else:
        image_data = encode_ci8(img_p)
        fmt = "ci8"
    
    # Guardar imagen
    output_img = Path(f"assets/Images/{output_base}.{fmt}.bin")
    output_img.write_bytes(image_data)
    print(f"Imagen guardada: {output_img} ({len(image_data)} bytes)")
    
    # Guardar paleta
    output_pal = Path(f"assets/Palettes/{output_base}.pal.bin")
    output_pal.write_bytes(palette_bytes)
    print(f"Paleta guardada: {output_pal} ({len(palette_bytes)} bytes)")
    
    print(f"\nListo! Ahora copia estos archivos sobre los originales:")
    print(f"  - {output_img.name} -> D00SSF00.pal_112.112x106.ci4.yay0.bin")
    print(f"  - {output_pal.name} -> 0112.pal.bin (o .yay0.bin)")


if __name__ == '__main__':
    main()
