# Progreso del Proyecto - Evangelion 64 Decompilation

## 📅 Última actualización
**Fecha**: 2026-02-06  
**Estado**: ✅ **ROM COMPILA CON MATCHING 100%** - SHA1 verificado correctamente

---

## 🎯 Estado Actual

```
✅ SHA1 ORIGINAL:  A9BA0A4AFEED48080F54AA237850F3676B3D9980
✅ SHA1 COMPILADO: A9BA0A4AFEED48080F54AA237850F3676B3D9980
✅ RESULTADO: MATCH PERFECTO - El ROM generado es idéntico al original
```

### Métricas de Funciones
```
[OK] MATCH:     ~985 funciones compiladas correctamente
[XX] DIFF:      0 funciones (todas resueltas)
[!!] NO OFFSET: 0 funciones
[EE] ERROR:     0 funciones
```

---

## 🚀 CÓMO EMPEZAR DESDE CERO (Guía Completa)

Esta guía es para configurar el proyecto en una computadora completamente nueva, paso a paso.

### Paso 1: Instalar el Sistema Operativo Base

**Opción A: Windows con WSL (Recomendado)**
1. Abre PowerShell como Administrador
2. Ejecuta: `wsl --install`
3. Reinicia la computadora
4. Al abrirse Ubuntu, crea un usuario y contraseña

**Opción B: Linux nativo**
- Cualquier distribución Ubuntu/Debian funciona

### Paso 2: Instalar Dependencias del Sistema

Abre una terminal (WSL si estás en Windows) y ejecuta:

```bash
# Actualizar paquetes
sudo apt update
sudo apt upgrade -y

# Instalar herramientas básicas
sudo apt install -y build-essential git wget python3 python3-pip

# Instalar binutils de MIPS (ensamblador y linker moderno)
sudo apt install -y binutils-mips-linux-gnu

# Instalar pipx (para instalar splat64 sin conflictos)
sudo apt install -y pipx
```

### Paso 3: Instalar splat64 (Herramienta de Extracción)

```bash
# Instalar splat64 usando pipx
pipx install splat64

# Añadir dependencias adicionales que necesita splat64
pipx inject splat64 spimdisasm==1.39.0 n64img pygfxd crunch64

# Asegurar que pipx esté en el PATH
export PATH="$HOME/.local/bin:$PATH"
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Verificar que splat64 está instalado
splat64 --help
```

### Paso 4: Descargar el Repositorio

```bash
# Ir a la carpeta donde quieras guardar el proyecto
cd ~
# O en Windows (recomendado para acceso fácil):
cd /mnt/c/Users/TuUsuario/Documents

# Clonar el repositorio
git clone <URL_DEL_REPOSITORIO> evangelion
cd evangelion
```

### Paso 5: Instalar el Toolchain de Compilación (GCC 2.7.2)

Este proyecto usa una versión específica y antigua del compilador GCC para poder generar código idéntico al original.

```bash
# El toolchain ya viene incluido en el repositorio en la carpeta tools/
# Verificar que existe:
ls -la tools/gcc_kmc/linux/2.7.2/

# Deberías ver: gcc, as, cc1, etc.
```

### Paso 6: Configurar los Symlinks del Toolchain

Crea enlaces simbólicos para que el Makefile encuentre los compiladores:

```bash
# Crear carpeta bin local si no existe
mkdir -p ~/.local/bin

# Crear symlinks para el toolchain antiguo
ln -sf $(pwd)/tools/gcc_kmc/linux/2.7.2/gcc ~/.local/bin/mips-n64-gcc
ln -sf $(pwd)/tools/gcc_kmc/linux/2.7.2/as ~/.local/bin/mips-n64-as

# Crear symlinks para las herramientas modernas de MIPS
ln -sf $(which mips-linux-gnu-ld) ~/.local/bin/mips-n64-ld
ln -sf $(which mips-linux-gnu-objcopy) ~/.local/bin/mips-n64-objcopy

# Verificar que funcionan
mips-n64-gcc --version  # Debe mostrar 2.7.2
mips-n64-as --version   # Debe mostrar 2.7.2
```

### Paso 7: Preparar el ROM Original

Necesitas el ROM original del juego "Neon Genesis Evangelion" para Nintendo 64:

```bash
# Copiar tu ROM al directorio del proyecto
# (Reemplaza /ruta/a/tu/rom con la ubicación real)
cp /ruta/a/tu/rom/evangelion.z64 ./evangelion.z64

# Verificar que el SHA1 sea correcto
sha1sum evangelion.z64
# Debe mostrar: a9ba0a4afeed48080f54aa237850f3676b3d9980
```

### Paso 8: Extraer Assets y Configurar

```bash
# Ejecutar el setup inicial
make setup

# Este comando:
# - Extrae todos los assets del ROM
# - Genera el assembly de las funciones
# - Crea los archivos de configuración
```

### Paso 9: Compilar el Proyecto

```bash
# Limpiar builds anteriores (si los hay)
make clean

# Compilar todo el proyecto
make

# Verificar que compila exitosamente
# Deberías ver muchos mensajes de "[CC]" y "[ASM]"
```

### Paso 10: Verificar el Matching

```bash
# Comparar el ROM generado con el original
sha1sum -c evangelion.sha1

# Si dice "OK", ¡felicidades! El proyecto está configurado correctamente
```

**Resultado esperado:**
```
evangelion.z64: OK
```

---

## 🔄 FASE ACTUAL: Conversión de Assembly a C

### Objetivo
Convertir las funciones actualmente en assembly (`.s`) a código C (`.c`) manteniendo el **matching 100%**.

### Qué significa "matching"
- El código C escrito debe compilar y generar **bytes idénticos** al assembly original
- El ROM resultante debe seguir pasando la verificación SHA1
- Si se modifica una función y el SHA1 cambia, hay que ajustar el código C

### Estructura del Proyecto

```
asm/nonmatchings/     <- Assembly original extraído por splat
src/                  <- Código C que reemplaza al assembly
  code_1050.c         <- Funciones decompiladas con éxito
  ovl7/               <- Overlay 7 (en progreso)
  ovlXX/              <- Otros overlays
```

---

## 📊 Funciones Decompiladas con MATCH (5 totales)

Todas en `src/code_1050.c`:

| Función | Offset | Tamaño | Tipo | Código C |
|---------|--------|--------|------|----------|
| `func_80097130` | 0x1D30 | 8 bytes | Setter simple | `((s32*)arg0)[1] = arg1;` |
| `func_80097144` | 0x1D44 | 8 bytes | Setter simple | `((s32*)arg0)[2] = arg1;` |
| `func_80097124` | 0x1D24 | 12 bytes | Array clear | Loop de 3 elementos |
| `func_800964FC` | 0x10FC | 20 bytes | `abs()` | `return (x < 0) ? -x : x;` |
| `func_80096450` | 0x1050 | 24 bytes | Delay loop | `i=15` loop count |

---

## 🔧 Herramientas Disponibles

### 1. `tools/compare_function.py`
Compara una función específica entre el ROM original y el compilado:
```bash
python3 tools/compare_function.py 0x1D30 8
# [MATCH] Offset 0x001D30 (8 bytes) - PERFECT MATCH!
```

### 2. `tools/audit_matching.py`
Auditoría global de todas las funciones:
```bash
python3 tools/audit_matching.py
# Muestra estadísticas de MATCH/DIFF/ERROR
```

### 3. `tools/fix_ovl7_syms.py`
Script para arreglar símbolos de ovl7 (ya ejecutado, todos los símbolos definidos).

---

## 📝 Lecciones Aprendidas

### Delay Slot Rule
Para funciones con `jr $ra` delay slots, usar `return abs(x)` en lugar de manual if/else.

### Loop Counts
GCC 2.7.2 optimiza loops; el valor inicial puede diferir del esperado.

### Pattern Matching
Es más fácil ver el assembly y escribir C que genere el mismo que hacerlo al revés.

---

## 🎯 Próximos Objetivos

### Prioridad Alta
1. [ ] **Seguir decompilando funciones simples**
   - Buscar funciones pequeñas sin delay slot complicado
   - Ejemplos: setters, getters, funciones matemáticas simples

2. [ ] **Documentar estructuras**
   - Identificar structs usados en funciones decompiladas
   - Documentar en `include/structs.h`

3. [ ] **Atacar ovl7**
   - El overlay 7 tiene muchas funciones para decompilar
   - Usar `WORKSPACE_FIX_OVL7.md` como referencia

### Prioridad Media
4. [ ] **Crear más herramientas de análisis**
   - Script para encontrar funciones "fáciles" (pequeñas, sin branches)
   - Automatizar comparación de funciones

### Prioridad Baja
5. [ ] **Documentación**
   - Documentar el proceso de decompilación
   - Crear guía de patrones comunes

---

## 📁 Archivos Importantes

| Archivo | Propósito |
|---------|-----------|
| `KIMI_CONTEXT.md` | Contexto global del proyecto |
| `WORKFLOW.md` | Guía del sistema de trabajo híbrido |
| `WORKSPACE_func_800AA550.md` | Análisis de función con delay slot |
| `WORKSPACE_func_80097130.md` | Análisis de primera función con MATCH ✅ |
| `WORKSPACE_FIX_OVL7.md` | Documentación del trabajo en ovl7 |
| `SETUP_WSL.md` | Instrucciones de setup para WSL |
| `macro.inc` | Macros de compatibilidad para assembly |
| `Makefile` | Configuración de compilación |

---

## 🔧 Comandos Útiles para el Día a Día

```bash
# Compilar y verificar matching (hábito diario)
make clean && make && sha1sum -c evangelion.sha1

# Verificar una función específica rápidamente
python3 tools/compare_function.py 0xOFFSET TAMAÑO

# Ver el assembly de un archivo objeto
mips-linux-gnu-objdump -d build/src/code_XXXXX.o

# Buscar funciones pequeñas para decompilar
grep -r "func_" asm/nonmatchings/ | wc -l
```

---

## 🐛 Debug: Qué hacer si algo falla

### Error: "mips-n64-gcc: command not found"
```bash
# Recrear symlinks (Paso 6)
ln -sf $(pwd)/tools/gcc_kmc/linux/2.7.2/gcc ~/.local/bin/mips-n64-gcc
ln -sf $(pwd)/tools/gcc_kmc/linux/2.7.2/as ~/.local/bin/mips-n64-as
```

### Error: SHA1 no coincide después de cambios
```bash
# Esto es NORMAL cuando decompilas una función nueva
# Usa compare_function.py para ver qué bytes difieren
python3 tools/compare_function.py 0xOFFSET TAMAÑO
```

### Error: "undefined reference to D_XXXXXXXX"
```bash
# Falta definir un símbolo en undefined_syms_all.txt
# Añadir: D_XXXXXXXX = 0xXXXXXXXX;
```

---

## 🏆 Logros Desbloqueados

✅ **ROM compila con matching 100%**  
✅ Toolchain configurado correctamente  
✅ Primera función decompilada con MATCH  
✅ Todas las funciones de ovl7 tienen símbolos definidos  

---

*Generado automáticamente*  
*Estado: ROM 100% matching - En fase de decompilación a C*
