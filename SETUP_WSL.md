# Guía de Setup para WSL (Ubuntu/Debian moderno)

## El Problema
Los sistemas modernos (Ubuntu 23.04+, Debian 12+) protegen el Python del sistema.
El error `externally-managed-environment` es normal.

## ✅ Solución 1: Usar pipx (Recomendado)

```bash
# 1. Instalar pipx
sudo apt update
sudo apt install pipx

# 2. Asegurar que pipx esté en PATH
pipx ensurepath

# 3. Recargar shell (o cerrar y abrir terminal)
source ~/.bashrc

# 4. Instalar splat64
pipx install splat64

# 5. Verificar
splat --help
```

## ✅ Solución 2: Virtual Environment (Alternativa)

```bash
# 1. Crear venv en el proyecto
cd /mnt/d/Proyectos/evangelion
python3 -m venv .venv

# 2. Activar
source .venv/bin/activate

# 3. Instalar dependencias
pip install splat64
pip install spimdisasm==1.18.0
pip install "mapfile_parser>=2.3.0,<3.0.0"

# 4. Verificar
splat --help
```

**Nota**: Con venv, debes activarlo cada vez:
```bash
source .venv/bin/activate
make setup
```

## ✅ Solución 3: Override rápido (No recomendado a largo plazo)

```bash
pip3 install splat64 --break-system-packages
```

⚠️ Riesgo: Puede romper paquetes del sistema.

---

## 🚀 Después de instalar splat64

```bash
cd /mnt/d/Proyectos/evangelion
make setup
```

Si todo va bien, verás:
```
Splitting ROM... OK
Extracting assets... OK
```

Y se creará la carpeta `asm/` con el assembly extraído.

---

## 🔧 Troubleshooting

### Si splat no se encuentra después de pipx
```bash
# Verificar PATH
echo $PATH

# Si falta, agregar manualmente:
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Si hay conflicto con otro splat
```bash
# Ver cuál splat estás usando
which splat

# Si es el incorrecto, desinstalar:
sudo apt remove splat  # si existe
pip3 uninstall splat   # si existe

# Reinstalar splat64
pipx install splat64 --force
```

### Dependencias faltantes
Si `make setup` falla por dependencias:
```bash
# En el venv o con pipx run:
pip install spimdisasm==1.18.0
pip install "mapfile_parser>=2.3.0,<3.0.0"
pip install tqdm
```

---

## 📋 Checklist Final

- [ ] `splat --help` muestra ayuda de splat64
- [ ] `which splat` apunta a ~/.local/bin/splat o .venv/bin/splat
- [ ] `make setup` ejecuta sin errores
- [ ] Carpeta `asm/` se crea con archivos .s
