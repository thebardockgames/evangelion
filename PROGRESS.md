# Progreso del Proyecto - Evangelion 64 Decompilation

## 📅 Última actualización
**Fecha**: 2026-02-05  
**Estado**: 985/1025 funciones hacen MATCH (96%). Solo quedan 40 funciones DIFF en ovl7

---

## ✅ Completado

### Setup Inicial
- [x] `make setup` ejecutado exitosamente
- [x] splat64 instalado y configurado
- [x] Toolchain MIPS (GCC 2.7.2 + binutils) instalado
- [x] Assembly extraído del ROM (carpeta `asm/`)
- [x] Makefile modificado para usar toolchains modernos
- [x] Macros de compatibilidad añadidas (`macro.inc`)

### Sistema de Trabajo
- [x] `KIMI_CONTEXT.md` - Documentación de contexto global
- [x] `WORKFLOW.md` - Guía del sistema híbrido Kimi+Humano
- [x] `WORKSPACE_func_800AA550.md` - Análisis de primera función

### Primera Función Analizada
- [x] `func_800AA550` analizada completamente
- [x] Código C generado
- [x] Problema de delay slot identificado
- [x] Función revertida a INCLUDE_ASM (solución temporal)

---

## 🔄 Estado Actual del Build

### Compilación
```bash
make clean && make
# Resultado: ✅ COMPILA EXITOSAMENTE
```

### Matching (sha1sum)
```bash
sha1sum -c evangelion.sha1
# Resultado: ❌ FAILED
# Diferencias en: offset 0x3E738+ (sección de datos)
```

### Problemas Conocidos

#### 1. Delay Slot en GCC 2.7.2
- **Ubicación**: `func_800AA550` (y potencialmente otras)
- **Problema**: GCC reordena `jr $ra` y pone instrucciones en delay slot
- **Original**: `sh` → `jr $ra` → `nop`
- **Generado**: `jr $ra` → `sh` (en delay slot)
- **Solución temporal**: Usar INCLUDE_ASM
- **Solución ideal**: Encontrar flag de compilación o pragma para forzar orden

#### 2. Diferencias en Sección de Datos
- **Ubicación**: Offset 0x3E738 en ROM
- **Archivo**: `asm/data/3E7B0.data.s`
- **Posible causa**: Alineación de variables globales o padding
- **Investigar**: Verificar `.align` directives y orden de variables

---

## 📋 Instrucciones para Continuar

### 1. Pre-requisitos (nueva computadora)

```bash
# Instalar dependencias del sistema
sudo apt update
sudo apt install -y build-essential binutils-mips-linux-gnu pipx

# Instalar splat64
pipx install splat64
pipx inject splat64 spimdisasm==1.39.0 n64img pygfxd crunch64

# Configurar PATH
export PATH="$HOME/.local/bin:$PATH"
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

# Crear symlinks para toolchain
mkdir -p ~/.local/bin
ln -sf /mnt/d/Proyectos/evangelion/tools/gcc_kmc/linux/2.7.2/gcc ~/.local/bin/mips-n64-gcc
ln -sf /mnt/d/Proyectos/evangelion/tools/gcc_kmc/linux/2.7.2/as ~/.local/bin/mips-n64-as
ln -sf $(which mips-linux-gnu-ld) ~/.local/bin/mips-n64-ld
ln -sf $(which mips-linux-gnu-objcopy) ~/.local/bin/mips-n64-objcopy
```

### 2. Preparar ROM

```bash
# Colocar el ROM original
# cp /ruta/a/evangelion.z64 ./evangelion.z64

# Extraer assets (si no están en el repo)
make setup
```

### 3. Compilar y verificar

```bash
make clean
make
sha1sum -c evangelion.sha1
```

---

## 🎉 Avances del Día (05 Feb 2026)

### Herramientas Creadas
1. **`tools/compare_function.py`** - Verificación rápida de funciones (5s vs 10min)
2. **`tools/audit_matching.py`** - Auditoría global de todas las funciones
3. **`tools/fix_ovl7_syms.py`** - Script para auto-arreglar símbolos de ovl7

### Funciones con MATCH (5 totales)
Todas en `src/code_1050.c`:
| Función | Offset | Tamaño | Patrón Crítico |
|---------|--------|--------|----------------|
| `func_80097130` | 0x1D30 | 8 bytes | Setter simple |
| `func_80097144` | 0x1D44 | 8 bytes | Setter simple |
| `func_80097124` | 0x1D24 | 12 bytes | Array clear |
| `func_800964FC` | 0x10FC | 20 bytes | `return abs(a0)` |
| `func_80096450` | 0x1050 | 24 bytes | Delay loop `i=15` |

### Lecciones Clave
- **Delay Slot Rule**: Para funciones con `jr $ra` delay slots, usar `return abs(x)` en lugar de manual if/else
- **Loop counts**: GCC 2.7.2 optimiza loops; el valor inicial puede diferir del esperado
- **Pattern matching**: Es más fácil ver el assembly y escribir C que genere el mismo que hacerlo al revés

### Problema de ovl7 Identificado
- **40 funciones** en ovl7 (overlay 7) no hacen MATCH
- **Causa**: Símbolos de datos (`D_80042224_ovl7`, etc.) no definidos
- **Solución aplicada**: Script agregó 52 símbolos a `undefined_syms_all.txt`
- **Estado**: Símbolos definidos ✅, pero funciones siguen con DIFF - investigar código C de ovl7

### Métricas Actuales
```
[OK] MATCH:     985 funciones (96%)
[XX] DIFF:      40 funciones (4%) - todas en ovl7
[!!] NO OFFSET: 0 funciones
[EE] ERROR:     0 funciones
```

---

## 🎯 Próximos Objetivos

### Prioridad Alta (En Casa)
1. [ ] **Investigar por qué ovl7 sigue con DIFF**
   - Verificar si archivos C de ovl7 se están compilando
   - Comparar assembly original vs generado byte por byte
   - Archivo de trabajo: `WORKSPACE_FIX_OVL7.md`

2. [ ] **Resolver matching de datos**
   - Analizar diferencias en offset 0x3E738
   - Verificar alineación en `asm/data/3E7B0.data.s`
   - Comparar con ROM original byte por byte

2. [ ] **Encontrar solución para delay slot**
   - Investigar flags de GCC: `-fno-delayed-branch`, `-mno-branch-likely`
   - Probar con `#pragma` para desactivar optimización
   - O usar `asm volatile` para forzar orden exacto

### Prioridad Media
3. [ ] **Decompilar función más simple**
   - Buscar función sin `jr $ra` al final
   - Ejemplo: función que solo calcula y retorna valor
   - Verificar matching exitoso

4. [ ] **Documentar estructuras**
   - Identificar structs usados en funciones decompiladas
   - Documentar en `include/structs.h`

### Prioridad Baja
5. [ ] **Automatizar verificación**
   - Script que compare ROMs y reporte diferencias
   - Integrar con workflow de Kimi

---

## 📁 Archivos Importantes

| Archivo | Propósito |
|---------|-----------|
| `KIMI_CONTEXT.md` | Contexto global del proyecto |
| `WORKFLOW.md` | Guía del sistema de trabajo híbrido |
| `WORKSPACE_func_800AA550.md` | Análisis de primera función (delay slot issue) |
| `WORKSPACE_func_80097130.md` | Análisis de primera función con MATCH ✅ |
| `SETUP_WSL.md` | Instrucciones de setup para WSL |
| `FIX_PATH.md` | Solución a problemas de PATH |
| `macro.inc` | Macros de compatibilidad para assembly |
| `Makefile` | Modificado para toolchains modernos |

---

## 🔧 Configuración del Makefile (Resumen)

Cambios realizados al Makefile original:

```makefile
# Línea 108 - Usar ensamblador moderno para archivos .s
$(BUILD_DIR)/%.o: %.s $(SZP_FILES)
	@printf "[ASM] $@\n"
	$(V)mips-linux-gnu-as -march=vr4300 -mabi=32 -I. -I$(BUILD_DIR) -o $@ $<

# Línea 58 - Flags simplificadas
ASFLAGS := -mips3 -Iinclude -I. -I$(BUILD_DIR)
```

---

## 📝 Notas para el Siguiente Desarrollador

1. **No borrar `asm/`**: Contiene el assembly original extraído por splat
2. **Preservar `macro.inc`**: Contiene macros necesarias para compatibilidad
3. **Verificar toolchain**: `mips-n64-gcc --version` debe mostrar 2.7.2
4. **Probar matching frecuentemente**: Ejecutar `sha1sum -c evangelion.sha1` después de cada cambio

---

## 🐛 Issues Conocidos

### Issue #1: Delay Slot
**Archivo**: `src/code_15150.c` - `func_800AA550`  
**Descripción**: GCC reordena instrucciones en delay slot  
**Workaround**: Usar INCLUDE_ASM  
**Fix ideal**: Investigar flags de compilación

### Issue #2: Matching de datos
**Ubicación**: Offset 0x3E738 en ROM  
**Descripción**: Diferencias en sección de datos globales  
**Investigar**: Alineación (.align), padding, orden de variables

---

## 🏆 Victorias

### Primera Función con MATCH (2026-02-04)
**Función**: `func_80097130`  
**Archivo**: `src/code_1050.c`  
**Tamaño**: 8 bytes  
**Tipo**: Setter simple  
**Código**: `((s32*)arg0)[1] = arg1;`

```bash
$ python3 tools/compare_function.py 0x1D30 8
[MATCH] Offset 0x001D30 (8 bytes) - PERFECT MATCH!
```

**Lección**: Las funciones pequeñas sin delay slot complicado son ideales para empezar.

---

## 📊 Estadísticas

- **Funciones totales**: 1025
- **Funciones con MATCH**: 985 ✅ (96%)
- **Funciones con DIFF**: 40 ❌ (4%) - todas en ovl7
- **Funciones decompiladas**: 5 (`code_1050.c`)
- **Build**: ✅ Compila
- **Matching ROM**: ❌ (faltan 40 funciones de ovl7)

---

## 💡 Tips

- Usar `NON_MATCHING=1` para compilar sin verificar matching: `make NON_MATCHING=1`
- Comparar bytes específicos: `cmp -l evangelion.z64 build/eva.z64`
- Ver assembly generado: `mips-linux-gnu-objdump -d build/src/code_XXXXX.o`

---

*Generado automáticamente - Sistema de Decompilación Híbrido*
*Para continuar, seguir instrucciones en sección "Instrucciones para Continuar"*
