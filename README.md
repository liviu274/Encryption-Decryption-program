# Game of Life

This project is an x86 assembly implementation of the "Game of Life" cellular automaton, developed as part of the "Arhitectura Sistemelor de Calcul" (ASC) laboratory assignment.

## What does it do?

- **Reads** the grid size (number of lines and columns), the number of initial live cells, their positions, and the number of simulation steps (`k`).
- **Simulates** the evolution of the grid for `k` steps using the classic Game of Life rules:
  - A live cell with 2 or 3 live neighbors survives.
  - A dead cell with exactly 3 live neighbors becomes alive.
  - All other cells die or remain dead.
- **Prints** the final state of the grid after all evolutions.

## Extended Functionality (Encryption/Decryption)

In the advanced tasks (cerinta0x01.S / cerinta0.02.S):

- The matrix is **linearized** and its cell values are transformed into a sequence of bits.
- This bit sequence is used as a **dynamic encryption key** (32 bits at a time) to encrypt a string, outputting the result in hexadecimal.
- The same process can be used in reverse to **decrypt** a hexadecimal string back into readable text, using the matrix-derived key.

## How does it work?

- The program uses two matrices in memory: one for the current state and one as a buffer for the next state.
- For each evolution step, it counts the live neighbors for every cell (excluding the border), applies the rules, and updates the buffer.
- After each step, the buffer is copied back to the main matrix.
- At the end, the grid (without borders) is printed to standard output.
- For encryption/decryption, the matrix is traversed linearly, and its bits are used to generate a key for XOR operations on the message.
