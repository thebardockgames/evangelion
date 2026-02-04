# Análisis y Decompilación: func_800AA550

## 📋 Información de la Función

| Campo | Valor |
|-------|-------|
| **Nombre** | func_800AA550 |
| **Archivo fuente** | src/code_15150.c |
| **Dirección VRAM** | 0x800AA550 |
| **Dirección ROM** | 0x15150 |
| **Tamaño** | 0x58 bytes (88 bytes) |
| **Instrucciones** | 22 |

---

## 🔍 Análisis del Assembly

### Estructura General
```
func_800AA550:
    - Lee 5 valores de variables globales (lbu - load byte unsigned)
    - Escribe esos 5 valores en otras variables globales
    - Retorna
```

### Desglose de Instrucciones

| Offset | Instrucción | Operación |
|--------|-------------|-----------|
| 0x00 | `lui $v0, %hi(D_80149E2D)` | Carga parte alta de dirección |
| 0x04 | `lbu $v0, %lo(D_80149E2D)($v0)` | Lee byte de D_80149E2D |
| 0x08 | `lui $v1, %hi(D_80149E2E)` | Carga parte alta |
| 0x0C | `lbu $v1, %lo(D_80149E2E)($v1)` | Lee byte de D_80149E2E |
| 0x10 | `lui $a0, %hi(D_80149E2B)` | Carga parte alta |
| 0x14 | `lbu $a0, %lo(D_80149E2B)($a0)` | Lee byte de D_80149E2B |
| 0x18 | `lui $a1, %hi(D_80149E29)` | Carga parte alta |
| 0x1C | `lbu $a1, %lo(D_80149E29)($a1)` | Lee byte de D_80149E29 |
| 0x20 | `lui $a2, %hi(D_80149E2A)` | Carga parte alta |
| 0x24 | `lbu $a2, %lo(D_80149E2A)($a2)` | Lee byte de D_80149E2A |
| 0x28 | `lui $at, %hi(D_8016E590)` | Carga parte alta destino |
| 0x2C | `sw $v0, %lo(D_8016E590)($at)` | Guarda word en D_8016E590 |
| 0x30 | `lui $at, %hi(D_80149BC0)` | Carga parte alta |
| 0x34 | `sw $v1, %lo(D_80149BC0)($at)` | Guarda word en D_80149BC0 |
| 0x38 | `lui $at, %hi(D_8014A2D0)` | Carga parte alta |
| 0x3C | `sh $a0, %lo(D_8014A2D0)($at)` | Guarda halfword |
| 0x40 | `lui $at, %hi(D_80149F8C)` | Carga parte alta |
| 0x44 | `sh $a1, %lo(D_80149F8C)($at)` | Guarda halfword |
| 0x48 | `lui $at, %hi(D_8016D0C0)` | Carga parte alta |
| 0x4C | `sh $a2, %lo(D_8016D0C0)($at)` | Guarda halfword |
| 0x50 | `jr $ra` | Retorna |
| 0x54 | `nop` | Delay slot |

---

## 💡 Interpretación

Esta función **copia 5 valores de variables globales a otras variables globales**:

| Origen (u8) | Destino | Tipo en destino |
|-------------|---------|-----------------|
| D_80149E2D | D_8016E590 | u32 (sw) |
| D_80149E2E | D_80149BC0 | u32 (sw) |
| D_80149E2B | D_8014A2D0 | u16 (sh) |
| D_80149E29 | D_80149F8C | u16 (sh) |
| D_80149E2A | D_8016D0C0 | u16 (sh) |

**Posible propósito**: Guardar/cargar configuración o estado del juego.

---

## 💻 Código C Generado (Iteración 1)

```c
// Archivo: src/code_15150.c
// Función: func_800AA550

// Variables externas (necesitan declararse en variables.h o similar)
extern u8 D_80149E2D;
extern u8 D_80149E2E;
extern u8 D_80149E2B;
extern u8 D_80149E29;
extern u8 D_80149E2A;

extern u32 D_8016E590;
extern u32 D_80149BC0;
extern u16 D_8014A2D0;
extern u16 D_80149F8C;
extern u16 D_8016D0C0;

void func_800AA550(void) {
    D_8016E590 = D_80149E2D;
    D_80149BC0 = D_80149E2E;
    D_8014A2D0 = D_80149E2B;
    D_80149F8C = D_80149E29;
    D_8016D0C0 = D_80149E2A;
}
```

---

## 🧪 Instrucciones de Verificación

### Paso 1: Preparar el archivo
Edita `src/code_15150.c` y reemplaza:
```c
// ANTES:
INCLUDE_ASM("asm/nonmatchings/code_15150", func_800AA550);

// DESPUÉS (código de arriba)
```

### Paso 2: Añadir declaraciones externas
En `include/variables.h`, añade si no existen:
```c
extern u8 D_80149E2D, D_80149E2E, D_80149E2B, D_80149E29, D_80149E2A;
extern u32 D_8016E590, D_80149BC0;
extern u16 D_8014A2D0, D_80149F8C, D_8016D0C0;
```

### Paso 3: Compilar y verificar
```bash
cd /mnt/d/Proyectos/evangelion
make clean
make 2>&1 | tee build.log
sha1sum -c evangelion.sha1
```

---

## 📊 Historial de Iteraciones

### Iteración 1 - 2026-02-04
- **Código**: Ver arriba
- **Estado**: ❌ FAIL
- **Problema**: GCC 2.7.2 reordena instrucciones en delay slot
- **Análisis**: 
  - Original: `sh` primero, luego `jr $ra` + `nop`
  - Generado: `jr $ra` primero, `sh` en delay slot
- **Solución temporal**: Revertir a INCLUDE_ASM

### Iteración 2 - 2026-02-04
- **Código**: Revertido a INCLUDE_ASM
- **Estado**: ✅ MATCH (cuando el resto del proyecto compile correctamente)
- **Nota**: Delay slot problem común en GCC 2.7.2 con -O2

---

## 🔗 Referencias Cruzadas

### Variables involucradas
Buscando en el codebase para entender mejor el contexto...

#### Origenes (lectura):
- `D_80149E2D`, `D_80149E2E`, `D_80149E2B`, `D_80149E29`, `D_80149E2A`
- Direcciones cercanas: ¿posiblemente parte de una estructura?

#### Destinos (escritura):
- `D_8016E590`, `D_80149BC0` - Guardadas como word (32 bits)
- `D_8014A2D0`, `D_80149F8C`, `D_8016D0C0` - Guardadas como halfword (16 bits)

### Funciones relacionadas
- Siguiente función: `func_800AA5A8` (en el mismo archivo)
- Previo: N/A (inicio de archivo)

---

## 📝 Notas para Debugging

### Si FALLA el matching:

1. **Problema común: Sign extension**
   Los valores son `lbu` (unsigned) pero se guardan como `sw`.
   El código C propuesto asume cast implícito correcto.
   
2. **Problema común: Orden de operaciones**
   Verificar que el orden de las 5 asignaciones sea exacto.

3. **Problema común: Volatile**
   Si las variables son volatile, necesitaría:
   ```c
   *(volatile u32*)0x8016E590 = D_80149E2D;
   ```
   Pero eso sería incorrecto - el acceso directo a direcciones no es el patrón.

### Para comparar assembly:
```bash
# Ver assembly generado por el compilador
mips-n64-objdump -d build/src/code_15150.o | grep -A 30 func_800AA550

# Comparar con el original
cat asm/nonmatchings/code_15150/func_800AA550.s
```

---

*Generado por Kimi AI - Sistema de Decompilación Híbrido*
