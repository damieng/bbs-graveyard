// Title:   CoolChat
// Start:   11/07/95
// Build:   003
// Comment: Door version
// Author:  Damien Guard, Envy Technologies
// Updates: 26/07/95  Add page another node
//          12/09/95  Remove 20 minute-crash-throwoff bug
//	    01/12/95  Sharing violation problem

#include <dos.h>
#include <time.h>
#include "opendoor.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "tasker.h"
#include <share.h>
#include "sys\stat.h"
#include <iostream.h>
#include <io.h>
#include <fcntl.h>
#include "rastruct.c"

void initialise(int argc,char *argv[]);
void process(void);
void closedown(void);
void enterloop(void);
void mainloop(void);
void screenline(char readline[]);
void writedata(void);
void whoonline(void);
void *winptr;

struct coolon {
    unsigned char name[36];
    unsigned char timehhh[2];
    unsigned char timehmm[2];
    unsigned char timelhh[2];
    unsigned char timelmm[2];
    unsigned char free[4];
};

struct ts_os_ver t_os_ver[TOT_OS];
int t_os_type;
int t_os;

const char *t_os_name[TOT_OS] = {
    "DOS",
    "OS/2",
    "DESQview",
    "Windows Std",
    "Windows"
};

coolon coolrec;
char writeline[80];
char readline[80];
char mystring[241];
char *radir;
unsigned int mykey,chars,topline;
long int storep;
FILE *faopen(), *faptr;
FILE *fuopen(), *fuptr;

//---------------------------------------------------------------------------
int main(int argc,char *argv[]) {
    strcpy(od_registered_to,"Damien Guard");
    od_registration_key = 2070937600L;
    od_control.od_nocopyright = TRUE;
    initialise(argc,argv);
    process();
    closedown();

    od_exit(0,FALSE);
    return(0);
}
//---------------------------------------------------------------------------
void initialise(int argc,char *argv[]) {
    long int offset;

    strcpy(radir,getenv("RA"));
    strcat(radir,"\\USERON.BBS");

    if (argc == 1) {
        cerr << "CoolChat usage: CoolChat drop-path\n\n";
        od_exit(1,FALSE);
    }

    get_os();
    strcpy(od_control.od_prog_name,"CoolChat");
    od_control.od_config_filename = "COOLCHAT.CFG";
    od_control.od_config_file = INCLUDE_CONFIG_FILE;
    od_control.od_mps = INCLUDE_MPS;
    strncpy(od_control.info_path,argv[1],59);

    od_init();
    od_clear_keybuffer();
    od_control.od_list_stop = FALSE;
    od_control.od_page_pausing = FALSE;
    od_control.od_colour_char = 0;
    od_control.od_inactive_warning = 0;
    od_control.od_inactivity = 240;
    od_control.od_maxtime = 0;
    /*  if ((fuptr=fopen("COOLCHAT.NJF","a+")) == NULL )
           {
    	cerr << "CoolChat error: Cannot create/update COOLCHAT.NJF\n\n";
    	od_exit(1,FALSE);
           };
        fseek(fuptr,0,2);
        if (ftell(fuptr) < 480) while (ftell(fuptr)<480)  { fputc(' ',fuptr); };
        fseek(fuptr,(48*od_control.od_node),0);
        strncpy(coolrec.name,od_control.user_name,36);

        strncpy(coolrec.timehhh,&timenow.ti_hour,2);
        strncpy(coolrec.timehmm,&timenow.ti_min,2);
        fwrite(&coolrec,sizeof(coolrec),1,fuptr);
        fclose(fuptr);
    		  */
    if ((faptr=_fsopen("COOLCHAT.IDX","a+",SH_DENYNO)) == NULL ) {
        cerr << "CoolChat error: Cannot create/update COOLCHAT.IDX\n\n";
        od_exit(1,FALSE);
    };
    fseek(faptr,0,2);
    storep=ftell(faptr);
    fputs("System              ",faptr);
    fputs(od_control.user_name,faptr);
    fputs(" has entered CoolChat!",faptr);
    fputc('\n',faptr);
    fclose(faptr);
    faptr=_fsopen("COOLCHAT.IDX","r+",SH_DENYNO);
    topline=0;
    fseek(faptr,storep,0);
}
//---------------------------------------------------------------------------
void process(void) {
    FILE *filehandle;
    void *whowinptr;
    unsigned int busycheck;
    unsigned char menukey;
    unsigned char pagenote[61];
    unsigned char pagenode[4];
    unsigned char checkon[51];
    unsigned char writenote[241];
    unsigned char strnode[4];
    od_clr_scr();
    od_send_file("COOLCHAT");

priloop:
    od_set_cursor(1,41);
    od_set_colour(L_GREEN,D_BLACK);
    od_disp_str("menu");
    while (mykey!=27) mainloop();
    od_set_cursor(1,41);
    od_set_colour(L_GREEN,D_BLACK);
    od_disp_str("chat");
    winptr=od_window_create(30,5,50,11,"Menu",30,26,20,0);
    od_set_cursor(6,32);
    od_set_colour(L_CYAN,D_BLUE);
    od_disp_str("W  Who's here");
    od_set_cursor(7,32);
    od_disp_str("O  Who's online");
    od_set_cursor(8,32);
    od_disp_str("S  Send note");
    od_set_cursor(10,32);
    od_disp_str("X  Exit");

secloop:
    menukey = od_get_key(TRUE);

    if ((menukey == 'X') | (menukey == 'x')) return;
    if (menukey == 27) {
        od_window_remove(winptr);
        mykey=0;
        goto priloop;
    };
    if ((menukey == 'W') | (menukey == 'w')) {
        whowinptr=od_window_create(10,8,70,20,"Who's here",14,12,6,0);
        od_set_cursor(15,12);
        od_disp_str("Function not implemented (yet).");
        od_get_key(TRUE);
        od_window_remove(whowinptr);
        goto secloop;
    };
    if ((menukey == 'O') | (menukey == 'o')) {
        whowinptr=od_window_create(10,8,70,20,"Who's online",14,12,6,0);
        whoonline();
        od_get_key(TRUE);
        od_window_remove(whowinptr);
        goto secloop;
    };
    if ((menukey == 'S') | (menukey == 's')) {
        whowinptr=od_window_create(10,8,70,10,"Send Note",14,12,6,0);
        od_set_cursor(9,12);
        od_set_colour(L_CYAN,D_BLACK);
        od_disp_str("Node: ");
        od_set_cursor(9,18);
        od_input_str(pagenode,1,48,57);
        strcpy(checkon,getenv("RA"));
        strcat(checkon,"\\RABUSY.");
        strcat(checkon,pagenode);
        od_set_cursor(L_GREEN,D_BLACK);
        od_set_cursor(9,12);
        od_disp_str("Message: ");
        od_set_cursor(9,21);
        od_input_str(pagenote,48,32,127);
        strcpy(checkon,getenv("RA"));
        strcat(checkon,"\\NODE");
        strcat(checkon,pagenode);
        strcat(checkon,".RA");
        strcpy(writenote,"CoolChat note from ");
        strcat(writenote,od_control.user_name);
        strcat(writenote," on node ");
        itoa(od_control.od_node,strnode,10);
        strcat(writenote,strnode);
        strcat(writenote,"\n");
        strcat(writenote,pagenote);
        strcat(writenote,"\n");
        strcat(writenote,"Press [ENTER] to continue...");
        filehandle = fopen(checkon, "w+");
        fwrite(writenote, strlen(writenote),1,filehandle);
        fclose(filehandle);
        od_window_remove(whowinptr);
        goto secloop;
    };


    goto secloop;
}
//---------------------------------------------------------------------------
void mainloop(void) {
    int tline,x,y;
    od_set_cursor(20,2);
    od_set_color(L_YELLOW,D_BLACK);

    do {
        enterloop();
    } while ((mykey !=13) & (mykey !=27));

    if (mykey==27) return;
    if ((mykey==13) & chars != 0) writedata();

    y=int(chars/76);
    x=chars-(y*76);
    tline=0;
    do {
        od_set_cursor(20+tline,2);
        od_repeat(' ',76);
        tline++;
    } while (tline<y) ;

    od_set_cursor(20+tline,2);
    od_repeat(' ',x);
}
//---------------------------------------------------------------------------
void enterloop(void) {
    int x,y,templen;
    char templenx[2];
    char *tempdate;
    tempdate = new char[20];
    time_t start,now;
    start=time(NULL);
    chars=0;

loop:
    do {
        now=time(NULL);
        t_slice();
        mykey=od_get_key(FALSE);
    } while ((mykey == 0) & (difftime(now,start) < (double) 1));

    if (mykey == 27) return;
    if (mykey == 13) {
        mystring[chars]='\0';
        return;
    };

    if (mykey == 0) {
        fgets(readline,80,faptr);
        readline[strlen(readline)-1] = '\0';
        do {
            if (ftell(faptr) != storep) screenline(readline);
            fgets(readline,80,faptr);
            readline[strlen(readline)-1] = '\0';
        } while (!feof(faptr));
        storep = ftell(faptr);

        od_set_cursor(1,70);
        strcpy(tempdate,ctime(&now));
        tempdate[19]='\0';
        od_set_color(L_MAGENTA,D_BLACK);
        od_disp_str(tempdate+11);
        start=time(NULL);
        goto loop;
    };

    if ((mykey == 8) & chars > 0) {
        chars--;
        mystring[chars] = 32;
        y=int(chars/76);
        x=chars-(y*76);
        od_set_cursor(20+y,x+2);
        od_printf("%c",mystring[chars]);
        od_set_cursor(20+y,x+2);
        goto loop;
    };

    if (mykey < 32) goto loop;

    if (chars < 228) {
        mystring[chars] = mykey;
        y=int(chars/76);
        x=chars-(y*76);
        od_set_cursor(20+y,x+2);
        od_set_color(L_YELLOW,D_BLACK);
        od_printf("%c",mystring[chars]);
        chars++;
        goto loop;
    };

    goto loop;
}
//---------------------------------------------------------------------------
void screenline(char outline[]) {
    int ptr;
    char tempbuff[21];
    if (topline==15) {
        od_scroll(2,3,78,17,6,0);
        for (int f=15; f<18; f++) {
            od_set_cursor(f,2);
            od_repeat(' ',76);
        };
        topline=9;
    };

    od_set_cursor(3+topline,2);

    strncpy(tempbuff,outline,20);
    tempbuff[20]='\0';
    ptr = strncmp(tempbuff,"System",6);
    if (ptr == 0) {
        od_set_color(D_GREEN,D_BLACK);
        od_disp_str(tempbuff);
        od_set_color(D_GREY,D_BLACK);
    } else {
        od_set_color(L_CYAN,D_BLACK);
        od_disp_str(tempbuff);
        od_set_color(L_WHITE,D_BLACK);
    };

    od_disp_str(outline+20);
    topline=topline+1;
}
//---------------------------------------------------------------------------
void writedata(void) {
    long int originalbuf;
    char tempout[80];

    strncpy(writeline,mystring,56);
    storep = ftell(faptr);
    fclose(faptr);

    faptr=_fsopen("COOLCHAT.IDX","a+",SH_DENYNO);
    fseek(faptr,0,2);

    stpcpy(tempout,od_control.user_name);
    strncat(tempout,"                    ",20-strlen(tempout));
    fputs(tempout,faptr);
    fputs(writeline,faptr);
    fputc('\n',faptr);
    for (int f=56; f<strlen(mystring); f=f+56) {
        fputs("                    ",faptr);
        strncpy(writeline,mystring+f,56);
        fputs(writeline,faptr);
        fputc('\n',faptr);
    };
    fclose(faptr);

    faptr=_fsopen("COOLCHAT.IDX","r+",SH_DENYNO);
    fseek(faptr,storep,SEEK_SET);
}
//---------------------------------------------------------------------------
void whoonline(void) {
    USERONrecord userrec;
    if ((fuptr=_fsopen(radir,"rb",SH_DENYNO)) == NULL) {
        od_set_cursor(11,30);
        od_set_colour(L_RED,D_BLACK);
        od_disp_str("Error, USERON.BBS not found!");
        fclose(fuptr);
        return;
    };
    od_set_colour(L_CYAN,D_BLACK);
    od_set_cursor(10,12);
    od_disp_str("Node User");
    od_set_cursor(10,37);
    od_disp_str("Location");
    od_set_cursor(10,57);
    od_disp_str("Doing");
    od_set_colour(L_WHITE,D_BLACK);
    while (!feof(fuptr)) {
        fread(&userrec,sizeof(userrec),1,fuptr);
        if (userrec.Line == 0) {
            fclose(fuptr);
            return;
        };
        Pas2C(userrec.Name);
        Pas2C(userrec.Handle);
        Pas2C(userrec.City);
        od_set_cursor(10+userrec.Line,13);
        od_printf("%d",userrec.Line);
        od_set_cursor(10+userrec.Line,17);
        od_disp_str(userrec.Name);
        od_set_cursor(10+userrec.Line,37);
        od_disp_str(userrec.City);
        od_set_cursor(10+userrec.Line,57);
        switch (userrec.Status) {
        case 0:
            od_disp_str("Browsing");
            break;
        case 1:
            od_disp_str("File transfer");
            break;
        case 2:
            od_disp_str("Messaging");
            break;
        case 3:
            od_disp_str("Door");
            break;
        case 4:
            od_disp_str("Sysop chat");
            break;
        case 5:
            od_disp_str("Questionnaire");
            break;
        case 6:
            od_disp_str("Conference");
            break;
        case 7:
            od_disp_str("Registration");
            break;
        case 255:
            Pas2C(userrec.StatDesc);
            od_disp_str(userrec.StatDesc);
            break;
        };
    };
    fclose(fuptr);
};
//---------------------------------------------------------------------------
void closedown(void) {
    fclose(faptr);
    faptr=_fsopen("COOLCHAT.IDX","a+",SH_DENYNO);
    fputs("System              ",faptr);
    fputs(od_control.user_name,faptr);
    fputs(" has left CoolChat!",faptr);
    fputc('\n',faptr);
    fclose(faptr);
    //remove("COOLCHAT.IDX");
}
//---------------------------------------------------------------------------
int get_os (void) {
    union REGS t_regs;

    t_os_type = 0;
    t_os = 0;

    /* test for DOS or OS/2 */

    if (_osmajor < 10) {
        t_os_ver[DOS].maj = _osmajor;
        t_os_ver[DOS].min = _osminor;
        t_os_type = t_os_type | is_DOS;
    } else {
        t_os_type = t_os_type | is_OS2;
        t_os_ver[OS2].maj = _osmajor/10;
        t_os_ver[OS2].min = _osminor;
    }

    /* test for Windows */

    t_regs.x.ax = 0x4680;
    int86(0x2F, &t_regs, &t_regs);

    if (t_regs.x.ax == 0x0000) {
        t_os_ver[WINS].maj = 3;
        t_os_ver[WINS].min = 0;
        t_os_type = t_os_type | is_WINS;
    } else {
        t_regs.x.ax = 0x1600 ;
        int86(0x2F, &t_regs, &t_regs);

        switch (t_regs.h.al) {
        case 0x00 :
        case 0x80 :
        case 0x01 :
        case 0xFF :
            break;

        default   :
            t_os_type = t_os_type | is_WIN3;
            t_os_ver[WIN3].maj = t_regs.h.al;
            t_os_ver[WIN3].min = t_regs.h.ah;
            break ;
        }
    }

    /* Test for DESQview */

    t_regs.x.cx = 0x4445;     /* load incorrect date */
    t_regs.x.dx = 0x5351;
    t_regs.x.ax = 0x2B01;     /*  DV set up call     */

    intdos(&t_regs, &t_regs);
    if (t_regs.h.al != 0xFF) {
        t_os_type = t_os_type | is_DV;
        t_os_ver[DV].maj = t_regs.h.bh;
        t_os_ver[DV].min = t_regs.h.bl;
    }

    if(t_os_type & is_DOS)
        t_os = DOS;

    if(t_os_type & is_WINS)
        t_os = WINS;

    if(t_os_type & is_WIN3)
        t_os = WIN3;

    if(t_os_type & is_DV)
        t_os = DV;

    if(t_os_type & is_OS2)
        t_os = OS2;

    return(t_os-1);

}
//---------------------------------------------------------------------------
void t_slice(void) {
    union REGS t_regs;

    switch (t_os) {
    case DOS  :
        break;

    case OS2  :
    case WIN3 :
    case WINS :
        t_regs.x.ax = 0x1680;
        int86(0x2f,&t_regs,&t_regs);
        break;

    case DV   :
        t_regs.x.ax = 0x1000;
        int86(0x15,&t_regs,&t_regs);
        break;
    }
}
