#!/usr/bin/env python3
"""
Add all missing ovl7 symbols to undefined_syms_all.txt
"""

import re
import os

def find_ovl7_symbols():
    """Find all D_XXXXXX_ovl7 symbols in asm files."""
    symbols = set()
    for root, dirs, files in os.walk('asm/nonmatchings/ovl7'):
        for file in files:
            if file.endswith('.s'):
                with open(os.path.join(root, file)) as f:
                    content = f.read()
                    matches = re.findall(r'D_[0-9A-F]{8}_ovl7', content)
                    symbols.update(matches)
    return sorted(symbols)

def main():
    symbols = find_ovl7_symbols()
    print(f"Found {len(symbols)} ovl7 symbols")
    
    # Read current undefined_syms_all.txt
    with open('undefined_syms_all.txt', 'r') as f:
        content = f.read()
    
    # Find which symbols are missing
    missing = []
    for sym in symbols:
        if sym not in content:
            missing.append(sym)
    
    print(f"Missing {len(missing)} symbols")
    
    # Add missing symbols
    with open('undefined_syms_all.txt', 'a') as f:
        f.write("\n\n# ovl7 symbols auto-generated\n")
        for sym in missing:
            # Extract address from symbol name
            addr = sym.split('_')[1]
            f.write(f"{sym} = 0x{addr};\n")
    
    print(f"Added {len(missing)} symbols to undefined_syms_all.txt")

if __name__ == '__main__':
    main()
