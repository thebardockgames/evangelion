# FIX OVL7 - Documentación de Trabajo en Progreso

## 🎯 Objetivo
Arreglar el overlay 7 (ovl7) para que el ROM arranque en emuladores.

## 📊 Estado Actual
- **Funciones totales**: 1025
- **Con MATCH**: 985 (96%) ✅
- **Con DIFF**: 40 (4%) ❌ - **TODAS en ovl7**
- **Problema**: Símbolos de ovl7 no definidos en linker

---

## 🔴 Problema Identificado

Las funciones de ovl7 referencian símbolos como `D_80042224_ovl7`, `D_8005205C_ovl7`, etc.

Pero en `undefined_syms_all.txt` solo había definiciones relativas:
```
D_80042228_ovl7 = D_80042224_ovl7 + 0x04;  # RELATIVO - NO FUNCIONA
```

Faltaba la **dirección base**:
```
D_80042224_ovl7 = 0x80042224;  # ABSOLUTO - NECESARIO
```

---

## ✅ Solución Implementada

### 1. Símbolos Añadidos Manualmente
En `undefined_syms_all.txt`:
```
D_80042224_ovl7 = 0x80042224;
D_8005205C_ovl7 = 0x8005205C;
D_80052061_ovl7 = D_8005205C_ovl7 + 0x05;
```

### 2. Script para Añadir Resto de Símbolos
Creado: `tools/fix_ovl7_syms.py`

Este script:
- Busca TODOS los símbolos `_ovl7` en assembly
- Los añade a `undefined_syms_all.txt` con direcciones absolutas

---

## 🚀 Comandos para Continuar en Casa

### Paso 1: Añadir todos los símbolos faltantes
```bash
python3 tools/fix_ovl7_syms.py
```

### Paso 2: Reconstruir todo
```bash
make clean
make
```

### Paso 3: Verificar si ovl7 ahora hace MATCH
```bash
python3 tools/audit_matching.py
```

### Paso 4: Si ovl7 funciona, probar en emulador
```bash
# Copiar ROM a carpeta de emulador
# Probar si arranca sin crash
```

---

## 📁 Archivos Modificados

| Archivo | Cambio |
|---------|--------|
| `undefined_syms_all.txt` | Añadidos símbolos base de ovl7 |
| `tools/fix_ovl7_syms.py` | Script para añadir símbolos automáticamente |
| `tools/audit_matching.py` | Script para verificar matching (ya existía) |

---

## 🎯 Resultado Esperado

Después de ejecutar `python3 tools/fix_ovl7_syms.py` y `make`:

### Éxito Parcial
- Funciones con DIFF: 40 → menos (idealmente 0)
- Si quedan pocas, investigar individualmente

### Éxito Total
- Funciones con DIFF: 0
- `sha1sum -c evangelion.sha1` → OK
- ROM arranca en emulador

---

## 🔄 Si Aún No Funciona

### Opción A: Investigar símbolos restantes
```bash
# Ver qué símbolos aún faltan
grep -r "_ovl7" asm/nonmatchings/ovl7/ | grep -v "func_" | sort | uniq
```

### Opción B: Desactivar ovl7 temporalmente
Si ovl7 sigue roto, podemos:
1. Usar el assembly original en lugar de intentar linkear
2. Seguir con otras partes del proyecto
3. Volver a ovl7 cuando tengamos más experiencia

---

## 💡 Notas Importantes

1. **Los overlays se cargan dinámicamente**: No están siempre en memoria
2. **Direcciones VRAM**: ovl7 se carga en 0x800XXXXX (direcciones altas)
3. **Símbolos complejos**: Algunos símbolos son arrays/estructuras, no simples valores

---

## 📞 Siguiente Paso (Cuando Vuelvas)

1. Ejecuta: `python3 tools/fix_ovl7_syms.py`
2. Ejecuta: `make clean && make`
3. Ejecuta: `python3 tools/audit_matching.py | grep "DIFF" | wc -l`
4. Si el número es 0 → ¡ÉXITO! Probar en emulador.
5. Si el número > 0 → Seguir investigando símbolos faltantes.

---

*Trabajo en progreso - Sistema de archivos de documentación*
*Creado: 2026-02-04*
