#!/usr/bin/env python3
import sys

with open("build/eva.z64", "rb") as f:
    data = f.read(33554432)

with open("build/eva_fixed.z64", "wb") as f:
    f.write(data)

print(f"Truncated to {len(data)} bytes")
