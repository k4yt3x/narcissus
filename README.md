# Narcissus

A simple (?) reverse engineering challenge.

- `narcissus` is the built binary, available on the [releases page](https://github.com/k4yt3x/narcissus/releases).
- `narcissus.nasm` contains the obfuscated NASM source code.
- `narcissus.orig.nasm` contains the unobfuscated NASM source code.

The newer versions have more obfuscation and is, thus, harder than the older versions. If you find your self getting stuck, perhaps try an older version.

## Goal

The goal of this challenge is to make the program output "Correct answer!" without patching the binary.

![image](https://github.com/k4yt3x/narcissus/assets/21986859/ccde2ad6-da79-4940-b33d-21c47785f57a)

## Build

You will need to have [NASM](https://www.nasm.us/) and [Make](https://www.gnu.org/software/make/) installed. Then:

```shell
# build the binary WITHOUT debugging symbols
make

# build the binary WITH debugging symbols
make debug
```
