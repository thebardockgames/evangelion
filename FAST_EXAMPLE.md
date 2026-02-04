# Ejemplo Práctico - Fast Matching

## Flujo de Trabajo en 4 Pasos

### 1. Modificar
Editas `src/code_15150.c` y reemplazas INCLUDE_ASM con tu código C.

### 2. Compilar Rápido
```bash
make build/src/code_15150.o
```
→ Tarda 2-3 segundos (vs 5-10 minutos del build completo)

### 3. Verificar Matching
```bash
python3 tools/compare_function.py 0x15150 88
```
→ Resultado inmediato

### 4. Iterar
- Si **[MATCH]** → ¡Función completada! Pasa a la siguiente.
- Si **[DIFF]** → Ajustas el código C y vuelves al paso 2.

---

## Ejemplos de Comandos

### Verificar func_800AA550
```bash
python3 tools/compare_function.py 0x15150 88
```
**Output:**
```
[MATCH] Offset 0x015150 (88 bytes) - PERFECT MATCH!
```

### Verificar func_800AA5A8
```bash
python3 tools/compare_function.py 0x151A8 128
```

### Verificar datos con problemas
```bash
python3 tools/compare_function.py 0x3E738 32
```
**Output:**
```
[DIFF] Offset 0x03E738 - BYTES DIFFER
  0x03E73B: original=0x50, built=0x70
  0x03E73F: original=0xB0, built=0xD0
  ... and 2 more differences
```

---

## Comparación de Tiempos

| Método | Tiempo | Feedback |
|--------|--------|----------|
| Build completo | 5-10 minutos | Lento |
| Fast matching | 3-5 segundos | **Instantáneo** |

**Ventaja:** Puedes hacer 20-30 iteraciones en el tiempo que tardaría 1 build completo.

---

## Cuándo usar cada método

### Usa Fast Matching cuando:
- Estás ajustando una función específica
- Quieres probar rápidamente un cambio
- Iterando para hacer match

### Usa Build Completo cuando:
- Cambias headers que afectan múltiples archivos
- Necesitas verificar el ROM final completo
- Cambias el linker script

---

*Generado en sesión 2026-02-04*
