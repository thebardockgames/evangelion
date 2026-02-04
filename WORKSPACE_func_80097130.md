# Análisis: func_80097130

## Información
- **Nombre**: func_80097130
- **Archivo**: src/code_1050.c
- **VRAM**: 0x80097130
- **ROM Offset**: 0x1D30
- **Tamaño**: 8 bytes (0x8)

## Assembly Original
```asm
glabel func_80097130
    jr         $ra
    sw         $a1, 0x4($a0)
endlabel func_80097130
```

## Análisis
Función extremadamente simple:
- Guarda el valor de `$a1` (argumento 1) en offset 0x4 de `$a0` (argumento 0)
- Retorna inmediatamente
- Es un setter básico

## Código C Propuesto (Iteración 1)

```c
void func_80097130(void* arg0, s32 arg1) {
    ((s32*)arg0)[1] = arg1;  // offset 0x4 = índice 1 en array de s32
}
```

O más explícito:
```c
typedef struct {
    char pad[4];
    s32 field_04;
} UnkStruct80097130;

void func_80097130(UnkStruct80097130* arg0, s32 arg1) {
    arg0->field_04 = arg1;
}
```

## Verificación

```bash
# Compilar
make build/src/code_1050.o

# Verificar matching
python3 tools/compare_function.py 0x1D30 8
```

## Estado
- [ ] Código escrito
- [ ] Compilado
- [ ] Verificado con fast matching
- [ ] Si MATCH -> éxito!
- [ ] Si DIFF -> ajustar
