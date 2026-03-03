// Monmouth University CS-104 project 1: type command in assembly (macOS)

.text				// Please keep this
.p2align 2			// Please keep this
.globl	_main			// Please keep this
_main:				// Start of main function
	// In the main function, we will set up the logic to open a file
	// and give ourself space to read the letters in the file we open.
	// main is a special name: it tells the computer that this is the
	// function to execute first. macOS calls it _main.

	// I will break up all the sub-problems into their own little
	// paragraphs. Feel free to come to office hours if you want to
	// debug your program and your thinking with me.

	// Remember when we talked about registers? What are registers?
	// We can also say that registers are effectively built-in variables
	// that we always have access to.
	// On Arm64 machines, we have 32 registers. But we don't need all
	// of them. Here is the list of the ones we need:
	// x0, x1, x2, x16, x20, sp
	// All of the registers except for sp can hold exactly one 64-bit
	// number. sp is special. When our program starts, it can't hold
	// anything! We need to write code to make it hold data. How much
	// data can sp hold? As much as we want! It's up to you.

	// There are also a lot (several hundred) instructions that your
	// CPU understands. But we won't need anywhere near that many.
	// Here are the ones we need:
	// mov, add, sub, cmp, b, beq, bne, blt, bge
	// You may find that you don't even need all of these. That's OK.

	// Arm64 assembly is very regular. We learned a lot over the first
	// 60 years of computers before Arm64 was invented. This is good.

	// We use three operands for arithmetic operations. Let's say we
	// want to add 3 to the x0 register. To do that, we would say:
	// add x0, x0, #3
	// That translates to x0 <-- x0 + 3, or "add 3 to x0 and store
	// the result back into x0"
	// That means you could copy the value of one register into
	// another by doing something like:
	// add x1, x2, #0
	// That translates to x1 <-- x2 + 0, or "add 0 to x2 and store
	// the result back into x1"
	// Here are some other helpful instructions:
	// cmp x0, #3 (means "compare the value of x0 with 3")
	// beq main (means "jump to the main function if the previous cmp
	// was in fact equal")

	// Let's start by checking to see if we have 2 arguments
	// The number of arguments we have lives in register x0
	// If we don't have exactly 2 arguments, go to the error function
	cmp x0,#2 
	bne error
	ldr	x0, [x1, #8]	// Puts the file name into register x0.

	// The line above puts the file name into the first argument
	// The x0 register always holds the first argument for a function
	// Now, we should tell the open function to read the file
	// How did we say to do that in class?
	// The second argument is always put into the x1 register

	mov	x16, #5		// Put the number 5 into register x16 (open)
	svc	#0x80		// Call the open function with 2 arguments

	// Here, we need to check the number that the open function gives
	// back to us.
	// If the number is less than 0, we should go to the error function
	// Whenever a function gives you back a number, that number will
	// live in the x0 register.

	cmp x16, #0 
	blt error 
	

	// Now, we should save the number the open function gave back to us
	// Let's say it to the x20 register (for reason outside this class,
	// it needs to be the x20 register; come talk to me during office
	// hours if you are curious why).

	mov x20, x16 

	// The last sub-problem to solve in the main function is to give
	// ourselves some space to store the letters we read from the file.
	// We will use sp for this. Remember that when our program starts,
	// sp can't hold anything. In order to store values into sp, we
	// need to *subtract* sp by the amount of data we want to store.
	// I know that sounds weird but just go with it (why it's subtract
	// and not add is beyond the scope of this class).
	// How many bytes do we need to store one ASCII character? Give
	// yourself at least that many bytes of storage space. If the
	// number of bytes we need isn't divisible by 8, round up to the
	// next multiple of 8.

	sub sp, sp, #800

loop:				// Start of the loop function
	// The loop function is where all the real work happens.

	// The first sub-problem is putting the value we saved to x20
	// into the first argument for read.

	mov x16, x20 // x16 is the read function or would it be x0? i thought x0 was the number of arguments   

	// Next, we put the value of sp into the second argument

	mov x1, sp // x1 doesnt feel right 

	// Finally, we put 1 into x2. The x2 register is always the third
	// argument for a function.

	mov x2, #1

	mov	x16, #3		// Put the number 3 into register x16 (read)
	svc	#0x80		// Call the read function with 3 arguments

	// After we read in a letter, we need to put that letter on the
	// screen.
	// To do that: put 1 in the first argument, put the value of sp
	// in the second argument, and put 1 in the third argument
	// A 1 in the first argument is shorthand for the screen

	mov	x16, #4		// Put the number 4 into register x16 (write)
	svc	#0x80		// Call the write function with 3 arguments

	// Now we need to check to see if the number we got back from the
	// write function is 1. If it is not equal to 1, then we should go
	// to the error function because it means something bad happened.

	cmp x16, #1 
	bne error

	// Last sub-problem for the loop function: if we got all the way
	// here, it means everything was success for this letter and we
	// should jump back to the top of the loop function so we can do
	// it all again with the next letter.

	//IS SOMETHING SUPPOSED TO GO HERE?

error:				// Start of the error function
	// You don't need to do anything with the error and done functions.
	mov	x0, #1		// Put the number 1 into register x0
done:				// Start of the done function
	mov	x16, #1		// Put the number 1 into register x16 (exit)
	svc	#0x80		// Call the exit function with 1 argument
