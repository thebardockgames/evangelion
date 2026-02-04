# Fix: Conflicto de PATH entre splat (broadcasting) y splat64 (N64)

## El Problema
```
which splat
# /usr/bin/splat  ← El de broadcasting (MALO)

# Debería ser:
# ~/.local/bin/splat  ← El de N64 (BUENO)
```

## ✅ Solución: Cambiar Prioridad del PATH

### Opción 1: Temporal (para esta sesión)
```bash
# Ejecutar en tu terminal:
export PATH="$HOME/.local/bin:$PATH"

# Verificar
which splat
# Ahora debería decir: /home/bardock/.local/bin/splat

# Probar
splat --version
```

### Opción 2: Permanente (recomendado)
```bash
# Editar tu .bashrc
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

# Recargar
source ~/.bashrc

# Verificar
which splat
splat --version
```

### Opción 3: Renombrar el splat de broadcasting (si no lo usas)
```bash
# Solo si NO usas splat para broadcasting
sudo mv /usr/bin/splat /usr/bin/splat-broadcasting

# Ahora el de N64 será el único
which splat
splat --version
```

---

## 🔧 Verificación

Después del fix:
```bash
# Debe mostrar la versión de splat64
splat --version
# splat 0.37.2

# Debe mostrar ayuda de N64
splat --help | head -5
# usage: splat [-h] [--version] [--disassemble DISASSEMBLE] ...
```

---

## 🚀 Después del fix, ejecutar

```bash
cd /mnt/d/Proyectos/evangelion
make setup
```
