# Sistema de Trabajo Híbrido: Kimi + Humano

## 🎯 Visión General

Este documento describe el flujo de trabajo colaborativo entre Kimi AI (análisis/documentación) y un humano (verificación/matching).

---

## 📁 Archivos del Sistema

| Archivo | Propósito |
|---------|-----------|
| `KIMI_CONTEXT.md` | Contexto global del proyecto, estructuras, progreso |
| `WORKSPACE_func_XXXXXXXX.md` | Análisis específico de cada función |
| `WORKFLOW.md` | Este archivo - documentación del sistema |

---

## 🔄 Flujo de Trabajo Detallado

### Fase 1: Selección de Objetivo
**Quién**: Humano o Kimi

Elige una función basada en:
- Tamaño pequeño (funciones simples primero)
- Contexto conocido (funciones de LibUltra ya documentadas)
- Prioridad del proyecto

**Ejemplo**: `func_800AA550` en `src/code_15150.c`

---

### Fase 2: Análisis de Kimi
**Quién**: Kimi

1. Lee el archivo fuente C actual
2. Busca el assembly correspondiente (cuando esté disponible)
3. Analiza el contexto (callers, callees, estructuras)
4. Genera código C inicial
5. Crea `WORKSPACE_func_XXXXXXXX.md`

**Output**: Archivo de workspace con código propuesto

---

### Fase 3: Verificación Humana
**Quién**: Humano

```bash
# 1. Reemplazar INCLUDE_ASM con el código generado
# Editar src/code_XXXXX.c

# 2. Compilar
make clean
make

# 3. Verificar matching
sha1sum -c evangelion.sha1
```

#### Si MATCH ✅
1. Reportar a Kimi
2. Kimi actualiza `KIMI_CONTEXT.md`
3. Pasar a siguiente función

#### Si FAIL ❌
1. Analizar el error:
   ```bash
   # Obtener información de la diferencia
   diff -u <(xxd baserom.z64) <(xxd build/eva.z64) | head -100
   ```

2. Documentar en el workspace:
   - Offset donde difiere
   - Bytes esperados vs obtenidos
   - Patrón del error

3. Reportar a Kimi con formato:
   ```markdown
   ## Reporte: func_XXXXXXXX
   - **Estado**: FAIL
   - **Offset ROM**: 0x15150 + 0x24
   - **Bytes esperados**: 8F A4 00 00
   - **Bytes obtenidos**: 8F A4 00 04
   - **Análisis**: El offset del campo parece incorrecto
   ```

---

### Fase 4: Iteración de Kimi
**Quién**: Kimi

1. Lee el reporte de fallo
2. Analiza la diferencia
3. Ajusta el código C:
   - Cambia tipos de datos
   - Ajusta operadores
   - Modifica estructuras

4. Actualiza `WORKSPACE_func_XXXXXXXX.md`
5. Añade entrada en historial de iteraciones

**Output**: Nueva versión del código

---

### Fase 5: Repetir
Volver a Fase 3 hasta obtener MATCH.

---

## 📝 Plantillas

### Plantilla de Workspace
```markdown
# WORKSPACE_func_XXXXXXXX.md

## Información
| Campo | Valor |
|-------|-------|
| Nombre | func_XXXXXXXX |
| Archivo | src/code_XXXXX.c |
| VRAM | 0x8XXXXXXX |
| Tamaño | XXX bytes |

## Código Generado (Iteración N)
\`\`\`c
void func_XXXXXXXX(void) {
    // Código aquí
}
\`\`\`

## Historial de Iteraciones
| # | Fecha | Estado | Notas |
|---|-------|--------|-------|
| 1 | YYYY-MM-DD | FAIL | Offset incorrecto |
| 2 | YYYY-MM-DD | MATCH | - |
```

### Plantilla de Reporte Humano
```markdown
## Reporte: func_XXXXXXXX
- **Iteración**: 2
- **Estado**: [ ] MATCH / [x] FAIL
- **Error compilación**: No / "mensaje"
- **Offset diferencia**: 0x15150 + 0xXX
- **Bytes esperados**: XX XX XX XX
- **Bytes obtenidos**: YY YY YY YY
- **Patrón observado**: 
  - Registro afectado: $t0
  - Operación: load word
  - Offset: parece desplazado +4
```

---

## 🛠️ Comandos Útiles

### Análisis de Diferencias
```bash
# Comparar byte a byte
xxd baserom.z64 > baserom.hex
xxd build/eva.z64 > build.hex
diff baserom.hex build.hex | head -50

# Encontrar primera diferencia
cmp -l baserom.z64 build/eva.z64 | head -5

# Verificar sección específica
dd if=baserom.z64 bs=1 skip=$((0x15150)) count=88 | xxd
dd if=build/eva.z64 bs=1 skip=$((0x15150)) count=88 | xxd
```

### Generación de Contexto
```bash
# Para mips2c u otras herramientas
python3 tools/m2ctx.py src/code_XXXXX.c > ctx.c
```

---

## 📊 Métricas de Progreso

Seguimiento diario/semanal:

```markdown
## Progreso Semana del YYYY-MM-DD

### Funciones Completadas
- [x] func_800AA550 (3 iteraciones)
- [x] func_800AA5A8 (1 iteración)

### En Progreso
- [ ] func_800AA628 (Iteración 2/5)

### Bloqueadas
- func_800AA710 - Necesita entender estructura desconocida

### Estadísticas
- Total funciones archivo: 16
- Completadas: 2 (12.5%)
- Tiempo promedio por función: 45 min
```

---

## 🎓 Tips para el Humano

### Optimizando el ciclo de iteración

1. **Usa `NON_MATCHING=1` para debug**:
   ```bash
   make NON_MATCHING=1
   # Permite compilar aunque no haga match
   # Útil para probar lógica
   ```

2. **Mira el assembly generado**:
   ```bash
   mips-n64-objdump -d build/src/code_XXXXX.o
   ```

3. **Usa asm-differ para comparar**:
   ```bash
   # Una vez instalado asm-differ
   python3 diff.py -mwo func_XXXXXXXX
   ```

4. **Divide y vencerás**:
   - Si una función es muy compleja (>500 bytes)
   - Intenta identificar subtareas
   - Decompila por partes

---

## 🚨 Limitaciones Conocidas

### Lo que Kimi NO puede hacer:
1. ❌ Ejecutar `make` o cualquier comando
2. ❌ Ver el output de compilación
3. ❌ Acceder a archivos .s de assembly (hasta que existan)
4. ❌ Mantener memoria entre sesiones sin los archivos .md
5. ❌ Iterar rápidamente (necesita esperar al humano)

### Lo que el Humano DEBE hacer:
1. ✅ Ejecutar compilación
2. ✅ Reportar resultados específicos
3. ✅ Proporcionar feedback detallado de errores
4. ✅ Mantener el repositorio git

---

## 🚀 Primeros Pasos

### Para empezar ahora mismo:

1. **Inicializar el proyecto** (requiere ROM original):
   ```bash
   # Colocar evangelion.z64 en directorio raíz
   make setup  # Extrae assets y assembly
   ```

2. **Elegir primera función**:
   - Recomendado: `src/os/startthread.c` (ya está hecho, como referencia)
   - O: Una función pequeña de LibUltra
   - Evitar: Funciones >500 bytes al inicio

3. **Crear workspace**:
   - Pedir a Kimi que analice la función elegida
   - Kimi creará `WORKSPACE_func_XXXXXXXX.md`

4. **Iterar hasta MATCH**:
   - Seguir el flujo de trabajo arriba

---

## 📞 Formato de Comunicación Eficiente

### Mensaje del Humano a Kimi (óptimo):
```
Reporte: func_800AA550
- Estado: FAIL
- Iteración: 2
- Offset: 0x15150 + 0x0C
- Esperado: 27 BD FF F0  (addiu $sp, $sp, -0x10)
- Obtenido: 27 BD FF E0  (addiu $sp, $sp, -0x20)
- Análisis: El stack frame parece más grande de lo esperado
```

### Mensaje de Kimi al Humano (óptimo):
```markdown
## Nueva Iteración: func_800AA550

Código ajustado:
\`\`\`c
void func_800AA550(void) {
    // Ajustado stack frame de 0x10 a 0x20
    s32 sp[4];  // Antes: s32 sp[2];
    // ...
}
\`\`\`

Cambios:
- Stack frame aumentado para alinear con prologo MIPS
- Añadido padding en estructura

Prueba y reporta.
```

---

*Sistema creado: 2026-02-04*
*Versión: 1.0*
