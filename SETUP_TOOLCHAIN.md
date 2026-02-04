# Instalación del Toolchain MIPS N64

## El Problema
Falta `mips-n64-cpp` y el toolchain completo para compilar.

## ✅ Solución

### Opción 1: Instalar desde repositorio (recomendado)

```bash
# Actualizar repositorios
sudo apt update

# Instalar binutils de MIPS (ensamblador, linker, etc.)
sudo apt install binutils-mips-linux-gnu

# Verificar instalación
mips-linux-gnu-as --version
mips-linux-gnu-ld --version
mips-linux-gnu-cpp --version
```

Si funciona, el Makefile probablemente necesite un symlink o cambiar el nombre:

```bash
# Crear symlinks si el Makefile espera mips-n64-*
sudo ln -s $(which mips-linux-gnu-as) /usr/local/bin/mips-n64-as
sudo ln -s $(which mips-linux-gnu-ld) /usr/local/bin/mips-n64-ld
sudo ln -s $(which mips-linux-gnu-cpp) /usr/local/bin/mips-n64-cpp
sudo ln -s $(which mips-linux-gnu-objcopy) /usr/local/bin/mips-n64-objcopy
sudo ln -s $(which mips-linux-gnu-objdump) /usr/local/bin/mips-n64-objdump
```

### Opción 2: Instalar toolchain moderno de N64 (mejor)

```bash
# Instalar dependencias
sudo apt update
sudo apt install -y build-essential git wget

# Descargar e instalar toolchain moderno
wget https://github.com/n64decomp/toolchain/releases/download/2023-09-06/mips-n64-x86_64-linux-gnu.tar.gz
tar xzf mips-n64-x86_64-linux-gnu.tar.gz
sudo cp -r mips-n64-x86_64-linux-gnu/* /usr/local/

# Limpiar
rm -rf mips-n64-x86_64-linux-gnu mips-n64-x86_64-linux-gnu.tar.gz

# Verificar
mips-n64-gcc --version
```

### Opción 3: Build desde fuente (más lento pero confiable)

```bash
# Script simplificado para Ubuntu/Debian
sudo apt update
sudo apt install -y build-essential bison flex libgmp3-dev libmpc-dev libmpfr-dev texinfo

# Descargar binutils 2.35 (versión común para N64)
wget https://ftp.gnu.org/gnu/binutils/binutils-2.35.tar.bz2
tar xjf binutils-2.35.tar.bz2

# Compilar binutils para mips-n64
mkdir build-binutils
cd build-binutils
../binutils-2.35/configure --target=mips-n64 --prefix=/usr/local \
    --with-cpu=mips64vr4300 --disable-werror
make -j$(nproc)
sudo make install
cd ..

# Limpiar
rm -rf binutils-2.35 binutils-2.35.tar.bz2 build-binutils

# Verificar
mips-n64-as --version
```

---

## 🔍 Verificación

Después de instalar, verifica que existan:

```bash
which mips-n64-as
which mips-n64-ld
which mips-n64-cpp
which mips-n64-objcopy
```

Todos deberían retornar rutas válidas.

---

## 🚀 Después de instalar

```bash
cd /mnt/d/Proyectos/evangelion
make clean
make
```

---

## ⚠️ Notas Importantes

1. **El Makefile usa `mips-n64-`**: Si tu sistema tiene `mips-linux-gnu-`, necesitarás crear symlinks o modificar el Makefile.

2. **Para WSL**: Asegúrate de que los binarios tengan permisos de ejecución:
   ```bash
   chmod +x /usr/local/bin/mips-n64-*
   ```

3. **Si persiste el error**: Puede que necesites agregar `/usr/local/bin` al PATH:
   ```bash
   export PATH="/usr/local/bin:$PATH"
   echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc
   ```
