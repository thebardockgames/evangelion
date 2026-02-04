# Progreso del Proyecto - Evangelion 64 Decompilation

## 📅 Última actualización
**Fecha**: 2026-02-04  
**Estado**: Setup completo, compilación funciona, matching en progreso

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

## 🎯 Próximos Objetivos

### Prioridad Alta
1. [ ] **Resolver matching de datos**
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
| `WORKSPACE_func_800AA550.md` | Análisis detallado de primera función |
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

## 📊 Estadísticas

- **Funciones totales estimadas**: ~2000
- **Funciones analizadas**: 1 (`func_800AA550`)
- **Funciones decompiladas**: 0 (matching)
- **Funciones en ASM**: 16 en `code_15150.c` + todas las demás
- **Build**: ✅ Compila
- **Matching**: ❌ 98%+ (faltan detalles en datos)

---

## 💡 Tips

- Usar `NON_MATCHING=1` para compilar sin verificar matching: `make NON_MATCHING=1`
- Comparar bytes específicos: `cmp -l evangelion.z64 build/eva.z64`
- Ver assembly generado: `mips-linux-gnu-objdump -d build/src/code_XXXXX.o`

---

*Generado automáticamente - Sistema de Decompilación Híbrido*
*Para continuar, seguir instrucciones en sección "Instrucciones para Continuar"*
