/*-----------------------------------------------------------------------
	Title:   RA-Monitor
	Start:   26/12/95
	Comment: Monitors RemoteAccess status
	Author:  Damien Guard, Envy Technologies
	Updates: Rewritten from scratch (except some of the node retrieval routines)
	v0.8 		[X]	Add decent timeslicing (+warp/95 detection)
				[X]	Auto-adjust to up to 255 nodes
				[X]	Add function menu
				[X]	Monitoring
				[X]	Info
				[X]	About
				[X]	Send node
				[X]	Log out
				[X]	Command line parameters & help
				[X]	Window sizing, positioning, cursors etc
				[X]	Auto-adjust to 25, 28, 43 or 50 line screen.
				Fix DOS reporting on multitasking.
	v0.81		Released to Gary Smith (probs with 2.50 beta?)
	v0.82		Added "Logged on at" time to info screen. (RABUSY.n filetime)
				Added "Previous" time to info screen. (TIMELOG.BBS filetime)
				Re-organised information window.
				Prevent info window being resized.
				Released to Rob Barth - BUG report with 26 nodes :-(
	v0.83		Fix - Fixed calls > 32767.
				Fix - Total nodes > the screen.
				Fix - even number of nodes caused line missing in status list.
				Fixed info on RA node about to login.
				Page up/down keys for the node list.
				Fix - USERON.BBS file existance check.
				Released to Rob Barth & Gary Smith.
	v0.84    Got sources for LVS Windows!
				Control window now has RA-style title.
				Change all window titles.
				Passive display length detection - leaves custom fonts in tact!
				Change so only refresh when required, not after a key.
				Improved window scrolling so current node normally in middle.
				Fix "B" key from "N"
				No longer clear screen if info/error occurs in initalization
				BIOS, Monochrome and Snow-check auto-read from RemoteAccess.
				Read multitasker type / auto flag from RemoteAccess + DoubleDOS.
				Read refresh interval & node path template from config file!
				Refresh BBS & Node information screens in background!
				Screens are now independant!
				Fixed open/close window bug (don't close it ;-)
				Added close-button to windows for mouse users.
	v0.90		Added config error-level.
				*** RELEASE
	v0.91		Don't send a note if it is blank.
				Correctly display node in info window (pad with blanks)
				Close offending window when an I/O error occurs.
				Trim trailing spaces from node template
				Correct initial white-bar length
				*** Major optimisation for Borland C++ v4.5 - Now medium model
				*** recompiled LVS libraries with v4.5
				Added new copy-pascal-c conversion routines.
				Released RACDK 0.2 with RA250 structs + above copy routines.
				All new Write documentation.
				Try to read current CONFIG.RA first before RA enviorment location.
				Removed DoubleDOS timeslicing - unreliable.
				Mouse now switchable from RAMSETUP.
				Read screen lines parameter from CONFIG.RA.
	v0.92		Fixed RA path if CONFIG.RA in our path
				Added DOS generic timeslicing
	v1.00	   Release
	v1.01		Added USERDOES.n support
				Fixed mouse not correcting position for cursors
	v1.02	   Change send note support
	v1.10	   Release
	V1.20    Fixed calls > 32768
				Fix last-call date
				New auto installer thanks to RAR
	v1.21	   Fix path handling if path does/does not end in '\'
				Screen blanking facility
	Future:  Foreign language support
				Read notes
				Spoof online activity
				Semaphore job control
				Scheduled job control
				Auto-alert if a node not used for a period of time
				132 column horizontal mode
				Last callers window
				Log viewing
-----------------------------------------------------------------------*/
// Standard includes
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <io.h>
#include <dos.h>
#include <share.h>
#include <conio.h>
#include <ctype.h>
// Custom includes
#include <tasker.h>			 // My multitasking header
#include "\projects\racdk\ra250c.h"	 		 // RemoteAccess 'C' structs (Envy)
#include "ramoncfg.h"		 // Configuration file struct
#include "LVSwin.HPP"       // LVS Window class header
#include "LVSmenu.hpp"      // LVS Menu class header
//-----------------------------------------------------------------------
// Prototypes
void ShowTime(), MainLoop(), StatusMenu(), SelectScreen(), SetupScreen();
void AboutScreen(), ExitNode(), SendNote(), InfoRefresh(), BBSRefresh();
void ErrorMsg(char *), PosStatus(int y), Refresh();
void StatusMouseHandler(int y,int x);
int Initialize(), RefreshStatus(), IsNodeOnline();
char *FmtDate(int Day, int Month,int Year);
//-----------------------------------------------------------------------
// Structs & global variables
struct ts_os_ver t_os_ver[TOT_OS];

int t_os_type;				// Tasking OS type
int t_os;
int mouse_mode;			// LVS default mouse mode
int max_y;					// Maximum screen lines
int sm_oldy;				// Old node position
int iNewY;				  	// New node position
int iAutoTasker;			// Disable multitasking detection

char t_os_name[41];		// Operating system name
char sRA[81];				// RemoteAccess main directory (getenv)
char sSysPath[81];
char sUseron[81];			// useron.bbs filename & path
char sNodeTpl[81];		// Node template (RAMON.CFG)
char sSemDir[81];			// RA's semaphore path (CONFIG.RA)
char sNode[4];				// String version of current node
char sSysop[41];			// Sysop name (from CONFIG.RA)
char sTempFile[81];		// General purpose filename string

const char *status[8] = { "Browsing","Files", "Mail", "Door",
		"Sysop chat", "Questionnaire", "Conference", "New user" };

unsigned int iMaxNodes;	// Maximum nodes (calc from size of USERON.BBS)
FILE *fileptr;				// Temporary file pointer
int filehandle;			// Temporary file handle
//-----------------------------------------------------------------------
// Record structures
RAMONrecord RAMONrec;			// Configuration record (RAMON.CFG)
USERONrecord USERONrec;			// User online record (USERON.BBS)
LASTCALLrecord LASTCALLrec;	// Last callers record (LASTCALL.BBS)
//-----------------------------------------------------------------------
// LVS window objects - only refreshable's
WinObj StatusWin(3, 69); 		// RemoteAccess status window
WinObj InfoWin;					// Node information window
WinObj SysinfoWin;	 			// BBS information window
WinObj Main;						// Main screen window
//-----------------------------------------------------------------------
void main ()
{
	if (Initialize()) {
		SetupScreen();
		MainLoop();
		Win_showcur;
		Win_close_all();
	};
}
//-----------------------------------------------------------------------
int Initialize(void)
// Setup the screens, read configuration etc.
{
	CONFIGrecord CONFIGrec;	// CONFIG.RA record
	int i;

	// Setup the required filenames
	strcpy(sTempFile,"CONFIG.RA");
	strcpy(sRA,getenv("RA"));
	if (sRA[strlen(sRA)-1] != '\\') strcat(sRA, "\\");

	// Read in the RemoteAccess configuration
	if ((fileptr=_fsopen(sTempFile,"rb",SH_DENYNO)) == NULL) {
		fclose(fileptr);
		if (!strlen(sRA)) {
			puts("\nRA-Monitor error: 'RA' variable not set\n");
			return(FALSE);
		};
		strcpy(sTempFile,sRA);
		strcat(sTempFile,"CONFIG.RA");
		// Read in the RemoteAccess configuration
		if ((fileptr=_fsopen(sTempFile,"rb",SH_DENYNO)) == NULL) {
			printf("\nRA-Monitor error: Cannot read CONFIG.RA (%s)\n",sTempFile);
			fclose(fileptr);
			return(FALSE);
		};
	};

	fread(&CONFIGrec,sizeof(CONFIGrec),1,fileptr);
	fclose(fileptr);

	cpyPas2C(sSysPath,CONFIGrec.SysPath);
	if (sSysPath[strlen(sSysPath)-1] != '\\') strcat(sSysPath, "\\");
	strcpy(sUseron,sSysPath);
	cpyPas2C(sSemDir,CONFIGrec.SemPath);
	if (sSemDir[strlen(sSemDir)-1] != '\\') strcat(sSemDir, "\\");
	cpyPas2C(sSysop,CONFIGrec.Sysop);
	strcat(sUseron,"USERON.BBS");		// Create main useron file

	// Make our screens use same attributes as RemoteAccess
	if (CONFIGrec.MonoMode) Win_mono(W_ON); else Win_mono(W_OFF);
	if (CONFIGrec.DirectWrite) Win_bios(W_OFF); else Win_bios(W_ON);
	if (CONFIGrec.SnowCheck) Win_snow(W_ON); else Win_snow(W_OFF);

	if (access(sUseron,4)) {
		printf("\nRA-Monitor error: Cannot read USERON.BBS (%s)\n",sUseron);
		fclose(fileptr);
		return(FALSE);
	};

	// Load config file, if none then use defaults
	strcpy(sTempFile,"RAMON.CFG");
	if ((fileptr=_fsopen(sTempFile,"rb",SH_DENYNO)) == NULL) {
		strcpy(RAMONrec.sRA_Nodes,"\\NODE*N");
		RAMONrec.iRefresh=2;
		RAMONrec.iExitLevel=0;
		RAMONrec.iMouseMode=0;
		RAMONrec.iUserDoes=0;
		RAMONrec.iDateFmt=0;
	} else {
		fread(&RAMONrec,sizeof(RAMONrec),1,fileptr);
		fclose(fileptr);
	};

	// Setup node template string
	strtrim(RAMONrec.sRA_Nodes);
	memcpy(strstr(RAMONrec.sRA_Nodes,"*N"),"%d",2);

	// Get the number of nodes
	filehandle = sopen(sUseron, O_RDONLY, SH_DENYNO, S_IREAD);
	iMaxNodes=filelength(filehandle)/214;
	close(filehandle);

	// Set mouse mode
	switch (RAMONrec.iMouseMode) {
		case 1 : Win_mouse_mode(M_SIMPLE); break;
		case 2 : break;
		default: Win_mouse_mode(M_FULL); break;
	};

	// Set miscellaneous system stuff
	Win_setrows(peekb(0x40,0x84)+1); 	// Resize to video mode
	Win_setbkloop(ShowTime);            // Start the clock & refresh running
	Win_hidecur();							   // Get rid of the cursor
	max_y = Win_Max_y ();					// Get the max y coordinate
	if (!iAutoTasker) {
		if (!CONFIGrec.MultiTasker) get_os();
		else switch (CONFIGrec.MultiTasker) {
				case 1: t_os = DOS; break;				// No multitasking
				case 3: t_os = DV; break;				// DESQview
				case 7: t_os = WINS; break;			// Windows 3.x / 95
				case 8: t_os = OS2; break;				// IBM OS/2 / Warp
				}
		};

	 Win_setonkey(F5,&Refresh);		// F5 = Refresh screen
	 return(TRUE);
};
//-----------------------------------------------------------------------
void ShowTime ()
//	Background process to update clock & check for pending
// window updates/refresh.
{
	static WinObj clock_win;
	static struct Win_time_s t;
	static unsigned char hold;
	static iTimeCount;

	if (!clock_win.is_open()) {	// First call setup the screen title & clock
		clock_win.open(0,0,1,79,W_NOBORDER,_BLACK|BLUE);
		clock_win.puts(1,0,"ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ");
		clock_win.set_attr(_BLACK|YELLOW);
		clock_win.puts(0,1,"RemoteAccess MONITOR 1.21");
	};

	Win_gettime(&t);
	if (hold!=t.sec) {	// Only update the clock every second
		hold=t.sec;
		iTimeCount++;
		clock_win.printf(0,71,"%02d:%02d:%02d",t.hour,t.min,t.sec);
	};

	if (iTimeCount==RAMONrec.iRefresh) { // Update the windows every refresh
		Refresh();
		iTimeCount=0;
	};

	if (!iAutoTasker) t_slice();
}
//-----------------------------------------------------------------------
void Refresh()
// Call the refresh routines for any windows visible
{
	RefreshStatus();
	if (!InfoWin.is_hidden()) 		InfoRefresh();
	if (!SysinfoWin.is_hidden())	BBSRefresh();
}
//-----------------------------------------------------------------------
void SetupScreen()
// Setup the various screens
{
	// Build main display window
	Main.open(0,0,max_y,79,W_NOBORDER,_BLACK|LGREY);
	Main.gotoxy(2,0);
	int ilMax = (max_y - 3) * 4;
	for (int l=0; l < ilMax; l++)
		Main.puts("±±±±±±±±±±±±±±±±±±±±");
	Main.set_attr(_BLACK|BLUE);
	Main.puts(max_y-1,0,"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ");

	// Build system info window
	SysinfoWin.open((max_y/2)-3,18,(max_y/2)+2,62,W_DOUSIN,_BLACK|LGREEN,_BLACK|LCYAN);
	SysinfoWin.hide();
	SysinfoWin.set_title_attr(_BLUE|YELLOW);
	SysinfoWin.title(" BBS information ",W_RIGHT);
	SysinfoWin.set_attr(_BLACK|LGREY);
	SysinfoWin.set_close(TRUE);
	SysinfoWin.puts(0,1,"Total nodes : ");
	SysinfoWin.puts(1,1,"Total calls : ");
	SysinfoWin.puts(2,1,"Calls today : ");
	SysinfoWin.puts(3,1,"Last caller : ");
	SysinfoWin.shadow(TRUE);

	// Build node information window
	if (RAMONrec.iUserDoes == 1)
		InfoWin.open((max_y/2)-7,12,(max_y/2)+7,68,W_DOUSIN,_BLACK|LGREEN,_BLACK|LCYAN);
	 else
		InfoWin.open((max_y/2)-6,12,(max_y/2)+6,68,W_DOUSIN,_BLACK|LGREEN,_BLACK|LCYAN);
	InfoWin.hide();
	InfoWin.set_title_attr(_BLUE|YELLOW);
	InfoWin.title(" Node information ",W_RIGHT);
	InfoWin.set_attr(_BLACK|LGREY);
	InfoWin.set_close(TRUE);
	InfoWin.puts(0,1, "Node number  :");
	InfoWin.puts(1,1, "User name    :");
	InfoWin.puts(2,1, "User handle  :");
	InfoWin.puts(3,1, "User location:");
	InfoWin.puts(4,1, "Connect BPS  :");
	InfoWin.puts(5,1, "User call    :");
	InfoWin.puts(6,1, "Currently    :");
	InfoWin.puts(6,32,"Hidden user  :");
	InfoWin.puts(7,1, "Paged sysop  :");
	InfoWin.puts(7,32,"No disturb   :");
	InfoWin.puts(8,1, "Exit pending :");
	InfoWin.puts(8,32,"Note pending :");
	InfoWin.puts(9,1, "Logged in at :");
	InfoWin.puts(10,1,"Previous call:");
	if (RAMONrec.iUserDoes ==1) InfoWin.puts(11,1,"User does    :");
	InfoWin.shadow(TRUE);
}
//---------------------------------------------------------------------------
int iWindowSize;
int iHalf;
void MainLoop(void)
{
	  int iOffset;
	  iWindowSize=iMaxNodes+2;
	  if (iWindowSize > max_y - 3) iWindowSize = max_y - 5;
	  iHalf=(iWindowSize/2);
	  iOffset=(iWindowSize % 2);
	  // Builds the reset of the main window
	  Win_shadow_by_default(TRUE);
	  StatusWin.set_virtual(iMaxNodes+1,69);
	  StatusWin.open((max_y/2)-iHalf-iOffset,3,(max_y/2)+iHalf,75,W_DOUSIN,_BLACK|CYAN,_BLACK|LCYAN);
	  StatusWin.hide();
	  StatusWin.set_title_attr(_BLUE|YELLOW);
	  StatusWin.title(" Status ",W_RIGHT);
	  StatusWin.set_attr(_LGREY|RED);
	  StatusWin.printf(0,1,"Node  User                  BPS    Location            Status        ");
	  StatusWin.set_attr(_BLACK|CYAN);
	  StatusWin.set_mouseroutine(StatusMouseHandler);
	  StatusWin.unhide();
	  RefreshStatus();		// Update the main window
	  StatusMenu();			// Put up the normal menu & selection processing
}
//---------------------------------------------------------------------------
WinMenu StatusMen;
int iChoice;
void StatusMenu(void)
// Main selection window
{
	  iChoice = 0;
	  StatusMen.open(9,10,17,22,W_DOUSIN,_BLACK|CYAN,_BLACK|LCYAN);
	  StatusMen.hide();
	  StatusMen.set_title_attr(_BLUE|YELLOW);
	  StatusMen.title(" Control ",W_RIGHT);
	  StatusMen.set_barattr(_LGREY|BLUE);
	  StatusMen.message_line(max_y);
	  StatusMen.message_attr(_BLACK|LGREY);
	  StatusMen.prompt(0,0,0," Select    ","Select a node",'M');
	  StatusMen.prompt(1,0,1," Node info ","Information on this node",'I');
	  StatusMen.prompt(2,0,2," Send note ","Send this node a note",'S');
	  StatusMen.prompt(3,0,3," Log off   ","Log user off this node",'L');
	  StatusMen.prompt(4,0,4," BBS info  ","General BBS information",'B');
	  StatusMen.prompt(5,0,6," About     ","About RA-Monitor",'A');
	  StatusMen.prompt(6,0,7," Quit      ","Exit to DOS",'Q');

	  SelectScreen();
	  while (iChoice!=7) {  // Stop if QUIT selected
		 StatusMen.unhide();
		 Win_hidecur();
		 iChoice = StatusMen.read(iChoice);
		 itoa(sm_oldy,sNode,10);
		 switch (iChoice) {
			case 0: StatusMen.hide(); SelectScreen(); break;
			case 1: if (InfoWin.is_hidden()) { InfoWin.unhide(); InfoRefresh(); }
							else InfoWin.hide(); break;
			case 2: SendNote(); break;
			case 3: ExitNode(); break;
			case 4: if (SysinfoWin.is_hidden()) { SysinfoWin.unhide(); BBSRefresh(); }
							else SysinfoWin.hide(); break;
			case 6: AboutScreen(); break;
		};  // end-switch
	}; // end-while
}
//---------------------------------------------------------------------------
void SelectScreen(void)
{
		int iCurKey = 0;
		int iUpdate;
		iNewY = sm_oldy;
		while ((iCurKey!=1) & (iCurKey!=57) & (iCurKey!=28)) {
			if ((iCurKey==72) & (iNewY > 0)) iNewY--;				// Cursor-up
			if ((iCurKey==80) & (iNewY < iMaxNodes)) iNewY++;	// Cursor-down
			if (iCurKey==71) iNewY=1;									// Home
			if (iCurKey==79) iNewY=iMaxNodes;						// End
			if (iCurKey==73) { 											// Page-up
				if (iNewY > iWindowSize) {
					iNewY=iNewY-iWindowSize+1;
				} else {
					iNewY=1;
				}
			};
			if (iCurKey==81) { 											// Page-down
				if ((iNewY < iMaxNodes-iWindowSize+1) && (iMaxNodes > iWindowSize)) {
					iNewY=iNewY+iWindowSize-1;
				 } else {
					iNewY=iMaxNodes;
				}
			};
	 itoa(iNewY,sNode,1);	// Node for display purposes
	 if (iCurKey==23) {													// "I" Info window
		 if (InfoWin.is_hidden()) {
			  InfoWin.unhide();
			  InfoRefresh();
		  } else InfoWin.hide();
		 };
	 if (iCurKey==38) ExitNode(); 									// "L" Log off
	 if (iCurKey==30) AboutScreen();  								// "A" About window
	 if (iCurKey==16) { iChoice=5; return; }; 					// "Q" Quit
	 if (iCurKey==48) {
		 if (SysinfoWin.is_hidden()) {
			 SysinfoWin.unhide();
			 BBSRefresh();
			 }	else SysinfoWin.hide();
		 };
	 if (iCurKey==31) SendNote(); 									// "S" Send note
	 if ((iCurKey>1) && (iCurKey<12) && (iCurKey<iMaxNodes+2))
			iNewY=iCurKey-1;												// 1-10 jump to
	 if (iNewY!=sm_oldy) {	// When moved, update status bar, scroll screen
		 if (sm_oldy)
			 {
				StatusWin.set_attr(_BLACK|CYAN,sm_oldy,1,69);
				Main.gotoxy(max_y,0);
				Main.clr_eol();
			  }
			 else StatusWin.set_attr(_BLACK|LRED,sm_oldy,1,69);
		 StatusMouseHandler(iNewY,0);
	 };
	 Win_hidecur();
	 iCurKey=Win_getkey(0)>>8;
	 }; // end-while
}
//---------------------------------------------------------------------------
void PosStatus(int y)
// Position/scroll the window
{
	  StatusWin.gotoxy(y,0);
	  if (y>iHalf) StatusWin.set_pan(y-iHalf,0);
			else StatusWin.set_pan(0,0);
}
//---------------------------------------------------------------------------
int IsNodeOnline(int iNodeOn)
// Check to see if node is online
{
	  USERONrecord USERONrec;	  // User online record

	  if (iNodeOn == 0) return(FALSE);    // make sure don't crash machine :-D
	  if ((fileptr=_fsopen(sUseron,"rb",SH_DENYNO)) == NULL) {
			fclose(fileptr);
			if (ferror(fileptr)) clearerr(fileptr);
			return(FALSE);
		};

	  // Read user online record
	  fseek(fileptr,(iNodeOn-1)*sizeof(USERONrec),SEEK_SET);
	  fread(&USERONrec,sizeof(USERONrec),1,fileptr);
	  fclose(fileptr);

	  if ((USERONrec.Line == 0) || (USERONrec.Name[0] == '\0')){
			fclose(fileptr);
			ErrorMsg(" Node not in use");
			return(FALSE);
		};
	  return(TRUE);
}
//---------------------------------------------------------------------------
void SendNote()
// Send a node a note
{
		WinObj SendNoteWin;
		char sNote[71];		// Actual note to send
		int iKey;
		char sBuffer[161];	// File buffer for output

		memset(sNote, ' ', sizeof(sNote) - 1);
		sNote[71]='\0';
		if (!IsNodeOnline(sm_oldy)) return;
		SendNoteWin.open((max_y/2)-2,3,(max_y/2)+1,76,W_DOUSIN,_BLACK|LGREEN,_BLACK|LCYAN);
		SendNoteWin.set_title_attr(_BLUE|YELLOW);
		SendNoteWin.title(" Send note ",W_RIGHT);
		SendNoteWin.printf(0,25,"Type note to node %u",sm_oldy);
		SendNoteWin.set_getattr(_GREEN|BLUE);
		SendNoteWin.get(1,1,sNote,ANY_STYLE,70);
		iKey=SendNoteWin.read()>>8;
		strtrim(sNote);
		if ((iKey!=28) || (strlen(sNote)==0)) return;
		itoa(sm_oldy,sNode,10);
		strcpy(sTempFile,sSemDir);

		strcat(sTempFile,"NODE");
		strcat(sTempFile,sNode);
		strcat(sTempFile,".RA");
		fileptr=fopen(sTempFile, "wb");
		strcpy(sBuffer,"\n\r\x0b]497 ");
		strcat(sBuffer,sSysop);
		strcat(sBuffer," (RA-Monitor)\n\r");
		strcat(sBuffer,sNote);
		strcat(sBuffer,"\n\r\n\r\x0b]258\x01");
		fwrite(&sBuffer,strlen(sBuffer),1,fileptr);
		fclose(fileptr);
		SendNoteWin.close();
		Main.set_attr(_BLACK|LGREEN);
		Main.printf(max_y,0," Note sent to node %d",sm_oldy);
		Win_hidecur();
		Win_getkey(1);
		Main.gotoxy(max_y,0);
		Main.clr_eol();
}
//---------------------------------------------------------------------------
void InfoRefresh()
{
	  char sStatus[21];		  // User status
	  char sTempL[4];
	  char sText[81];
	  struct ftime ftBusy;

	  if (sm_oldy == 0) return;
	  if ((fileptr=_fsopen(sUseron,"rb",SH_DENYNO)) == NULL) {
			fclose(fileptr);
			if (ferror(fileptr)) clearerr(fileptr);
			InfoWin.hide();
			ErrorMsg(" Error opening USERON.BBS");
			return;
		};

		// Read node information
	  fseek(fileptr,(sm_oldy-1)*sizeof(USERONrec),SEEK_SET);
	  fread(&USERONrec,sizeof(USERONrec),1,fileptr);
	  fclose(fileptr);

	  if ((USERONrec.Line == 0) || (USERONrec.Name[0] == '\0')) {
			strcpy(USERONrec.Name,"--- Offline ---");
			USERONrec.Handle[0]='\0';
			USERONrec.City[0]='\0';
			strcpy(sStatus,"Offline");
			USERONrec.Baud=0;
			USERONrec.NoCalls=0;
			USERONrec.Attribute=0;
		 } else {
			Pas2C(USERONrec.Name);
			Pas2C(USERONrec.Handle);
			Pas2C(USERONrec.City);
			if (USERONrec.Status == 255)
				cpyPas2C(sStatus,USERONrec.StatDesc)
			 else
				strcpy(sStatus,status[USERONrec.Status]);
	  };

	  InfoWin.printf(0,16,"%d   ",sm_oldy);
	  InfoWin.printf(1,16,"%-30s",USERONrec.Name);
	  InfoWin.printf(2,16,"%-30s",USERONrec.Handle);
	  InfoWin.printf(3,16,"%-27s",USERONrec.City);
	  InfoWin.printf(4,16,"%-6u",USERONrec.Baud);
	  InfoWin.printf(5,16,"%-5u",USERONrec.NoCalls);
	  InfoWin.printf(6,16,"%-13s",sStatus);

	  if (USERONrec.Attribute & 1) InfoWin.puts(6,47,"Yes");
				  else InfoWin.puts(6,47,"No ");
	  if (USERONrec.Attribute & 2) InfoWin.puts(7,16,"Yes");
				  else InfoWin.puts(7,16,"No ");
	  if (USERONrec.Attribute & 4) InfoWin.puts(7,47,"Yes");
				  else InfoWin.puts(7,47,"No ");

	  // Exit pending
	  strcpy(sTempFile,sSemDir);
	  strcat(sTempFile,"RAXIT");
	  strcat(sTempFile,sNode);
	  itoa(RAMONrec.iExitLevel,sTempL,10);
	  strcat(sTempFile,".");
	  strcat(sTempFile,sTempL);
	  if (access(sTempFile,0)) InfoWin.puts(8,16,"No ");
			 else InfoWin.puts(8,16,"Yes");

	  // Note pending
	  strcpy(sTempFile,sSemDir);
	  strcat(sTempFile,"NODE");
	  strcat(sTempFile,sNode);
	  strcat(sTempFile,".RA");
	  if (access(sTempFile,0)) InfoWin.puts(8,47,"No ");
			 else InfoWin.puts(8,47,"Yes");

	  // Login time
	  strcpy(sTempFile,sSemDir);
	  strcat(sTempFile,"RABUSY.");
	  itoa(iNewY,sNode,10);
	  strcat(sTempFile,sNode);
	  if ((fileptr=_fsopen(sTempFile,"rb",SH_DENYNO)) == NULL) {
			InfoWin.puts(9,16,"Not available   ");
	  } else {
			getftime(fileno(fileptr), &ftBusy);
			InfoWin.printf(9,16,"%d:%02d (%s)  ",ftBusy.ft_hour,ftBusy.ft_min,
			FmtDate(ftBusy.ft_day,ftBusy.ft_month,ftBusy.ft_year+80));
	  };
	  fclose(fileptr);

	  // Previous logout
	  strcpy(sTempFile,sSysPath);
	  sprintf(sNodeTpl,RAMONrec.sRA_Nodes,iNewY);
	  strcat(sTempFile,sNodeTpl);
	  strcat(sTempFile,"TIMELOG.BBS");
	  if ((fileptr=_fsopen(sTempFile,"rb",SH_DENYNO)) == NULL) {
			InfoWin.puts(10,16,"Not available   ");
	  } else {
			getftime(fileno(fileptr), &ftBusy);
			InfoWin.printf(10,16,"%d:%02d (%s)  ",ftBusy.ft_hour,ftBusy.ft_min,
				FmtDate(ftBusy.ft_day,ftBusy.ft_month,ftBusy.ft_year+80));
	  };
	  fclose(fileptr);

	  if (RAMONrec.iUserDoes == 1) {
		  strcpy(sTempFile,sSemDir);
		  strcat(sTempFile,"USERDOES.");
		  strcat(sTempFile,sNode);
		  for(register i=0;i<81;i++) sText[i] = ' ';
		  if ((fileptr=_fsopen(sTempFile,"r",SH_DENYNO)) != NULL) {
			  fread(&sText,80,1,fileptr);
			  fclose(fileptr);
			 };
			sText[81] = '\0';
			for(i=0;i<81;i++) if (sText[i] >0 & sText[i] < 31) sText[i] = ' ';
			InfoWin.printf(11,16,sText);
	  };
}
//---------------------------------------------------------------------------
unsigned int iCallsToday;
void BBSRefresh()
// BBS Statistics/information
{
	SYSINFOrecord SYSINFOrec;
	strcpy(sTempFile,sRA);
	strcat(sTempFile,"SYSINFO.BBS");

	if ((fileptr=_fsopen(sTempFile,"rb",SH_DENYNO)) == NULL) {
		fclose(fileptr);
		if (ferror(fileptr)) clearerr(fileptr);
		Main.set_attr(_BLACK|LRED);
		SysinfoWin.hide();
		ErrorMsg(" Error opening SYSINFO.BBS");
		return;
	};

	fread(&SYSINFOrec,sizeof(SYSINFOrec),1,fileptr);
	fclose(fileptr);
	Pas2C(SYSINFOrec.LastCaller);
	SYSINFOrec.LastCaller[26]='\0';

	strcpy(sTempFile,sRA);
	strcat(sTempFile,"LASTCALL.BBS");
	filehandle = sopen(sTempFile, O_RDONLY, SH_DENYNO, S_IREAD);
	if (!filehandle) {
		close(filehandle);
		SysinfoWin.hide();
		ErrorMsg(" Error opening LASTCALL.BBS");
		return;
	};
	iCallsToday=filelength(filehandle)/118;
	close(filehandle);

	SysinfoWin.printf(0,15,"%d",iMaxNodes);
	SysinfoWin.printf(1,15,"%u",SYSINFOrec.TotalCalls);
	SysinfoWin.printf(2,15,"%u",iCallsToday);
	SysinfoWin.printf(3,15,"%s",SYSINFOrec.LastCaller);
}
//---------------------------------------------------------------------------
int RefreshStatus(void)
{
	int iX,iY;
	unsigned int iNode;				// Node we are expecting
	unsigned char sLine[4];			// Node to display
	unsigned char sStatus[16];		// Node status information
	unsigned char sBPS[7];			// Node BPS
	unsigned char sLocation[41]; 	// Node location
	unsigned char sName[41];	  	// Node user name

	if ((fileptr=_fsopen(sUseron,"rb",SH_DENYNO)) == NULL) {
		fclose(fileptr);
		if (ferror(fileptr)) clearerr(fileptr);
		exit(1);
	};

	StatusWin.get_pan(iY,iX);

	 // Process the node information
	for (iNode=1;iNode<iMaxNodes+1;iNode++) {
		fseek(fileptr,(iNode-1)*sizeof(USERONrec),SEEK_SET);
		fread(&USERONrec,sizeof(USERONrec),1,fileptr);
		if (iNode==sm_oldy) {
			StatusWin.set_attr(_LGREY|BLUE);
		} else {
			StatusWin.set_attr(_BLACK|CYAN);
		};
		itoa(iNode,sLine,10);
		if (USERONrec.Line == iNode) {
			if (USERONrec.Name[0] == '\0') {
				strcpy(sName,"RemoteAccess");
				strcpy(sBPS,"0");
				// Logging in
				strcpy(sTempFile,sSemDir);
				strcat(sTempFile,"rabusy.");
				strcat(sTempFile,sLine);
				if (!access(sTempFile,0)) {
					strcpy(sName,"[Unknown]");
					strcpy(sStatus,"Logging in");
				};
				// RA waiting
				strcpy(sTempFile,sSemDir);
				strcat(sTempFile,"raready.");
				strcat(sTempFile,sLine);
				if (!access(sTempFile,0)) {
					strcpy(sName,"[Available]");
					strcpy(sStatus,"Ready");
				};
			} else {
				cpyPas2C(sName,USERONrec.Name);
				cpyPas2C(sLocation,USERONrec.City);
				sLocation[19]='\0';
				itoa(USERONrec.Baud,sBPS,10);
				if (USERONrec.Status == 255) {
					cpyPas2C(sStatus,USERONrec.StatDesc);
				} else {
					strcpy(sStatus,status[USERONrec.Status]);
				};
			}; // end of offline else
			StatusWin.printf(iNode,1," %3s  %-21s %5s  %-19s %-13s",sLine,sName,sBPS,sLocation,sStatus);
		} else StatusWin.printf(iNode,1," %3s   --- Offline ---                                               ",sLine);
	}; // end do loop
	fclose(fileptr);
	StatusWin.set_pan(iY,iX);
	return(0);
}
//-----------------------------------------------------------------------
void AboutScreen(void)
{
	WinObj AboutWin;		// About RA-Monitor window
	AboutWin.open((max_y/2)-5,22,(max_y/2)+4,58,W_DOUSIN,_BLUE|LGREY,_BLUE|LBLUE);
	AboutWin.center(1,"RemoteAccess Monitor 1.21");
	AboutWin.center(3,"Copyright 1997");
	AboutWin.center(4,"Envy Technologies");
	AboutWin.center(6,"All rights reserved");
	AboutWin.allow_user_moves(FALSE);
	Win_hidecur();
	Win_getkey(10);
}
//---------------------------------------------------------------------------
void StatusMouseHandler(int y, int x)
{
	if (y>iMaxNodes) y=sm_oldy;
	if (sm_oldy) StatusWin.set_attr(_BLACK|CYAN,sm_oldy,1,69);
		else StatusWin.set_attr(_BLACK|LRED,sm_oldy,1,69);
	if (y) StatusWin.set_attr(_LGREY|BLUE,y,1,69);
		else StatusWin.set_attr(_LGREY|RED,y,1,69);
	sm_oldy=y;
	iNewY=y;
	x=x;
}
//-----------------------------------------------------------------------
void ErrorMsg(char *Message)
{
	Main.set_attr(_BLACK|LRED);
	Main.puts(max_y,0,Message);
	Win_getkey(1);
	Main.gotoxy(max_y,0);
	Main.clr_eol();
}
//-----------------------------------------------------------------------
char *FmtDate(int Day, int Month,int Year)
{
	char *Buffer;
	Buffer=(char *) malloc(10);
	if (RAMONrec.iDateFmt == 0)
		sprintf(Buffer,"%2d/%2d/%2d",Day,Month,Year);
	 else
		sprintf(Buffer,"%2d/%2d/%2d",Month,Day,Year);
	return Buffer;
}
//-----------------------------------------------------------------------
void ExitNode(void)
{
	WinObj ConfirmWin;
	unsigned char sTempL[4];

	if (!IsNodeOnline(sm_oldy)) return;
	ConfirmWin.open((max_y/2)-2,26,(max_y/2)+2,53,W_DOUSIN,_BLUE|LGREY,_BLUE|LBLUE);
	ConfirmWin.printf(1,1,"Log-off node %d (y,N) ? °",sm_oldy);
	Win_hidecur();
	itoa(sm_oldy,sNode,10);
	if (Win_getkey(10)>>8==21) {  // Press Y to confirm
		strcpy(sTempFile,sSemDir);
		strcat(sTempFile,"RAXIT");
		strcat(sTempFile,sNode);
		itoa(RAMONrec.iExitLevel,sTempL,10);
		strcat(sTempFile,".");
		strcat(sTempFile,sTempL);
		fileptr=fopen(sTempFile,"w");
		fclose(fileptr);
		ConfirmWin.close();
		Main.set_attr(_BLACK|LGREEN);
		Main.printf(max_y,0," Exit command sent to node %d",sm_oldy);
		Win_getkey(1);
		Main.gotoxy(max_y,0);
		Main.clr_eol();
	};
}
//-----------------------------------------------------------------------
#include "dgtasker.c"		// My own timeslicing routines
