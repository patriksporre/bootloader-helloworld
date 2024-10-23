# Bootloader - "Hello World" on x86 Architecture

This project contains two simple bootloaders written in **lean and mean assembly**.

Without relying on any BIOS calls, the two bootloaders directly manipulates the video memory to clear the screen and display `"Hello World"` in VGA text mode.

The two different bootloaders runs on an x86 architecture in 16 bit real mode and 32 bit protected mode respectively.

## Author

**Patrik Sporre**  
Email: [patriksporre@gmail.com](mailto:patriksporre@gmail.com)

## Prerequisites

- **NASM (Netwide Assembler)**: For assembling the bootloader
- **QEMU**: To emulate the x86 environment and run the bootloader

### Installation

#### macOS Installation (using Homebrew)

1. **Install NASM**:
   ```bash
   brew install nasm
   ```

2. **Install QEMU**:
   ```bash
   brew install qemu
   ```

### How to Assemble and Run the Bootloader

1. **Assemble the bootloader**:
   Use NASM to convert the assembly source files (`boot.asm` and `boot-pmode.asm`) into a binary files that can be run as bootloaders.

   ```bash
   nasm -f bin boot.asm -o boot.bin
   ```

   ```bash
   nasm -f bin boot-pmode.asm -o boot-pmode.bin
   ```

2. **Run the bootloader in QEMU**:
   Use QEMU to emulate an x86 system and load the bootloader binaries (`boot.bin` and `boot-pmode.bin`).

   ```bash
   qemu-system-x86_64 -drive format=raw,file=boot.bin
   ```

   ```bash
   qemu-system-x86_64 -drive format=raw,file=boot-pmode.bin
   ```

   This will open a QEMU window, and you should see `"Hello World"` printed top left to the screen running both bootloaders.

### Project Structure

- `boot.asm`: The assembly code for the 16 bit real mode bootloader that prints `"Hello World"`
- `boot-pmode.asm`: The assembly code for the 32 bit protected mode bootloader that prints `"Hello World"`

### How It Works

- The bootloader starts in 16-bit real mode and is loaded by the BIOS at memory address `0x7c00`
- It operates directly with the video memory at location 0xb800, no BIOS interrupts are used
- The screen is cleared and then prints the characters of `"Hello World"` one by one to the top left of the screen
- The program halts the CPU after printing the message using the `hlt` instruction

### Difference Between 16 Bit Real Mode and 32 Bit Protected Mode

In short:
- In real mode, the video memory is accessed using segment addressing via `segment:offset` (e.g., `es:di` with `es = 0xb800`)
- In protected mode, the video memory is accessed directly via its linear address (`0xb8000`)

Another major difference is that in real mode the segments are limited to 64 KB, while in protected mode the limit is 4 GB.

### License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.