# FIX OVL7 - Documentación de Trabajo en Progreso

## 🎯 Objetivo
Arreglar el overlay 7 (ovl7) para que el ROM arranque en emuladores.

## 📊 Estado Actual (05 Feb 2026 - 15:30)
- **Funciones totales**: 1025
- **Con MATCH**: 985 (96%) ✅
- **Con DIFF**: 40 (4%) ❌ - **TODAS en ovl7**
- **Símbolos de ovl7**: TODOS DEFINIDOS ✅
- **Problema**: Las funciones siguen sin hacer MATCH a pesar de tener símbolos

---

## 🔴 Problema Identificado

### Símbolos Resueltos ✅
Los 52 símbolos de ovl7 ya están definidos en `undefined_syms_all.txt`:
```
D_80042224_ovl7 = 0x80042224;
D_8005205C_ovl7 = 0x8005205C;
D_80042E74_ovl7 = 0x80042E74;
... (etc)
```

### Problema Persistente ❌
Las 40 funciones de ovl7 **siguen sin hacer MATCH** a pesar de tener los símbolos definidos. Esto indica:

1. **Las funciones no se están compilando correctamente**, O
2. **Los archivos .c de ovl7 no están siendo enlazados**, O
3. **El assembly generado difiere significativamente del original**

---

## 🔍 Investigación Pendiente

### Hipótesis 1: Archivos C de ovl7 no se están compilando
Verificar si `src/ovl7/*.c` está en el Makefile.

### Hipótesis 2: El código C genera assembly diferente
Las funciones de ovl7 pueden requerir patrones específicos de C (como los delay slots que descubrimos).

### Hipótesis 3: Problema de secciones/overlay
El linker puede no estar colocando el código de ovl7 en la dirección correcta.

---

## 🚀 Comandos para Continuar en Casa

### 1. Verificar que ovl7 está en el Makefile
```bash
grep -r "ovl7" Makefile
grep -r "ovl7" evangelion.yaml
```

### 2. Revisar los archivos C de ovl7
```bash
ls -la src/ovl7/
head -50 src/ovl7/*.c
```

### 3. Verificar que las funciones se compilan
```bash
# Después de make, verificar si existen los objetos
ls build/src/ovl7/
```

### 4. Comparar una función específica
```bash
# Ejemplo: primera función de ovl7
python3 tools/compare_function.py 0x175860 1124
```

### 5. Ver el assembly generado vs original
```bash
# Assembly original
head -50 asm/nonmatchings/ovl7/code_175860/func_80025E20_ovl7.s

# Después de compilar, ver qué hay en el build
dx build/eva.z64 0x175860 0x175860+1124
```

---

## 📁 Archivos Modificados Hoy

| Archivo | Cambio |
|---------|--------|
| `undefined_syms_all.txt` | Añadidos 52 símbolos base de ovl7 |
| `tools/fix_ovl7_syms.py` | Script para añadir símbolos automáticamente |
| `tools/audit_matching.py` | Arreglado encoding (emojis removidos) |
| `WORKSPACE_FIX_OVL7.md` | Este archivo - documentación del trabajo |

---

## 🎯 Próximos Pasos

1. **Verificar si ovl7.c está siendo compilado**
   - Si no está en Makefile, agregarlo
   - Si está, revisar el código generado

2. **Investigar el linker script**
   - Verificar que ovl7 se enlace en la dirección correcta (0x175860)

3. **Comparar byte por byte**
   - Usar `compare_function.py` para ver qué bytes difieren exactamente

4. **Posible solución temporal**
   - Si no podemos arreglar ovl7 rápidamente, usar el assembly original en lugar del C

---

## 💡 Notas Importantes

- **Los overlays se cargan dinámicamente**: No están siempre en memoria
- **Direcciones VRAM**: ovl7 se carga en 0x800XXXXX (direcciones altas)
- **El problema NO son los símbolos**: Ya están todos definidos
- **El problema es el código**: Las funciones generan bytes diferentes

---

## 📞 Siguiente Paso (Cuando Vuelvas)

1. Ejecuta: `python3 tools/compare_function.py 0x175860 1124`
2. Esto mostrará los bytes exactos que difieren
3. Basado en eso, determinar si es problema de símbolos, compilación o código
4. Si es código, comparar el assembly original vs el generado

---

*Trabajo en progreso - Sistema de archivos de documentación*
*Actualizado: 2026-02-05 15:30*
*Situación: Símbolos arreglados, pero funciones aún con DIFF - investigar código C*
