#!/usr/bin/env python3
"""
Audit all functions in asm/nonmatchings against the built ROM.
Generates a report of which functions match and which don't.
"""

import os
import re
import sys
from pathlib import Path

def parse_asm_file(filepath):
    """Extract function info from assembly file."""
    with open(filepath, 'r') as f:
        content = f.read()
    
    # Look for nonmatching or glabel directives
    func_match = re.search(r'(?:nonmatching|glabel)\s+(\w+)', content)
    if not func_match:
        return None
    
    func_name = func_match.group(1)
    
    # Look for size in nonmatching directive
    size_match = re.search(r'nonmatching\s+\w+,\s*0x([0-9a-fA-F]+)', content)
    if size_match:
        size = int(size_match.group(1), 16)
    else:
        # Estimate size from line count (rough approximation)
        lines = [l for l in content.split('\n') if l.strip() and not l.startswith('#')]
        size = len(lines) * 4  # Approximate 4 bytes per instruction
    
    # Look for ROM offset in comments (e.g., "/* 1050 80096450 ... */")
    offset_match = re.search(r'/\*\s+([0-9a-fA-F]+)\s+', content)
    if offset_match:
        rom_offset = int(offset_match.group(1), 16)
    else:
        rom_offset = None
    
    return {
        'name': func_name,
        'size': size,
        'rom_offset': rom_offset,
        'filepath': filepath
    }

def compare_at_offset(rom_path, offset, size):
    """Compare bytes at specific offset between two ROMs."""
    try:
        with open('evangelion.z64', 'rb') as f:
            f.seek(offset)
            original = f.read(size)
        
        with open(rom_path, 'rb') as f:
            f.seek(offset)
            built = f.read(size)
        
        if len(original) != size or len(built) != size:
            return 'ERROR', 'Could not read bytes'
        
        if original == built:
            return 'MATCH', None
        else:
            diff_count = sum(1 for a, b in zip(original, built) if a != b)
            return 'DIFF', f'{diff_count} bytes differ'
    
    except Exception as e:
        return 'ERROR', str(e)

def main():
    print("=" * 70)
    print("AUDIT DE MATCHING - Evangelion 64")
    print("=" * 70)
    print()
    
    # Check if ROMs exist
    if not os.path.exists('evangelion.z64'):
        print("ERROR: evangelion.z64 not found")
        sys.exit(1)
    
    if not os.path.exists('build/eva.z64'):
        print("ERROR: build/eva.z64 not found. Run 'make' first.")
        sys.exit(1)
    
    # Find all assembly files
    asm_files = list(Path('asm/nonmatchings').rglob('*.s'))
    print(f"Found {len(asm_files)} assembly files to check")
    print()
    
    results = {
        'match': [],
        'diff': [],
        'error': [],
        'no_offset': []
    }
    
    # Check each function
    for asm_file in sorted(asm_files):
        func_info = parse_asm_file(asm_file)
        if not func_info:
            continue
        
        if not func_info['rom_offset']:
            results['no_offset'].append(func_info)
            continue
        
        status, details = compare_at_offset('build/eva.z64', 
                                           func_info['rom_offset'], 
                                           func_info['size'])
        
        func_info['status'] = status
        func_info['details'] = details
        
        if status == 'MATCH':
            results['match'].append(func_info)
        elif status == 'DIFF':
            results['diff'].append(func_info)
        else:
            results['error'].append(func_info)
    
    # Print summary
    print("-" * 70)
    print("RESUMEN")
    print("-" * 70)
    print(f"✅ MATCH:     {len(results['match'])} funciones")
    print(f"❌ DIFF:      {len(results['diff'])} funciones")
    print(f"⚠️  NO OFFSET: {len(results['no_offset'])} funciones")
    print(f"💥 ERROR:     {len(results['error'])} funciones")
    print()
    
    # Print DIFF functions (the problematic ones)
    if results['diff']:
        print("-" * 70)
        print("FUNCIONES CON DIFERENCIAS (pueden causar crashes)")
        print("-" * 70)
        for func in sorted(results['diff'], key=lambda x: x['rom_offset']):
            print(f"0x{func['rom_offset']:06X} | {func['name']:30s} | {func['size']:4d} bytes | {func['details']}")
        print()
    
    # Print MATCH functions (the good ones)
    if results['match']:
        print("-" * 70)
        print(f"FUNCIONES CON MATCH PERFECTO ({len(results['match'])} total)")
        print("-" * 70)
        for func in sorted(results['match'], key=lambda x: x['rom_offset'])[:20]:  # Show first 20
            print(f"0x{func['rom_offset']:06X} | {func['name']:30s} | {func['size']:4d} bytes | ✅")
        if len(results['match']) > 20:
            print(f"... y {len(results['match']) - 20} más")
        print()
    
    # Save detailed report
    with open('matching_audit.txt', 'w') as f:
        f.write("AUDIT DE MATCHING - Evangelion 64\n")
        f.write("=" * 70 + "\n\n")
        
        f.write("FUNCIONES CON DIFERENCIAS:\n")
        f.write("-" * 70 + "\n")
        for func in sorted(results['diff'], key=lambda x: x['rom_offset']):
            f.write(f"0x{func['rom_offset']:06X} | {func['name']:30s} | {func['size']:4d} bytes\n")
        
        f.write("\n\nFUNCIONES CON MATCH:\n")
        f.write("-" * 70 + "\n")
        for func in sorted(results['match'], key=lambda x: x['rom_offset']):
            f.write(f"0x{func['rom_offset']:06X} | {func['name']:30s} | {func['size']:4d} bytes\n")
    
    print("📄 Reporte guardado en: matching_audit.txt")
    print()
    
    # Return error code if there are differences
    if results['diff']:
        print(f"⚠️  Hay {len(results['diff'])} funciones con diferencias.")
        print("   Estas pueden causar que el ROM no arranque.")
        return 1
    else:
        print("🎉 Todas las funciones hacen MATCH!")
        return 0

if __name__ == '__main__':
    sys.exit(main())
