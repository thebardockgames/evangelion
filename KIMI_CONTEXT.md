# Contexto de Trabajo - Kimi AI
## Proyecto: Neon Genesis Evangelion 64 Decompilation

---

## 🎯 Objetivo Actual
Demostración de sistema híbrido: Analizar y decompilar `src/code_15150.c`

---

## 📊 Estado General del Proyecto

### Estadísticas
- **Archivos fuente C**: 322
- **Headers**: 46
- **Funciones estimadas**: ~2,000+
- **SHA1 objetivo**: `a9ba0a4afeed48080f54aa237850f3676b3d9980`
- **VRAM base**: 0x80096400

### Progreso por Módulos
| Módulo | Archivos | Estado | Complejidad |
|--------|----------|--------|-------------|
| src/main.c | 1 | 🟢 100% | Baja |
| src/os/ | 2 | 🟢 100% | Baja |
| src/code_*.c | ~300 | 🔴 0-5% | Media-Alta |
| src/ovl1/ | ~16 | 🔴 ~5% | Media |
| src/ovl2/ | ~12 | 🔴 ~5% | Media |
| src/ovl3/ | ~7 | 🔴 ~5% | Media |
| src/ovl7/ | ~1 | 🟡 ~50% | Baja |

**Leyenda**: 🟢 Completado | 🟡 En progreso | 🔴 No iniciado

---

## 🔬 Análisis Detallado: code_15150.c

### Información General
- **Archivo**: `src/code_15150.c`
- **Tamaño**: 1,013 bytes
- **Dirección ROM**: 0x15150
- **Dirección VRAM**: 0x800AA550
- **Funciones**: 16

### Funciones Identificadas

| # | Nombre | Dirección VRAM | Tamaño Est. | Estado | Tipo Hipótesis |
|---|--------|----------------|-------------|--------|----------------|
| 1 | func_800AA550 | 0x800AA550 | 88 bytes | ⏸️ | Copia de variables globales | Revertido a ASM - delay slot problem |
| 2 | func_800AA5A8 | 0x800AA5A8 | ~128 bytes | 🔴 | - |
| 3 | func_800AA628 | 0x800AA628 | ~232 bytes | 🔴 | - |
| 4 | func_800AA710 | 0x800AA710 | ~232 bytes | 🔴 | - |
| 5 | func_800AA7F8 | 0x800AA7F8 | ~268 bytes | 🔴 | - |
| 6 | func_800AA924 | 0x800AA924 | ~580 bytes | 🔴 | - |
| 7 | func_800AAA88 | 0x800AAA88 | ~628 bytes | 🔴 | - |
| 8 | func_800AACAC | 0x800AACAC | ~316 bytes | 🔴 | - |
| 9 | func_800AADC8 | 0x800AADC8 | ~568 bytes | 🔴 | - |
| 10 | func_800AAFE0 | 0x800AAFE0 | ~148 bytes | 🔴 | - |
| 11 | func_800AB074 | 0x800AB074 | ~228 bytes | 🔴 | - |
| 12 | func_800AB158 | 0x800AB158 | ~244 bytes | 🔴 | - |
| 13 | func_800AB24C | 0x800AB24C | ~540 bytes | 🔴 | - |
| 14 | func_800AB468 | 0x800AB468 | ~208 bytes | 🔴 | - |
| 15 | func_800AB538 | 0x800AB538 | ~184 bytes | 🔴 | - |
| 16 | func_800AB5F0 | 0x800AB5F0 | ? | 🔴 | - |

### Análisis de Contexto
- **Ubicación en ROM**: Entre 0x15150 y 0x162C0
- **Siguiente archivo**: code_162C0.c (0x162C0)
- **Espacio disponible**: ~4,400 bytes
- **Funciones por archivo**: 16 funciones relacionadas

### Notas de Investigación
- Las direcciones sugieren funciones de gameplay o estado
- El nombre del archivo (code_15150) indica offset ROM
- Tamaños variables sugieren diversidad de propósitos

---

## 📝 Estructuras Descubiertas

### De include/structs.h
```c
typedef struct {
    u16 *str;
    s8 wdSpacing;
    s8 htSpacing;
    u8 p3;
    u8 p4;
} FontParams;

typedef struct {
    u32 _000;
    u32 _004;
    u32 _008;
    u32 _00C;
    // ... etc
} UnkStruct80036494;
```

### De notes/struct.txt (investigación manual)
```
Player struct offsets:
  0x14: X position
  0x18: Y position
  0x1C: Z position
  0x20: RX rotation
  0x24: RY rotation
  0x28: RZ rotation
  0x2C: scale
```

---

## 🔄 Sistema de Trabajo Híbrido

### Flujo de Trabajo

```
1. Kimi Analiza
   └── Lee archivo ASM (cuando disponible)
   └── Identifica patrones
   └── Escribe C inicial
   └── Documenta en este archivo

2. Humano Verifica
   └── Copia el C generado
   └── Ejecuta: make
   └── Compara bytes con: sha1sum -c evangelion.sha1
   └── Reporta resultado a Kimi

3. Kimi Itera
   └── Si MATCH: ✅ Marcar como completado
   └── Si FAIL: Analizar diferencias
   └── └── Ajustar C según feedback
   └── └── Repetir desde paso 2
```

### Formato de Reporte Humano
```markdown
## Reporte: func_800AA550
- **Archivo**: src/code_15150.c
- **Estado**: ❌ FAIL / ✅ MATCH
- **Offset diferencia**: 0x15150 + 0x00 (ejemplo)
- **Bytes esperados**: 3C 04 80 01
- **Bytes obtenidos**: 3C 04 80 02
- **Notas**: El registro $a0 parece tener dirección incorrecta
```

---

## 🎯 Próximos Objetivos

### Prioridad Alta
1. [ ] Obtener assembly de code_15150.c
2. [ ] Decompilar func_800AA550 (función más pequeña)
3. [ ] Verificar matching

### Prioridad Media
4. [ ] Documentar structs usados en este módulo
5. [ ] Identificar callers de estas funciones

---

## 📚 Recursos Útiles

### Scripts de Análisis
- `tools/m2ctx.py` - Genera contexto para mips2c
- `tools/findromaddr.py` - Encuentra dirección ROM
- `tools/switch_analysis.py` - Analiza switch tables

### Comandos Útiles
```bash
# Verificar matching
make && sha1sum -c evangelion.sha1

# Generar contexto para función
python3 tools/m2ctx.py src/code_15150.c

# Buscar símbolos
grep -r "func_800AA550" src/
```

---

## 📈 Progreso Detallado

### Función: func_800AA550
- **Estado**: ⏸️ Revertido a ASM
- **Archivo**: src/code_15150.c
- **Análisis**: Función de copia de 5 variables globales con delay slot específico
- **Problema**: GCC 2.7.2 reordena `jr` y `sh` en el delay slot incorrectamente
- **Workspace**: Ver `WORKSPACE_func_800AA550.md`
- **Solución**: Usar INCLUDE_ASM hasta encontrar forma de forzar el orden correcto

### Estado del Build
- **Compilación**: ✅ Exitosa
- **Matching**: ❌ FALLA (diferencias en sección de datos 0x3E738+)
- **Problema actual**: Datos no code - alineación/posicionamiento de variables globales

## 🕐 Historial de Cambios

### 2026-02-04 - Setup Completo + Primera Función
- ✅ make setup completado exitosamente
- ✅ Assembly extraído para todo el ROM
- ✅ Análisis completo de func_800AA550
- ✅ Código C generado y probado
- ⚠️ Identificado problema de delay slot con GCC 2.7.2
- ⏸️ func_800AA550 revertido a INCLUDE_ASM
- 🔄 Build compila pero no hace match (diferencias en datos)
- Creado sistema de tracking
- Analizado estructura de code_15150.c
- Identificadas 16 funciones a decompilar
- Documentadas estructuras conocidas

---

**Nota**: Este archivo es el "cerebro extendido" de Kimi. Actualizar regularmente.
