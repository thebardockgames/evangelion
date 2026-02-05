# Troubleshooting - Problemas Comunes

## ⚠️ Problema: compare_function.py da MATCH cuando debería dar DIFF

### Síntoma
Cambias el código C (ej: `i = 14` a `i = 15`) pero el script sigue diciendo MATCH.

### Causa
**Solo compilaste el archivo objeto, no el ROM completo.**

```bash
make build/src/code_1050.o  # ❌ Solo genera .o, NO actualiza eva.z64
```

El script compara `evangelion.z64` (original) vs `build/eva.z64` (compilado).
Si no actualizas el ROM, estás comparando con una versión vieja.

### Solución

#### Opción A: Build completo (recomendado para verificación final)
```bash
make
python3 tools/compare_function.py 0xXXXXX <size>
```

#### Opción B: Solo lo necesario (más rápido)
```bash
# Compilar objeto + linkear + generar ROM
make build/src/code_XXXXX.o build/eva.elf build/eva.z64
python3 tools/compare_function.py 0xXXXXX <size>
```

### Verificación
Siempre verifica que el ROM se actualizó:
```bash
ls -la build/eva.z64  # Debe tener fecha/hora reciente
```

---

## ✅ Checklist Antes de Verificar

- [ ] Guardé el archivo .c
- [ ] El archivo build/eva.z64 tiene fecha reciente
- [ ] Hice `make` (no solo `make archivo.o`)

---

## 📝 Nota para Bardock

**Siempre hacer build completo antes de verificar matching:**

```bash
make clean  # Opcional pero recomendado
make
python3 tools/compare_function.py 0xXXXXX <size>
```

*Proyecto personal - Documentando errores para aprender.*
