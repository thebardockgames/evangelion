#include "common.h"

void func_80096450(void) {
    s32 i;
    
    i = 14;
    while (i >= 0) {
        i--;
    }
}

INCLUDE_ASM("asm/nonmatchings/code_1050", func_80096468);

INCLUDE_ASM("asm/nonmatchings/code_1050", func_800964BC);

s32 func_800964FC(s32 arg0) {
    if (arg0 < 0) {
        return -arg0;
    }
    return arg0;
}
// O simplemente: return (arg0 < 0) ? -arg0 : arg0;

INCLUDE_ASM("asm/nonmatchings/code_1050", func_80096510);

INCLUDE_ASM("asm/nonmatchings/code_1050", func_8009655C);

INCLUDE_ASM("asm/nonmatchings/code_1050", func_8009665C);

INCLUDE_ASM("asm/nonmatchings/code_1050", func_800966AC);

INCLUDE_ASM("asm/nonmatchings/code_1050", func_8009673C);

INCLUDE_ASM("asm/nonmatchings/code_1050", func_80096810);

INCLUDE_ASM("asm/nonmatchings/code_1050", func_8009698C);

INCLUDE_ASM("asm/nonmatchings/code_1050", func_80096AF0);

INCLUDE_ASM("asm/nonmatchings/code_1050", func_80096D70);

INCLUDE_ASM("asm/nonmatchings/code_1050", func_80096E24);

INCLUDE_ASM("asm/nonmatchings/code_1050", func_80096E64);

INCLUDE_ASM("asm/nonmatchings/code_1050", func_80096ED8);

INCLUDE_ASM("asm/nonmatchings/code_1050", func_80096F04);

INCLUDE_ASM("asm/nonmatchings/code_1050", func_80096F30);

INCLUDE_ASM("asm/nonmatchings/code_1050", func_80096F90);

INCLUDE_ASM("asm/nonmatchings/code_1050", func_80096FB4);

INCLUDE_ASM("asm/nonmatchings/code_1050", func_80097064);

void func_80097124(void* arg0) {
    ((s32*)arg0)[0] = 0;
    ((s32*)arg0)[1] = 0;
}

void func_80097130(void* arg0, s32 arg1) {
    ((s32*)arg0)[1] = arg1;
}

INCLUDE_ASM("asm/nonmatchings/code_1050", func_80097138);

void func_80097144(void* arg0, s32 arg1) {
    *(s32*)arg0 = arg1;  // offset 0
}

INCLUDE_ASM("asm/nonmatchings/code_1050", func_8009714C);

INCLUDE_ASM("asm/nonmatchings/code_1050", func_80097158);
