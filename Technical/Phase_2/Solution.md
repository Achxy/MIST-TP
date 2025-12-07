# Phase 2: Solution

## Environment

**Target:** x86 Linux
**Host:** ARM64
**Emulation:** Rosetta 2 / Docker x86_64 container

> Since I'm on M3 Apple Silicon, x86 assembly is emulated. I'll use Docker with `--platform linux/amd64` to run an x86_64 Linux environment.

---

## Problem 1: Addition

See [`source/add.asm`](./source/add.asm)

**Build & Run:**
```bash
nasm -f elf32 add.asm -o add.o
ld -m elf_i386 add.o -o add
./add
```

**Principle:**
- `mov` — move data between registers
- `add` — arithmetic addition
- `int 0x80` — Linux syscall interrupt
- Registers: `eax`, `ebx`, `ecx`, `edx`

---

## Problem 2: String Capitalization

See [`source/capitalize.asm`](./source/capitalize.asm)

**Build & Run:**
```bash
nasm -f elf32 capitalize.asm -o capitalize.o
ld -m elf_i386 capitalize.o -o capitalize
echo "hello mist ka people" | ./capitalize
```

**Principle:**
- `sub 0x20` — ASCII lowercase to uppercase conversion
- `cmp` / `jl` / `jg` — conditional jumps
- `sys_read` / `sys_write` — I/O syscalls
- Loop with label and `jmp`

---

## Emulation Setup

```bash
docker run --platform linux/amd64 -it -v "$(pwd)":/work ubuntu:22.04

apt update && apt install -y nasm binutils
cd /work
```

## Output
```bash
achu@air ~ % cd Projects/MIST-TP/Technical 
achu@air Technical % docker run --platform linux/amd64 -it -v "$(pwd)":/work ubuntu:22.04
root@b7d47a769e7f:/# apt update && apt install -y nasm binutils
# [Output truncated...]
root@b7d47a769e7f:/# cd /work/Phase_2/source/
root@b7d47a769e7f:/work/Phase_2/source# nasm -f elf32 add.asm -o add.o
root@b7d47a769e7f:/work/Phase_2/source# ld -m elf_i386 add.o -o add.bin
root@b7d47a769e7f:/work/Phase_2/source# ./add.bin
Enter first number: 67
Enter second number: 420
Result: 487
root@b7d47a769e7f:/work/Phase_2/source# nasm -f elf32 capitalize.asm -o capitalize.o
root@b7d47a769e7f:/work/Phase_2/source# ld -m elf_i386 capitalize.o -o capitalize.bin
root@b7d47a769e7f:/work/Phase_2/source# echo "hello mist ka people" | ./capitalize.bin
HELLO MIST KA PEOPLE
root@b7d47a769e7f:/work/Phase_2/source# 
```
