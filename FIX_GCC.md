# Fix: mips-n64-gcc no encontrado

## El Problema
El toolchain GCC 2.7.2 se descargó pero no está en el PATH.

## ✅ Solución

### Paso 1: Verificar dónde se instaló GCC

```bash
# Buscar el gcc descargado
ls -la tools/gcc_kmc/linux/2.7.2/

# Debería haber un ejecutable 'gcc' allí
ls -la tools/gcc_kmc/linux/2.7.2/gcc
```

### Paso 2: Crear symlinks con el nombre esperado

El Makefile espera `mips-n64-gcc` pero el toolchain descargado es KMC.

```bash
# Crear directorio para binarios locales si no existe
mkdir -p ~/.local/bin

# Crear symlinks para el toolchain
cd ~/.local/bin

# GCC
ln -sf /mnt/d/Proyectos/evangelion/tools/gcc_kmc/linux/2.7.2/gcc mips-n64-gcc

# AS (assembler)
ln -sf /mnt/d/Proyectos/evangelion/tools/gcc_kmc/linux/2.7.2/as mips-n64-as

# LD (linker) - puede necesitar el de binutils
ln -sf /usr/bin/mips-linux-gnu-ld mips-n64-ld

# OBJCOPY
ln -sf /usr/bin/mips-linux-gnu-objcopy mips-n64-objcopy

# OBJDUMP (útil para debug)
ln -sf /usr/bin/mips-linux-gnu-objdump mips-n64-objdump

# Verificar
ls -la mips-n64-*
```

### Paso 3: Asegurar que ~/.local/bin esté en PATH

```bash
# Verificar
which mips-n64-gcc

# Si no lo encuentra, agregar al PATH
export PATH="$HOME/.local/bin:$PATH"
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

# Verificar de nuevo
which mips-n64-gcc
mips-n64-gcc --version
```

### Paso 4: Intentar compilar de nuevo

```bash
cd /mnt/d/Proyectos/evangelion
make clean
make
```

---

## 🔧 Si el gcc de KMC no funciona

Alternativa: Usar el toolchain moderno de n64decomp:

```bash
cd /tmp
wget https://github.com/n64decomp/toolchain/releases/latest/download/mips-n64-x86_64-linux-gnu.tar.gz
tar xzf mips-n64-x86_64-linux-gnu.tar.gz
sudo cp -r mips-n64-x86_64-linux-gnu/* /usr/local/
cd /mnt/d/Proyectos/evangelion
make clean
make
```

---

## 📝 Verificación

Después del fix, estos comandos deben funcionar:

```bash
mips-n64-gcc --version
mips-n64-as --version
mips-n64-ld --version
```
