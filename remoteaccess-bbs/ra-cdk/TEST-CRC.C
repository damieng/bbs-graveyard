/* File:	TEST-CRC.C  CRC-32 test/example routine
	Version:		0.3	(22/04/96)
	Author:		Damien Guard
	Copyright:  Envy Technologies, 1996.
	Notes:	   This is a test shell for the 32-bit CRC routine in the RACDK.
					I have included it as it is quite usefull and shows how to
					use the CRC32 routine.

					To use this, compile it and run TESTCRC.EXE with the string
					you want to see the CRC for.  If the string includes spaces
					enclose the string with double-quotes.
*/

#include <stdio.h>			/* Needed for printf */
#include <string.h>		   /* Needed for strlen */
#include <conio.h>
#include "racdk.h"   		/* RACDK function library */

void main (int argc,char **argv) {
    /* argc = number of parameters from DOS + 1 */
    /* argv[1] is first parameter from DOS */

    puts("RACDK - Test CRC-32 routine/demonstration\n        ");
    if (argc==2) printf("The 32-bit CRC of '%s' is 0x%lx\n",
                            argv[1], CRC32(argv[1], strlen(argv[1])));
    else
        puts("Syntax: TESTCRC.EXE string\n");
    while(!kbhit()) TimeSlice();
}