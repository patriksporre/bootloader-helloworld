# Bootloader - "Hello World" on x86 Architecture

This project contains a simple bootloader that prints `"Hello World"` to the screen when run on an x86 architecture. The bootloader is written in assembly language using NASM and is designed to run in 16-bit real mode.

This project was developed on macOS, but the instructions should be similar for other platforms such as Linux and Windows (with appropriate tools installed).

## Prerequisites

- **NASM (Netwide Assembler)**: For assembling the bootloader.
- **QEMU**: To emulate the x86 environment and run the bootloader.

### Installation

#### macOS Installation (using Homebrew)

1. **Install NASM**:
   ```bash
   brew install nasm

2. **Install QEMU**:
   ```bash
   brew install qemu

### How to Assemble and Run the Bootloader

1. **Assemble the bootloader**:
   Use NASM to convert the assembly source file (`boot.asm`) into a binary file that can be run as a bootloader.

   ```bash
   nasm -f bin boot.asm -o boot.bin

2. **Run the bootloader in QEMU**:
   Use QEMU to emulate an x86 system and load the bootloader binary (`boot.bin`).

   ```bash
   qemu-system-x86_64 -drive format=raw,file=boot.bin

   This will open a QEMU window, and you should see `"Hello World"` printed to the screen.

### Project Structure

- `boot.asm`: The assembly code for the bootloader that prints `"Hello World"` to the screen.
- `boot.bin`: The assembled bootloader binary that can be run in an x86 emulator.

### How It Works

- The bootloader runs in **16-bit real mode** and is loaded by the BIOS at memory address `0x7C00`.
- It uses BIOS interrupt `0x10` to print the characters of `"Hello World"` one by one to the screen.
- The program halts the CPU after printing the message using the `hlt` instruction.

### License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.