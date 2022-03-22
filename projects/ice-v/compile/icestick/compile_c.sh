#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
export PATH=$PATH:$DIR/../../tools/fpga-binutils/mingw32/bin/

source ../../tools/bash/find_riscv.sh

echo "using $ARCH"

$ARCH-gcc -DICESTICK -fno-builtin -fno-unroll-loops -O1 -fno-stack-protector -fno-pic -march=rv32i -mabi=ilp32 -S $1 -o compile/build/code.s
$ARCH-gcc -DICESTICK -fno-builtin -fno-unroll-loops -O1 -fno-stack-protector -fno-pic -march=rv32i -mabi=ilp32 -c -o compile/build/code.o $1

$ARCH-as -march=rv32i -mabi=ilp32 -o crt0.o compile/icestick/crt0.s

$ARCH-ld -m elf32lriscv -b elf32-littleriscv -Tcompile/icestick/config_c.ld --no-relax -o compile/build/code.elf compile/build/code.o

$ARCH-objcopy -O verilog compile/build/code.elf compile/build/code.hex

$ARCH-objcopy.exe -O binary compile/build/code.elf compile/build/code.bin
# uncomment to see the actual code, usefull for debugging
$ARCH-objdump.exe -D -b binary -m riscv compile/build/code.bin
