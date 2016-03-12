// Title:   TV Viewer r2
// Start:   13/03/95
// Build:   005 (Flibble)
// Comment: Door version
// Author:  Damien Guard, Envy Technologies
// Updates: 16/04/95	Added end times
//	    17/04/95    Add scroll up/down for channels


#include "opendoor.h"
#include <iostream.h>
#include <fstream.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <dos.h>

void initialise(int argc,char *argv[]);
void process(void);
void closedown(void);
void readline(void);
void ontvcheck(void);
void listbox(void);

struct datarec {
    char channel[9];
    char start[5];
    char rstart[5];
    char programme[46];
};

struct time timenow;
struct date datenow;

datarec first,second;
datarec listbox[100];
int listcnt;

ifstream datafile;
//---------------------------------------------------------------------------
int main(int argc,char *argv[]) {
    strcpy(od_registered_to,"Damien Guard");
    od_registration_key = 2070937600L;
    initialise(argc,argv);
    process();
    closedown();

    od_exit(0,FALSE);
    return(0);
}
//---------------------------------------------------------------------------
void initialise(int argc,char *argv[]) {
    char *daybuff;
    daybuff = new char[80];

    char *strdate;
    strdate = new char[13];

    char *tempbuf;
    tempbuf = new char[3];

    listcnt=0;

    if (argc == 1) {
        cerr << "TV-DOOR usage: TVDOOR drop-path\n\n";
        od_exit(1,FALSE);
    }

    od_control.od_config_filename = "TVDOOR.CFG";
    od_control.od_config_file = INCLUDE_CONFIG_FILE;
    od_control.od_mps = INCLUDE_MPS;
    strncpy(od_control.info_path,argv[1],59);

    od_init();
    od_clear_keybuffer();

    getdate(&datenow);
    gettime(&timenow);

    itoa(datenow.da_year,strdate,10);
    itoa(datenow.da_mon,tempbuf,10);
    if (tempbuf[1] == '\0') {
        tempbuf[1] = tempbuf[0];
        tempbuf[0] = '0';
    }
    strdate[4] = tempbuf[0];
    strdate[5] = tempbuf[1];
    itoa(datenow.da_day,tempbuf,10);
    if (tempbuf[1] == '\0') {
        tempbuf[1] = tempbuf[0];
        tempbuf[0] = '0';
    }

    strdate[6] = tempbuf[0];
    strdate[7] = tempbuf[1];
    strdate[8] = '.';
    strdate[9] = 'T';
    strdate[10] = 'V';
    strdate[11] = 'D';
    strdate[12] = '\0';

    datafile.open(strdate);
    if (!datafile) {
        cout << "TV-Door error: Datafile could not be opened\n\r";
        od_exit(1,FALSE);
    }

    datafile.get(daybuff,80,'\n');
    datafile.get();

    // do file checking here.
}
//---------------------------------------------------------------------------
void process(void) {
    od_clr_scr();
    od_send_file("TVHEAD");
    od_printf("\n\r");

    readline();
    first = second;

    while (!datafile.eof()) {
        readline();
        ontvcheck();
        first = second;
    };

    while(od_get_key(TRUE)!=13);
}
//---------------------------------------------------------------------------
void readline(void) {
    char *daybuff;
    daybuff = new char[80];

    datafile.get(daybuff,80,'\n');
    datafile.get();
    if (datafile.eof()) {
        strcpy(daybuff,"*END*   9999   Test");
    }

    strncpy(second.channel,daybuff,8);
    strncpy(second.start,daybuff+8,4);
    strncpy(second.rstart,daybuff+12,4);
    strncpy(second.programme,daybuff+16,45);
    daybuff[80] = '\0';

    second.channel[8] = '\0';
    second.start[4] = '\0';
    second.rstart[4] = '\0';
    second.programme[45] = '\0';
}
//---------------------------------------------------------------------------
void ontvcheck(void) {
    unsigned char shour,smin,ehour,emin;

    shour = (first.start[0] - 48)  * 10 + (first.start[1] - 48);
    smin  = (first.start[2] - 48)  * 10 + (first.start[3] - 48);
    ehour = (second.start[0] - 48) * 10 + (second.start[1] - 48);
    emin  = (second.start[2] - 48) * 10 + (second.start[3] - 48);

    if (!(strcmp(first.channel,second.channel))) {
        if (timenow.ti_hour > ehour)    return;
        if (timenow.ti_hour == ehour)
            if (timenow.ti_min == emin || timenow.ti_min > emin) return;
    }

    if (first.programme[0] == '*')  return;
    if (timenow.ti_hour < shour)    return;
    if (timenow.ti_hour == shour)
        if (timenow.ti_min < smin) return;


    if (!(strncmp(first.start,"0000",4))) strncpy(first.start,first.rstart,4);
    listbox[listcnt] = first;
    listcnt++;
//    od_printf("   `red`%s   `green`%s   `cyan`%s   `yellow`%s\n\r",first.channel,first.start,second.start,first.programme);

}
//---------------------------------------------------------------------------
void listbox(void) {
    listidx=0;
    while(od_get_key(FALSE)!=13) {
        showbox(listidx);
    };
}
//---------------------------------------------------------------------------
void closedown(void) {
    datafile.close();
}