# Fast Matching - Compilación Individual

Técnica para verificar matching sin compilar todo el proyecto.

---

## 🎯 Concepto

En lugar de:
```
make clean && make && sha1sum -c evangelion.sha1  (5-10 minutos)
```

Hacemos:
```
Compilar solo un archivo .c → Comparar .o generado con .o original  (segundos)
```

---

## 📋 Paso a Paso

### 1. Extraer objetos del ROM (ya hecho por splat)

`splat` ya extrae los archivos objeto individuales durante `make setup`.

Los objetos originales están en:
- `expected/build/src/code_XXXXX.o` (si splat los extrajo)
- O necesitamos extraerlos manualmente del ELF

### 2. Compilar un solo archivo

```bash
# Compilar solo code_15150.c
make build/src/code_15150.o

# O manualmente con GCC:
mips-n64-gcc -c -G0 -O2 -mips3 src/code_15150.c -o build/src/code_15150.o \
    -I include -I. -Ibuild/ \
    -DTARGET_N64 -DF3DEX_GBI_2
```

### 3. Comparar objetos

```bash
# Comparar byte a byte
diff build/src/code_15150.o expected/build/src/code_15150.o

# O ver tamaños
ls -la build/src/code_15150.o expected/build/src/code_15150.o

# O comparar disassembly
mips-linux-gnu-objdump -d build/src/code_15150.o > nuevo.txt
mips-linux-gnu-objdump -d expected/build/src/code_15150.o > original.txt
diff nuevo.txt original.txt
```

---

## 🔧 Script Automático

Crear `tools/check_matching.py`:

```python
#!/usr/bin/env python3
"""Check if a single C file matches the original."""

import sys
import subprocess
import os

FILE = sys.argv[1] if len(sys.argv) > 1 else "src/code_15150.c"
OBJ = FILE.replace("src/", "build/src/").replace(".c", ".o")
EXPECTED = OBJ.replace("build/", "expected/build/")

def main():
    # Compile
    result = subprocess.run(["make", OBJ], capture_output=True, text=True)
    if result.returncode != 0:
        print("❌ Compilation failed")
        print(result.stderr)
        return 1
    
    # Check if expected exists
    if not os.path.exists(EXPECTED):
        print(f"⚠️  Expected object not found: {EXPECTED}")
        print("   Run: make setup (to extract original objects)")
        return 1
    
    # Compare
    with open(OBJ, "rb") as f1, open(EXPECTED, "rb") as f2:
        data1 = f1.read()
        data2 = f2.read()
    
    if data1 == data2:
        print(f"✅ MATCH: {FILE}")
        return 0
    else:
        print(f"❌ DIFFER: {FILE}")
        print(f"   Size: new={len(data1)}, orig={len(data2)}")
        
        # Find first difference
        for i, (b1, b2) in enumerate(zip(data1, data2)):
            if b1 != b2:
                print(f"   First diff at byte {i}: 0x{b1:02x} vs 0x{b2:02x}")
                break
        return 1

if __name__ == "__main__":
    sys.exit(main())
```

Uso:
```bash
python3 tools/check_matching.py src/code_15150.c
```

---

## ⚠️ Problema Actual

**Necesitamos los objetos originales extraídos del ROM.**

`splat` extrae assembly, no objetos binarios. Para obtener los .o originales necesitamos:

### Opción A: Extraer del ROM con splat (configuración especial)

En `evangelion.yaml`, splat puede configurarse para extraer objetos:
```yaml
options:
  extract_objects: True  # Si está disponible
```

### Opción B: Usar el ROM como referencia

Comparar bytes en el ROM directamente:

```bash
# Ver dónde queda la función en el ROM compilado
mips-n64-objdump -t build/eva.elf | grep func_800AA550

# Extraer bytes del ROM original y nuevo
python3 -c "
import sys

# Offset de func_800AA550 en ROM: 0x15150
offset = 0x15150
size = 0x58  # 88 bytes

with open('evangelion.z64', 'rb') as f:
    f.seek(offset)
    original = f.read(size)

with open('build/eva.z64', 'rb') as f:
    f.seek(offset)
    nuevo = f.read(size)

if original == nuevo:
    print('✅ MATCH')
else:
    print('❌ DIFFER')
    for i, (o, n) in enumerate(zip(original, nuevo)):
        if o != n:
            print(f'  Offset {offset+i:06x}: 0x{o:02x} vs 0x{n:02x}')
"
```

---

## 🚀 Flujo de Trabajo Rápido Recomendado

```bash
# 1. Modificar archivo C
vim src/code_XXXXX.c

# 2. Compilar solo ese archivo (rápido)
make build/src/code_XXXXX.o

# 3. Ver assembly generado
mips-linux-gnu-objdump -d build/src/code_XXXXX.o | grep -A 20 "func_800XXXXX"

# 4. Comparar con original en ROM
python3 tools/compare_function.py func_800AA550 0x15150 0x58

# 5. Si no match → ajustar C → repetir desde paso 2
# 6. Si match → celebrar → siguiente función
```

---

## 💡 Ventajas

- **Velocidad**: Compilar 1 archivo = segundos vs 5-10 minutos
- **Feedback inmediato**: Sabes inmediatamente qué está mal
- **Iteración rápida**: Probar cambios rapidamente

## ⚠️ Limitaciones

- Necesitas saber el offset exacto de la función en el ROM
- No detecta problemas de linkeo (solo el código de la función)
- Para problemas de datos globales, necesitas build completo

---

*Documentación para uso interno - Proyecto personal*
