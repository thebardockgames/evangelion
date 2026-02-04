# Neon Genesis Evangelion 64 Decompilation

[![Build Status](https://img.shields.io/badge/build-WIP-yellow.svg)]()
[![Matching Status](https://img.shields.io/badge/matching-98%25-green.svg)]()
[![License](https://img.shields.io/badge/license-None-red.svg)]()

A work-in-progress decompilation of *Neon Genesis Evangelion* (1999) for the Nintendo 64. This is the only officially licensed anime game released for the N64 platform.

> 🎯 **Goal**: Produce a matching, byte-for-byte identical ROM using modern tooling and readable C code.

---

## 📋 Overview

| Attribute | Details |
|-----------|---------|
| **Game** | Neon Genesis Evangelion (新世紀エヴァンゲリオン) |
| **Platform** | Nintendo 64 |
| **Release Date** | June 25, 1999 (Japan) |
| **Developer** | BEC Co., Ltd. |
| **Publisher** | Bandai |
| **ROM Size** | 32 MB |
| **Original SHA1** | `a9ba0a4afeed48080f54aa237850f3676b3d9980` |

---

## 🏗️ Project Status

```
Current State: Functional Build - Matching In Progress
├── Setup:           ✅ Complete
├── Extraction:      ✅ Complete (splat)
├── Build System:    ✅ Complete (GCC 2.7.2 + modern binutils)
├── Matching:        ⚠️  98%+ (data section differences)
└── Decompilation:   🔄 In Progress (1 function analyzed)
```

### What's Working
- ✅ Full ROM extraction and analysis
- ✅ Build system with authentic GCC 2.7.2 toolchain
- ✅ Compilation to working ROM
- ✅ Asset extraction (textures, models, audio)
- ✅ Symbol identification

### What's In Progress
- 🔄 Matching the original ROM byte-for-byte
- 🔄 Decompiling functions from assembly to C
- 🔄 Documenting game structures and systems

### Known Issues
- **Delay Slot Optimization**: GCC 2.7.2 reorders certain branch delay slots differently than the original compiler
- **Data Alignment**: Minor differences in global data section alignment (offset `0x3E738`)

---

## 🛠️ Building

### Requirements

- Linux or WSL (Windows Subsystem for Linux)
- Python 3.8+ with pip
- `build-essential` and `binutils-mips-linux-gnu`
- Your own legally obtained copy of the game ROM

### Quick Start

```bash
# 1. Clone the repository
git clone https://github.com/YOUR_USERNAME/evangelion.git
cd evangelion

# 2. Place your ROM in the project root
cp /path/to/your/evangelion.z64 ./evangelion.z64

# 3. Setup (extracts assets and builds tools)
make setup

# 4. Build the project
make

# 5. Verify matching (optional)
sha1sum -c evangelion.sha1
```

### Build Output

A successful build will produce:
- `build/eva.elf` - Linked ELF file
- `build/eva.z64` - Final ROM (should match original when complete)
- `build/eva.map` - Linker map for debugging

---

## 📁 Project Structure

```
eva64/
├── asm/                    # Assembly code extracted from ROM
│   ├── nonmatchings/      # Functions not yet decompiled
│   └── ...
├── assets/                # Extracted game assets (gitignored)
│   ├── yay0/             # Compressed data
│   ├── Font/             # Font textures
│   └── ...
├── include/               # Header files
│   ├── PR/               # Nintendo SDK headers
│   ├── libc/             # C standard library
│   └── *.h               # Project headers
├── src/                   # C source code
│   ├── main/             # Main game code
│   ├── os/               # LibUltra OS wrappers
│   ├── ovl1-8/           # Overlay code
│   └── *.c               # Individual translation units
├── tools/                 # Build tools
│   ├── splat_ext/        # splat extensions
│   └── ...
├── build/                 # Build artifacts (gitignored)
├── evangelion.yaml        # ROM segmentation config (splat)
├── Makefile              # Build configuration
└── *.md                  # Documentation
```

---

## 🎮 Technical Details

### Architecture
- **CPU**: MIPS R4300i (VR4300)
- **Graphics**: RCP (Reality Co-Processor) with F3DEX2 microcode
- **Audio**: MusyX sound system
- **Memory**: 8MB RAM (with Expansion Pak)

### Compiler Toolchain
- **Compiler**: GCC 2.7.2 (KMC wrapper)
- **Assembler**: GNU binutils 2.35+ (modern, with compatibility macros)
- **Linker**: mips-n64-ld
- **Disassembler**: spimdisasm 1.39.0

### Overlay System
The game uses 8 dynamically loaded overlays:

| Overlay | ROM Range | Description |
|---------|-----------|-------------|
| ovl1 | 0x69EE0 - 0x74BB0 | Main gameplay logic |
| ovl2 | 0x74BB0 - 0xCF110 | Additional systems |
| ovl3 | 0xCF110 - 0x113B10 | Japanese text & subtitles |
| ovl4 | 0x113B10 - 0x117A00 | - |
| ovl5 | 0x117A00 - 0x14F960 | - |
| ovl6 | 0x14F960 - 0x175640 | - |
| ovl7 | 0x175640 - 0x1A1880 | Mission text & dialogues |
| ovl8 | 0x1A1880 - 0x1BB280 | - |

---

## 📝 Documentation

- **[PROGRESS.md](PROGRESS.md)** - Detailed project status and roadmap
- **[WORKFLOW.md](WORKFLOW.md)** - Development workflow and contribution guidelines
- **[KIMI_CONTEXT.md](KIMI_CONTEXT.md)** - Technical context and structures (AI-assisted development)
- **[SESSION_LOG.md](SESSION_LOG.md)** - Development session history
- **[SETUP_WSL.md](SETUP_WSL.md)** - WSL setup instructions

---

## 🤝 Contributing

This is a personal research project, but feedback and suggestions are welcome!

If you're interested in N64 decompilation:
1. Check out the [N64 Decomp Discord](https://discord.gg/DYavedR)
2. Visit [decomp.me](https://decomp.me) for collaborative decompilation
3. See [n64decomp.github.io](https://n64decomp.github.io) for resources

---

## 🙏 Acknowledgements

- **splat** - N64 ROM splitting tool by ethteck
- **spimdisasm** - MIPS disassembler by angheloalf
- **decomp.me** - Collaborative decompilation platform
- **KMC GCC** - Preserved compiler toolchain
- **IlDucci, Zoinkity, Dark_Kudoh** - Original text and file table research

---

## ⚠️ Legal Notice

This project is for educational and preservation purposes only. 

- **You must provide your own legally obtained ROM** to build this project
- The original game and its assets are © 1999 Bandai / BEC / Khara
- This repository does not contain any copyrighted game assets or code

---

## 📊 Matching Status

```diff
+ Header:        100% (corrected by n64crc)
+ Code:          ~98% (minor instruction ordering differences)
+ Assets:        100% (extracted directly)
- Data Section:  Investigating alignment differences
```

**Current SHA1**: `TBD` (work in progress)

**Target SHA1**: `a9ba0a4afeed48080f54aa237850f3676b3d9980`

---

*This project is not affiliated with or endorsed by Bandai, BEC, Khara, or Nintendo.*
