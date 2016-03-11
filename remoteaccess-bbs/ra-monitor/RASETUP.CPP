/*-----------------------------------------------------------------------
   Title:   RA-Monitor Setup
   Start:   07/1/95
   Comment: Setup/configuration program for RA-Monitor
   Author:  Damien Guard, Envy Technologies
	Updates: 1.00 - Upper convert node template
						 Strip end of node template off
						 Add mouse mode configuration
				1.10 - Optional UserDoes support
				1.20 - New date format option
						 Confirm save changes on exit
-----------------------------------------------------------------------*/
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <io.h>
#include <dos.h>
#include <share.h>
#include <conio.h>
#include <ctype.h>
#include <tasker.h>
#include "\projects\racdk\ra250c.h"
#include "ramoncfg.h"
#include "LVSwin.HPP"       // LVS Windows main header
#include "LVSmenu.hpp"      // Menu class header file
//-----------------------------------------------------------------------
int Initialize();
void SetupScreen(), ShowTime(), MainLoop(), ShowMouse(), ShowUserDoes();
void ShowPath(), ShowRefresh(), ShowAbout(), ShowDefault(), ShowError();
void ShowDateFmt();
//-----------------------------------------------------------------------
struct ts_os_ver t_os_ver[TOT_OS];
int t_os_type;
int t_os;
char t_os_name[41];	    // Operating system name
char app_name[18];
CONFIGrecord CONFIGrec;	// CONFIG.RA storage
RAMONrecord RAMONrec;
//-----------------------------------------------------------------------
char sTempFile[81];	    // Temporary filename
FILE *fileptr;		    // Temporary file pointer
int VGA;		    // VGA graphics mode
int max_y;		    // Maximum screen lines
int max_x;		    // Maximum vertical columns
int showDefault;
//-----------------------------------------------------------------------
void main()
{
    strcpy(app_name,"RA-Monitor setup");
	 if (Initialize()!=1) {
	SetupScreen();
	MainLoop();
	Win_showcur;
	Win_close_all();
	clrscr();
	printf("%s info: Running under %s v%d.%d\n",app_name, t_os_name, t_os_ver[t_os].maj, t_os_ver[t_os].min);
	 };
}
//-----------------------------------------------------------------------
int Initialize(void)
{
	 Win_setrows(peekb(0x40,0x84)+1); // Resize to video mode
	 get_os();  // Detect which OS using to multitask
	 Win_shadow_by_default(TRUE);
	 showDefault=0;

	 // Setup the required filenames
	 strcpy(sTempFile,"CONFIG.RA");
	 if ((fileptr=_fsopen(sTempFile,"rb",SH_DENYNO)) == NULL) {
		 fclose(fileptr);
		strcpy(sTempFile,getenv("RA"));
		if (strlen(sTempFile)==0) {
			printf("\n%s error: 'RA' variable not set\n",app_name);
			return(1);
			};
		strcat(sTempFile,"\\CONFIG.RA");
		// Get the RA semaphore path
		if ((fileptr=_fsopen(sTempFile,"rb",SH_DENYNO)) == NULL) {
			printf("\n%s error: Cannot read CONFIG.RA (%s)\n",app_name,sTempFile);
			fclose(fileptr);
			return(1);
			};
	};

	 fread(&CONFIGrec,sizeof(CONFIGrec),1,fileptr);
	 fclose(fileptr);
	 if (CONFIGrec.MonoMode==1) Win_mono(W_ON); else Win_mono(W_OFF);
	 if (CONFIGrec.DirectWrite==1) Win_bios(W_OFF); else Win_bios(W_ON);
	 if (CONFIGrec.SnowCheck==1) Win_snow(W_ON); else Win_snow(W_OFF);
	 strcpy(sTempFile,"RAMON.CFG");
	 if ((fileptr=_fsopen(sTempFile,"rb",SH_DENYNO)) == NULL) {
		 showDefault++;
		 strcpy(RAMONrec.sRA_Nodes,"\\NODE*N");
		 RAMONrec.iRefresh=2; // maybe calc from io speed? //
		 RAMONrec.iExitLevel=0;
		 RAMONrec.iMouseMode=0;
		 RAMONrec.iUserDoes=0;
		 RAMONrec.iDateFmt=0;
	  } else {
		 fread(&RAMONrec,sizeof(RAMONrec),1,fileptr);
	 };
	 fclose(fileptr);

	 Win_setbkloop(ShowTime);
	 Win_hidecur();
	 max_y = Win_Max_y ();           // Get the max y coordinate
	 max_x = Win_Max_x ();
	 return(0);
};
//-----------------------------------------------------------------------
static WinObj clock_win;
void ShowTime ()
{
	 static struct Win_time_s t;
	 static unsigned char hold;

    if (!clock_win.is_open()) {
	clock_win.open(0,0,1,79,W_NOBORDER,_BLACK|BLUE);
	clock_win.puts(1,0,"ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ");
	clock_win.set_attr(_BLACK|YELLOW);
	clock_win.puts(0,1,"RA-Monitor SETUP 1.21");
		 };

    Win_gettime(&t);
    if (hold!=t.sec) {
	hold=t.sec;
	clock_win.printf(0,71,"%02d:%02d:%02d",t.hour,t.min,t.sec);
       };
    t_slice();
}
//-----------------------------------------------------------------------
static WinObj Main;         // the main screen window
void SetupScreen()
{
	 Win_clrscr();
	 Main.open(0,0,max_y,79,W_NOBORDER,_BLACK|LGREY);
	 for (int x=0; x < max_y * 2 + max_y / 5; x++)
		Main.puts("±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±");
	 Main.set_attr(_BLACK|BLUE);
    Main.puts(max_y-1,0,"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ");
	 ShowTime();
}
//---------------------------------------------------------------------------
void MainLoop()
{
	 WinMenu MainMenu;
	 WinObj ConfirmWin;
	 int iChoice = 0;

	 if (showDefault) ShowDefault();
	 MainMenu.open(max_y/2-4,max_x/2-7,max_y/2+5,max_x/2+7,W_DOUSIN,_BLACK|CYAN,_BLACK|LCYAN);
	 MainMenu.set_title_attr(_BLUE|YELLOW);
	 MainMenu.title(" Setup ",W_RIGHT);
	 MainMenu.set_barattr(_LGREY|BLUE);
	 MainMenu.message_line(max_y);
	 MainMenu.message_attr(_BLACK|LGREY);
	 MainMenu.prompt(0,0,0," Refresh     ","Set refresh interval",'P');
	 MainMenu.prompt(1,0,1," Node path   ","Configure node path",'S');
	 MainMenu.prompt(2,0,2," Errorlevel  ","Configure RA exit error level",'E');
	 MainMenu.prompt(3,0,3," Mouse mode  ","Configure mouse mode",'M');
	 MainMenu.prompt(4,0,4," User does   ","User does support on/off",'U');
	 MainMenu.prompt(5,0,5," Date format ","Choose a date format",'D');
	 MainMenu.prompt(6,0,6," About       ","About RA-Monitor Setup",'A');
	 MainMenu.prompt(7,0,7," Exit        ","Exit RA-Monitor Setup",'X');
	 while (iChoice!=7) {
		iChoice=MainMenu.read(iChoice);
		switch (iChoice) {
			case 0 : ShowRefresh(); break;
			case 1 : ShowPath(); break;
			case 2 : ShowError(); break;
			case 3 : ShowMouse(); break;
			case 4 : ShowUserDoes(); break;
			case 5 : ShowDateFmt(); break;
			case 6 : ShowAbout(); break;
		  }
	 if (iChoice==7) {
		 ConfirmWin.open((max_y/2)-2,24,(max_y/2)+2,55,W_DOUSIN,_BLUE|LGREY,_BLUE|LBLUE);
		 ConfirmWin.printf(1,1,"Save configuration (Y,n) ? °");
		 Win_hidecur();
		 if (Win_getkey(0)>>8!=49) {  // Press Y to confirm
			 strcpy(sTempFile,"RAMON.CFG");
			 if ((fileptr=_fsopen(sTempFile,"wb",SH_DENYNO)) == NULL) {
				 fclose(fileptr);
				 return;
			 };
			 fwrite(&RAMONrec,sizeof(RAMONrec),1,fileptr);
			 fclose(fileptr);
		 };
		 ConfirmWin.close();
	 };

  }
}
//---------------------------------------------------------------------------
void ShowPath()
{
      WinObj PathWin;
      char sTempPath[81];
      int iKey;
		strcpy(sTempPath,RAMONrec.sRA_Nodes);
		PathWin.open((max_y/2)-2,max_x/2-35,(max_y/2)+1,max_x/2+35,W_DOUSIN,_BLACK|LGREEN,_BLACK|LCYAN);
      PathWin.set_title_attr(_BLUE|YELLOW);
		PathWin.title(" Node path ",W_RIGHT);
      PathWin.printf(0,1,"Node path template from %s (*N = Node)",getenv("RA"));
      PathWin.set_getattr(_GREEN|BLUE);
		PathWin.get(1,1,sTempPath,UPPER_STYLE,67);
      iKey=PathWin.read()>>8;
		if (iKey!=28) return;
		strtrim(sTempPath);
		strcpy(RAMONrec.sRA_Nodes,sTempPath);
		PathWin.close();
};
//---------------------------------------------------------------------------
void ShowRefresh()
{
		WinObj RefreshWin;
		int iKey;
      int iRefresh = RAMONrec.iRefresh;
		RefreshWin.open((max_y/2)-2,max_x/2-17,(max_y/2)+1,max_x/2+17,W_DOUSIN,_BLACK|LGREEN,_BLACK|LCYAN);
		RefreshWin.set_title_attr(_BLUE|YELLOW);
      RefreshWin.title(" Refresh ",W_RIGHT);
      RefreshWin.puts(0,1,"Refresh interval in seconds");
      RefreshWin.set_getattr(_GREEN|BLUE);
      RefreshWin.get(1,1,iRefresh,3);
      iKey=RefreshWin.read()>>8;
		if (iKey!=28) return;
		RAMONrec.iRefresh = iRefresh;
      RefreshWin.close();

};
//---------------------------------------------------------------------------
void ShowError()
{
		WinObj ErrorWin;
		int iKey;
		int iError = RAMONrec.iExitLevel;
		ErrorWin.open((max_y/2)-2,max_x/2-17,(max_y/2)+1,max_x/2+17,W_DOUSIN,_BLACK|LGREEN,_BLACK|LCYAN);
		ErrorWin.set_title_attr(_BLUE|YELLOW);
		ErrorWin.title(" Error level ",W_RIGHT);
		ErrorWin.puts(0,1,"Normal RA exit errorlevel");
		ErrorWin.set_getattr(_GREEN|BLUE);
		ErrorWin.get(1,1,iError,3);
		iKey=ErrorWin.read()>>8;
		if (iKey!=28) return;
		RAMONrec.iExitLevel = iError;
		ErrorWin.close();
};
//---------------------------------------------------------------------------
void ShowAbout()
{
	  WinObj AboutWin;
	  AboutWin.open((max_y/2)-5,max_x/2-18,(max_y/2)+4,max_x/2+18,W_DOUSIN,_BLUE|LGREY,_BLUE|LBLUE);
	  Win_hidecur();
	  AboutWin.center(1,"RA-Monitor Setup 1.21");
	  AboutWin.center(3,"Copyright 1997");
	  AboutWin.center(4,"Envy Technologies");
	  AboutWin.center(6,"All rights reserved");
	  AboutWin.allow_user_moves(FALSE);
	  Win_getkey(10);
	  AboutWin.close();
};
//---------------------------------------------------------------------------
void ShowMouse()
{
		WinMenu MouseWin;
		MouseWin.open((max_y/2)-2,max_x/2-8,(max_y/2)+2,max_x/2+7,W_DOUSIN,_BLACK|LGREEN,_BLACK|LCYAN);
		MouseWin.set_title_attr(_BLUE|YELLOW);
		MouseWin.title(" Mouse mode ",W_RIGHT);
		MouseWin.set_barattr(_LGREY|BLUE);
		MouseWin.message_line(max_y);
		MouseWin.message_attr(_BLACK|LGREY);
		MouseWin.prompt(0,0,0," Full    ","Full mouse support",'F');
		MouseWin.prompt(1,0,1," Partial ","Partial mouse support (cursor emulation)",'P');
		MouseWin.prompt(2,0,2," None    ","No mouse support",'N');
		RAMONrec.iMouseMode=MouseWin.read(RAMONrec.iMouseMode);
		MouseWin.close();
};
//---------------------------------------------------------------------------
void ShowUserDoes()
{
		WinMenu UserDoes;
		UserDoes.open((max_y/2)-2,max_x/2-7,(max_y/2)+1,max_x/2+7,W_DOUSIN,_BLACK|LGREEN,_BLACK|LCYAN);
		UserDoes.set_title_attr(_BLUE|YELLOW);
		UserDoes.title(" User does ",W_RIGHT);
		UserDoes.set_barattr(_LGREY|BLUE);
		UserDoes.message_line(max_y);
		UserDoes.message_attr(_BLACK|LGREY);
		UserDoes.prompt(0,0,1," Show info   ","Show USERDOES.n information",'S');
		UserDoes.prompt(1,0,0," Ignore info ","Ignore USERDOES.n information",'I');
		RAMONrec.iUserDoes=UserDoes.read(RAMONrec.iUserDoes);
		UserDoes.close();
};
//---------------------------------------------------------------------------
void ShowDateFmt()
{
		WinMenu DateFmt;
		DateFmt.open((max_y/2)-2,max_x/2-11,(max_y/2)+1,max_x/2+11,W_DOUSIN,_BLACK|LGREEN,_BLACK|LCYAN);
		DateFmt.set_title_attr(_BLUE|YELLOW);
		DateFmt.title(" Date format ",W_RIGHT);
		DateFmt.set_barattr(_LGREY|BLUE);
		DateFmt.message_line(max_y);
		DateFmt.message_attr(_BLACK|LGREY);
		DateFmt.prompt(0,0,0," English  (DD/MM/YY) ","English style date format (e.g. 13/10/96)",'D');
		DateFmt.prompt(1,0,1," American (MM/DD/YY) ","American style date format (e.g. 10/13/96)",'M');
		RAMONrec.iDateFmt=DateFmt.read(RAMONrec.iDateFmt);
		DateFmt.close();
};
//---------------------------------------------------------------------------
void ShowDefault()
{
	WinObj WinDefault;
	Pas2C(CONFIGrec.Sysop);
	WinDefault.open(max_y/2-4,max_x/2-30,max_y/2+4,max_x/2+30,W_DOUSIN,_BLUE|YELLOW,_BLUE|LBLUE);
	WinDefault.printf(" Welcome %s to RA-Monitor!",CONFIGrec.Sysop);
	WinDefault.printf("\n\n RA-Monitor has very few of it's own parameters.  These\n");
	WinDefault.printf(" have been set to their defaults.  RA-Monitor will utilize\n");
	WinDefault.printf(" RemoteAccess' own configuration for most settings as\n");
	WinDefault.printf(" detailed in the RA-Monitor documentation.");
	Win_getkey(0);
	WinDefault.close();
};
//---------------------------------------------------------------------------
#include "dgtasker.c"