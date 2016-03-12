/* File:	RASTATUS.C  RemoteAccess status update
	Version:	1.10	(26/05/96)
	Author:		Damien Guard
	Copyright:  Envy Technologies, 1996.
	Notes:      Compliments the Monitor/RA package to allow custom status
	Updates:    1.10 - Shared file access
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <share.h>
#include <ctype.h>
#include <ra250c.h>

unsigned int  iNode;								/* Node number to work with */
unsigned char sUser[36];
unsigned char sHandle[36];
unsigned char sLocation[26];
unsigned char sStatus[11];
unsigned char sUserDoes[71];
unsigned char sNode[4];
unsigned int  iBPS;
unsigned int  iCall;
unsigned int  iClear;

int Parse_Command_Line (int argc, char **argv);
void strrpl(char *string, int from, int to);

int main (int argc, char **argv) {
    unsigned char sFileName[133];		/* Used to build us a filename */
    FILE *fileptr;							/* Standard file pointer */
    struct CONFIGrecord CONFIGrec;   /* Variable to match CONFIG.RA */
    struct USERONrecord USERONrec;	/* Variable to match USERON.BBS */

    puts("VisualTools/RA - RA Status v1.10 (c) Copyright 1996 Envy Technologies");
    iNode=0;
    iClear=0;
    iBPS=27140;
    iCall=27140;
    sUser[0]=0;
    sHandle[0]=0;
    sLocation[0]=0;
    sStatus[0]=0;
    sUserDoes[0]=0;

    if (Parse_Command_Line(argc,argv)) exit(1);

    /* Get RA variable */
    strcpy(sFileName,getenv("RA"));
    if (sFileName == NULL) {
        puts("       'RA' variable not found");
        exit(1);
    };

    /* Build complete filename */
    if (sFileName[strlen(sFileName)]=='\\') strcat(sFileName,"CONFIG.RA");
    else strcat(sFileName,"\\CONFIG.RA");

    /* Actually open CONFIG.RA */
    if ((fileptr=_fsopen(sFileName,"rb",SH_DENYNO)) == NULL) {
        printf("       Unable to read %s\n",sFileName);
        fclose(fileptr);
        exit(1);
    };

    /* Read in the record and close the file */
    fread(&CONFIGrec,sizeof(CONFIGrec),1,fileptr);
    fclose(fileptr);

    cpyPas2C(sFileName,CONFIGrec.SysPath);
    if (sFileName[strlen(sFileName)-1]=='\\') strcat(sFileName,"USERON.BBS");
    else strcat(sFileName,"\\USERON.BBS");
    if ((fileptr=_fsopen(sFileName,"rb+",SH_DENYWR)) == NULL) {
        printf("       Unable to access %s\n",sFileName);
        fclose(fileptr);
        exit(1);
    };

    fseek(fileptr,(iNode-1)*sizeof(USERONrec),SEEK_SET);
    fread(&USERONrec,sizeof(USERONrec),1,fileptr);
    fseek(fileptr,(iNode-1)*sizeof(USERONrec),SEEK_SET);
    USERONrec.Line = iNode;
    if (iClear==1) {
        cpyC2Pas(USERONrec.Name,'\0');
        cpyC2Pas(USERONrec.Handle,'\0');
        cpyC2Pas(USERONrec.City,'\0');
        cpyC2Pas(USERONrec.StatDesc,'\0');
        USERONrec.Line = 0;
        USERONrec.Status = 255;
        USERONrec.Attribute = 16;
        USERONrec.Baud = 0;
        USERONrec.NoCalls = 0;
    };
    if (sUser[0] != 0) {
        cpyC2Pas(USERONrec.Name,sUser);
        USERONrec.Line = iNode;
    };
    if (sHandle[0] != 0) cpyC2Pas(USERONrec.Handle,sHandle);
    if (sLocation[0] != 0) cpyC2Pas(USERONrec.City,sLocation);
    if (sStatus[0] != 0) {
        cpyC2Pas(USERONrec.StatDesc,sStatus);
        USERONrec.Status = 255;
    }
    if (iBPS != 27140) USERONrec.Baud = iBPS;
    if (iCall != 27140) USERONrec.NoCalls = iCall;
    fwrite(&USERONrec,sizeof(USERONrec),1,fileptr);
    fclose(fileptr);
    if (sUserDoes[0] != 0) {
        cpyPas2C(sFileName,CONFIGrec.SemPath);
        strcat(sFileName,"USERDOES.");
        itoa(iNode,sNode,10);
        strcat(sFileName,sNode);
        if ((fileptr=fopen(sFileName,"w")) != NULL)
            fwrite(&sUserDoes,sizeof(sUserDoes),1,fileptr);
        fclose(fileptr);
    };
    return(0);
}
//---------------------------------------------------------------------------
int Parse_Command_Line (int argc, char **argv) {
    int arg = 0;

    while (++arg < argc) {
        if (argv[arg][0] == '-' || argv[arg][0] == '/') {
            switch (toupper (argv[arg][1])) {
            case '?':
                puts("Syntax:    RASTATUS [switches]");
                puts("Switches:  /N   Node (required)");
                puts("           /U   User name");
                puts("           /H   Handle");
                puts("           /B   BPS rate");
                puts("           /L   Location");
                puts("           /S   Status text");
                puts("           /C   Call number");
                puts("           /D   Create USERDOES information");
                puts("           /X   Clear other data");
                puts("Note:      All spaces in text fields should be '_' instead.");
                return(1);
            case 'N':
                iNode = atoi(argv[arg]+2);
                break;
            case 'X':
                iClear = 1;
                break;
            case 'U':
                strncpy(sUser,argv[arg]+2,35);
                strrpl(sUser,'_',' ');
                break;
            case 'H':
                strncpy(sHandle,argv[arg]+2,35);
                strrpl(sHandle,'_',' ');
                break;
            case 'B':
                iBPS = atoi(argv[arg]+2);
                break;
            case 'L':
                strncpy(sLocation,argv[arg]+2,25);
                strrpl(sLocation,'_',' ');
                break;
            case 'S':
                strncpy(sStatus,argv[arg]+2,10);
                strrpl(sStatus,'_',' ');
                break;
            case 'C':
                iCall = atoi(argv[arg]+2);
                break;
            case 'D':
                strncpy(sUserDoes,argv[arg]+2,70);
                strrpl(sUserDoes,'_',' ');
                break;
            }  // switch
        }  // if argv[0]
    }   // while
    if (iNode!=0) return(0);
    else {
        puts("Error:     No node number specified");
        puts("           Use RASTATUS /? for help information");
        return(1);
    }
}
void strrpl(char *string, int from, int to) {
    int loop;
    for (loop=0; loop<strlen(string); loop++)
        if (string[loop] == from) string[loop] = to;
}