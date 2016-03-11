/* File:	FILEDEMO.C  Example of accessing RA file
	Version:		0.3	(23/04/96)
	Author:		Damien Guard
	Copyright:  Envy Technologies, 1996.
	Notes:      This is an example of reading & using RemoteAccess data
					files using the RACDK.
*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <share.h>
#include "ra250c.h"

void main()
	{
		unsigned char sFileName[133];		/* Used to build us a filename */
		FILE *fileptr;							/* Standard file pointer */
		struct CONFIGrecord CONFIGrec;	/* Variable to match CONFIG.RA */

		puts("RACDK - Example of accessing RemoteAccess file");

		/* Get RA variable */
		strcpy(sFileName,getenv("RA"));
		if (sFileName != NULL) printf("       'RA' environment variable = %s\n",sFileName);
			else
			{
			 puts("       'RA' variable not found");
			 exit(1);
			};

		/* Build complete filename */
		if (sFileName[strlen(sFileName)]=='\\') strcat(sFileName,"CONFIG.RA");
			else strcat(sFileName,"\\CONFIG.RA");

		/* Actually open CONFIG.RA */
		printf("       Opening %s\n",sFileName);
		if ((fileptr=_fsopen(sFileName,"rb",SH_DENYNO)) == NULL) {
			printf("       Unable to read %s\n",sFileName);
			fclose(fileptr);
			exit(1);
		};

		/* Read in the record and close the file */
		fread(&CONFIGrec,sizeof(CONFIGrec),1,fileptr);
		fclose(fileptr);

		/* Convert the Pascal strings and display them */
		Pas2C(CONFIGrec.Sysop);
		Pas2C(CONFIGrec.SystemName);
		printf("       Sysop of %s is %s\n",CONFIGrec.SystemName,CONFIGrec.Sysop);
}