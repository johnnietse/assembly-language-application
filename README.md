# Nios II Assembly Language Programs - Computer Architecture Labs
This repository contains Nios II assembly language programs developed for the Computer Architecture course. Each lab explores different aspects of low-level programming and hardware interactions using the Nios II instruction set.

## Lab 1: Basic Arithmetic and Memory Operations
### Description
This program performs basic arithmetic operations using load, store, subtract, and multiply instructions. The results are stored in memory for further computations.

### Operations
- Subtract the value in memory location A from W and store the result in X.
- Increment the value in X and multiply by the value in F, storing the result in C.
- Add the value in C to F, divide the result by A, and store the final result in J.

### Memory Map
A: Initial value = 2
F: Initial value = 3
W: Initial value = 6
X, C, J: Used to store intermediate and final results.

### Execution
The program starts at address 0x0000 and performs the computations, storing the results at the predefined memory locations.



## Lab 2: List Manipulation with Function Calls
### Description
This lab introduces function calls and list manipulations. The program compares values from two lists, modifies the values based on conditions, and counts how many values satisfy the conditions.

### Operations
- Compares elements from LIST1 and LIST2.
- If an element from LIST1 is greater than 3 * LIST2, the value is set to 0 in LIST1 and 15 in LIST2.
- Counts how many comparisons satisfy the condition.

### Memory Map
- LIST1: {8, 9, 10}
- LIST2: {3, 2, 1}
- Count: Stores the final count of elements that satisfied the condition.

### Execution
The main function calls ListComputation, which performs the list comparison and updates the count.



## Lab 3: UART I/O and Bitwise Operations
### Description
This lab focuses on performing UART I/O operations and manipulating lists of bytes through bitwise operations. The program demonstrates how to print data using the JTAG UART interface and manipulate the values in memory.

### Operations
- Print a string ("Lab 3") and a list of bytes using the JTAG UART.
- Shift each byte of the list left by 4 bits and print the modified list.
- Perform conditional OR operations on the list values and display the modified list again.

### Key Subroutines
- PrintString: Prints a null-terminated string via UART.
- PrintByteList: Prints a list of bytes in hexadecimal format.
- LeftShiftByteList: Shifts each byte in a list by 4 bits to the left.
- PrintHexByte: Prints a single byte in hexadecimal.
- PrintChar: Sends a single character to the JTAG UART.

### Memory Map
- LIST: Contains the initial byte list {0x2C, 0xE8, 0xF4, 0x75}.
- TEXT: Displays the string "Lab 3".

### Execution
The program interacts with the JTAG UART to print data and manipulate the list of bytes, showcasing bitwise operations and UART output.


## Lab 4: UART I/O, Conditional Logic, and Byte Manipulation
### Description
This lab involves handling UART I/O, conditional logic based on user input, and manipulating byte values in memory. The program demonstrates how to print a header, manipulate a list of bytes, accept user input, and modify the list conditionally.

### Operations
- Print a header ("Lab 4") using the JTAG UART.
- Display a list of bytes in hexadecimal format along with special characters.
- Accept user input from the JTAG UART, compare the input with the character 'Z', and modify the list accordingly.
- Print both the byte from the list and the corresponding user input.

### Key Subroutines
- PrintString: Prints a null-terminated string using the JTAG UART.
- PrintHexByte: Prints a byte in hexadecimal format.
- PrintChar: Sends a single character to the JTAG UART.
- GetChar: Reads a single character from the JTAG UART.
- PrintHexDigit: Converts a single nibble (4 bits) into a hexadecimal character and prints it.

### Memory Map
- LIST: Contains the initial byte list {0x88, 0xA3, 0xF2, 0x1C}.
- TEXT: Displays the string "Lab 4\n".
- N: Holds the size of the list (4 bytes).


### Execution Flow

1. Header Printing:
The program starts by printing the string "Lab 4\n" to the JTAG UART using a loop that reads characters from memory until it encounters a null terminator.

2. Byte List Display:
Each byte in the list is printed in hexadecimal format using the PrintHexByte subroutine. A question mark (?) and a space are printed after each byte for clarity.

3. User Input Handling:
For each byte in the list, the program waits for the user to input a character via the JTAG UART. It echoes the input and checks if it is the letter 'Z'. If 'Z' is entered, the corresponding byte in the list is set to 0x00.

4. Loop Termination:
The program continues until all bytes in the list have been processed. If the input character is 'Z', the corresponding byte is modified; otherwise, the list remains unchanged.

### Subroutine Descriptions

- PrintChar: Sends a single character from a register to the JTAG UART data register, waiting for the UART to be ready.
- GetChar: Reads a character from the JTAG UART data register, waiting until data is available.
- PrintHexByte: Breaks a byte into two nibbles (4-bit halves), converts each to hexadecimal using PrintHexDigit, and prints both.
- PrintHexDigit: Converts a 4-bit nibble to a hexadecimal character and sends it to the UART.





