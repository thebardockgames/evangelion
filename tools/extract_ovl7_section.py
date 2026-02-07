#!/usr/bin/env python3
import struct

# Leer ROM original
with open("evangelion.z64", "rb") as f:
    rom = f.read()

# Extraer sección ovl7 (0x175860 - 0x179E00)
start = 0x175860
end = 0x179E00
section = rom[start:end]

# Guardar como binario
with open("asm/ovl7/code_175860.bin", "wb") as f:
    f.write(section)

print(f"Extraidos {len(section)} bytes ({len(section)//4} instrucciones)")
print(f"Rango VRAM: 0x80025E20 - 0x80026284")
