#!/usr/bin/env python3
"""
Compare a single function between original ROM and built ROM.
Fast matching without full build.
"""

import sys

def compare_function(rom_offset, size, original_rom="evangelion.z64", built_rom="build/eva.z64"):
    """Compare bytes at specific offset between two ROMs."""
    
    try:
        with open(original_rom, 'rb') as f:
            f.seek(rom_offset)
            original = f.read(size)
        
        with open(built_rom, 'rb') as f:
            f.seek(rom_offset)
            built = f.read(size)
        
        if len(original) != size:
            print(f"[FAIL] Could not read {size} bytes from original ROM")
            return 1
        
        if len(built) != size:
            print(f"[FAIL] Could not read {size} bytes from built ROM")
            return 1
        
        if original == built:
            print(f"[MATCH] Offset 0x{rom_offset:06X} ({size} bytes) - PERFECT MATCH!")
            return 0
        else:
            print(f"[DIFF] Offset 0x{rom_offset:06X} - BYTES DIFFER")
            
            # Show first few differences
            diff_count = 0
            total_diffs = sum(1 for a, b in zip(original, built) if a != b)
            
            for i, (o, b) in enumerate(zip(original, built)):
                if o != b:
                    print(f"  0x{rom_offset + i:06X}: original=0x{o:02X}, built=0x{b:02X}")
                    diff_count += 1
                    if diff_count >= 5:
                        if total_diffs > 5:
                            print(f"  ... and {total_diffs - 5} more differences")
                        break
            return 1
            
    except FileNotFoundError as e:
        print(f"[FAIL] File not found: {e.filename}")
        return 1
    except Exception as e:
        print(f"[FAIL] Error: {e}")
        return 1

def main():
    if len(sys.argv) < 3:
        print("Usage: python3 compare_function.py <rom_offset> <size>")
        print("")
        print("Examples:")
        print("  python3 compare_function.py 0x15150 88")
        print("    -> checks func_800AA550 (88 bytes at offset 0x15150)")
        print("")
        print("  python3 compare_function.py 0x151A8 128")
        print("    -> checks func_800AA5A8 (128 bytes at offset 0x151A8)")
        sys.exit(1)
    
    try:
        offset = int(sys.argv[1], 0)  # Auto-detect hex (0x) or decimal
        size = int(sys.argv[2], 0)
    except ValueError:
        print("[FAIL] Invalid offset or size. Use hex (0x15150) or decimal.")
        sys.exit(1)
    
    sys.exit(compare_function(offset, size))

if __name__ == "__main__":
    main()
