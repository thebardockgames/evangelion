# Diario de Sesiones - Proyecto Evangelion 64

**Proyecto personal** | Solo Kimi + Bardock | Sin prisa, sin deadlines

---

## Sesión 1: 2026-02-04

### Qué hicimos hoy
1. ✅ Analizamos todo el proyecto (estructura, herramientas, estado)
2. ✅ Configuramos el entorno de desarrollo en WSL
3. ✅ Hicimos `make setup` exitosamente
4. ✅ Resolvemos problemas de toolchain (splat64, GCC 2.7.2, binutils)
5. ✅ Configuramos el Makefile para compilar con herramientas modernas
6. ✅ Añadimos macros de compatibilidad a `macro.inc`
7. ✅ Analizamos nuestra primera función: `func_800AA550`
8. ✅ Intentamos decompilarla (falló por delay slot)
9. ✅ Documentamos TODO el progreso

### Descubrimientos importantes
- **Problema de delay slot**: GCC 2.7.2 reordena instrucciones y pone `sh` en el delay slot del `jr`, pero el original tiene `nop` ahí
- **El build compila**: Llegamos a 98%+ del camino, solo faltan detalles de matching
- **Las diferencias están en datos**: No en código, lo cual es buena señal

### Qué nos bloqueó
- Delay slot en `func_800AA550` - necesitamos investigar flags de GCC o usar inline asm
- Diferencias en sección de datos (0x3E738) - probablemente alineación

### Para la siguiente sesión
- [ ] Investigar flags de GCC para delay slot: `-fno-delayed-branch`, `-mno-branch-likely`
- [ ] O: Buscar una función más simple SIN `jr $ra` al final
- [ ] O: Analizar las diferencias en datos (offset 0x3E738)

### Estado del ánimo
🙂 Satisfactorio - Tenemos el proyecto compilando, documentado y listo para iterar.

---

### 🎉 ¡LOGRO DESBLOQUEADO! - Más tarde en la sesión

**PRIMERA FUNCIÓN CON MATCH EXITOSO**

```bash
$ python3 tools/compare_function.py 0x1D30 8
[MATCH] Offset 0x001D30 (8 bytes) - PERFECT MATCH!
```

**Función**: `func_80097130`  
**Tamaño**: 8 bytes  
**Tipo**: Setter simple  
**Código**: `((s32*)arg0)[1] = arg1;`

**Lección clave**: Las funciones pequeñas sin delay slot complicado son ideales para empezar.

---

## Plantilla para próximas sesiones

### Fecha: [YYYY-MM-DD]

### Qué hicimos hoy
- [ ] 

### Problemas encontrados
- 

### Soluciones aplicadas
- 

### Para la siguiente sesión
- [ ] 

### Notas random
- 

---

## Checklist General del Proyecto

### Fase 1: Setup (COMPLETADA) ✅
- [x] ROM extraído
- [x] Toolchain funcionando
- [x] Build compilando
- [x] Documentación inicial

### Fase 2: Primer Matching (EN PROGRESO)
- [ ] Entender delay slot problem
- [ ] Decompilar primera función con matching 100%
- [ ] Documentar el proceso

### Fase 3: Escalar (PENDIENTE)
- [ ] Decompilar 10 funciones
- [ ] Decompilar 100 funciones
- [ ] Documentar estructuras principales

### Fase 4: Completar (FUTURO LEJANO)
- [ ] 50% del proyecto
- [ ] 100% del proyecto
- [ ] Documentación completa

---

## Notas técnicas rápidas

### Comandos útiles
```bash
# Compilar y verificar
make clean && make && sha1sum -c evangelion.sha1

# Ver diferencias
cmp -l evangelion.z64 build/eva.z64 | head -20

# Ver assembly de objeto
mips-linux-gnu-objdump -d build/src/code_XXXXX.o
```

### Variables importantes
- SHA1 objetivo: `a9ba0a4afeed48080f54aa237850f3676b3d9980`
- Offset de nuestra función: `0x15150` (ROM) / `0x800AA550` (VRAM)
- Diferencias actuales: `0x3E738` (datos)

---

*Este archivo es solo para nosotros. Sin formalidades, sin presión.*
