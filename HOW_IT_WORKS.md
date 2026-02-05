# Cómo Funciona la Verificación

## El Comando

```bash
python3 tools/compare_function.py 0x1050 24
```

## Qué Hace Paso a Paso

### 1. Lee el ROM Original
```python
with open('evangelion.z64', 'rb') as f:
    f.seek(0x1050)      # Se posiciona en offset 0x1050
    original = f.read(24)  # Lee 24 bytes
```

### 2. Lee el ROM Compilado
```python
with open('build/eva.z64', 'rb') as f:
    f.seek(0x1050)      # Mismo offset
    nuevo = f.read(24)   # Lee 24 bytes
```

### 3. Compara Byte por Byte
```python
if original == nuevo:
    print("[MATCH]")
else:
    print("[DIFF]")
    # Muestra qué bytes difieren
```

---

## Por Qué Es 100% Confiable

### Comparación Es Byte a Byte
- No compara "código fuente"
- No compara "estructura"
- **Compara los bytes exactos** que el N64 ejecutaría

### Ejemplo Real

Si la función `func_80096450` genera:
```
Original:  24 02 00 0F 24 42 FF FF 04 43 FF FF 24 42 FF FF 03 E0 00 08 00 00 00 00
Compilado: 24 02 00 0F 24 42 FF FF 04 43 FF FF 24 42 FF FF 03 E0 00 08 00 00 00 00
                        ↑
                        identical
```

El script verifica que **cada uno de los 24 bytes sea idéntico**.

---

## Qué NO Verifica Este Método

### ❌ No Verifica el Archivo .o
El archivo objeto (`build/src/code_1050.o`) puede tener:
- Símbolos diferentes
- Metadatos diferentes
- Relocs diferentes

**Pero** al final, cuando se linkea en el ROM, los bytes de la función son idénticos.

### ❌ No Verifica Datos Globales
Si la función usa variables globales, este método no verifica que esas variables estén en la posición correcta.

### ❌ No Verifica Llamadas a Otras Funciones
Si la función llama a `func_XXXXX`, no verifica que esa dirección sea correcta (eso se verifica en el linkado).

---

## Qué SÍ Garantiza

### ✅ El Código de la Función Es Idéntico
Instrucción por instrucción, byte por byte.

### ✅ El Compilador Generó el Assembly Correcto
GCC produjo exactamente lo que queríamos.

### ✅ La Lógica Es Correcta
Si el original hace `while(i >= 0)` y el generado también, los bytes coincidirán.

---

## Limitaciones

### Problema: "Funciona en Aislamiento"
Una función puede hacer MATCH individualmente, pero fallar cuando se linkea todo el ROM porque:
- Otra función ocupó más espacio
- Las direcciones de salto cambiaron
- Los datos globales se movieron

### Solución: Verificación Final
Cuando terminemos muchas funciones, hay que hacer:
```bash
make clean && make && sha1sum -c evangelion.sha1
```

Eso verifica el ROM **completo**.

---

## Por Qué Estoy Seguro de Que Es Idéntico

### 1. El Script Es Simple
No hay magia. Lee bytes, compara bytes.

### 2. El Offset Es Fijo
`0x1050` es la dirección ROM donde debe estar la función. Si el linker la puso ahí, es correcto.

### 3. El Tamaño Es Conocido
`24` bytes viene del assembly original (`nonmatching func_80096450, 0x18` donde 0x18 = 24).

### 4. No Hay Hash, Es Comparación Directa
No usamos MD5 ni SHA1. Es:
```python
byte_origen == byte_nuevo  # para cada uno de los 24 bytes
```

---

## Ejemplo Visual

```
ROM Original (evangelion.z64)
Offset 0x1050: [24 02 00 0F 24 42 FF FF ...]
                      ↑
                      Función func_80096450

ROM Compilado (build/eva.z64)  
Offset 0x1050: [24 02 00 0F 24 42 FF FF ...]
                      ↑
                      Mismos bytes = MATCH
```

Si un solo byte difiere (ej: `24` vs `25`), el script dice `[DIFF]`.

---

## Conclusión

El método es **confiable para la función individual**.

- ✅ Si dice MATCH, la función está perfecta.
- ⚠️ Pero el ROM completo puede fallar por otras razones (datos, otras funciones).
- 🎯 Es una herramienta de desarrollo rápido, no la verificación final.

*Para estar 100% seguros del proyecto completo: `sha1sum -c evangelion.sha1`*
