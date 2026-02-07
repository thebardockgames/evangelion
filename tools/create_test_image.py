#!/usr/bin/env python3
"""
Crea una imagen de prueba para reemplazar D00SSF00
"""
from PIL import Image, ImageDraw, ImageFont

def main():
    # Dimensiones de la imagen original
    width, height = 112, 106
    
    # Crear imagen con fondo celeste (similar al original)
    img = Image.new('RGBA', (width, height), (200, 230, 255, 255))
    draw = ImageDraw.Draw(img)
    
    # Dibujar bordes negros (estilo del juego)
    draw.rectangle([0, 0, width-1, height-1], outline=(0, 0, 0, 255), width=2)
    
    # Intentar usar fuente por defecto o crear texto
    try:
        # Intentar cargar fuente del sistema
        font = ImageFont.truetype("arial.ttf", 14)
    except:
        font = ImageFont.load_default()
    
    # Dibujar texto "HACK MODE"
    text = "HACK"
    text2 = "MODE"
    
    # Calcular posición centrada (aproximada)
    bbox = draw.textbbox((0, 0), text, font=font)
    text_width = bbox[2] - bbox[0]
    x = (width - text_width) // 2
    y = 30
    
    # Dibujar texto en negro
    draw.text((x, y), text, fill=(0, 0, 0, 255), font=font)
    
    bbox2 = draw.textbbox((0, 0), text2, font=font)
    text_width2 = bbox2[2] - bbox2[0]
    x2 = (width - text_width2) // 2
    y2 = 55
    
    draw.text((x2, y2), text2, fill=(0, 0, 0, 255), font=font)
    
    # Guardar
    output = "assets/Images_preview/D00SSF00_modified.png"
    img.save(output)
    print(f"Imagen de prueba guardada: {output}")
    
    # También guardar como input para el conversor
    img.save("test_image.png")
    print(f"Imagen guardada: test_image.png")

if __name__ == '__main__':
    main()
