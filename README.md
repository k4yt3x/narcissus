# Narcissus

A simple (?) reverse engineering challenge.

- `narcissus` is the built binary, available on the [releases page](https://github.com/k4yt3x/narcissus/releases).
- `narcissus.nasm` contains the obfuscated NASM source code.
- `narcissus.orig.nasm` contains the unobfuscated NASM source code.

## Goal

The goal of this challenge is to make the program output "Correct answer!" without patching the binary.

![image](https://github.com/k4yt3x/narcissus/assets/21986859/189e9eb0-7783-4eda-9daa-90aa5121b327)

## Build

You will need to have [NASM](https://www.nasm.us/) and [Make](https://www.gnu.org/software/make/) installed. Then:

```shell
# build the binary WITHOUT debugging symbols
make

# build the binary WITH debugging symbols
make debug
```
