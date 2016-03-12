/* File:	RA250.H 	'C' structures for RemoteAccess 2.50 Gamma
	Version:		0.3	(22/04/96)
	Author:		Damien Guard
	Copyright:  Envy Technologies, 1996.
	Changes:		0.1 - Initial release
					0.2 - Fixed some compile problems
							Sorted enumeration types
					0.3 - Added some examples
							All new documentation (+Write format)
							CRC routines
	Notes:		These are neither official structures nor authorised by
					Wantree Development.
					Always make sure "Allocate enums as int's" is OFF!
					  They should be allocated as CHAR.
					This document formatted with tab's as three(3) characters
	WARNING:		These structures have not been fully tested.
					I have only tested CONFIG.RA (CONFIGrecord) extensively.
	Info:			Please e-mail suggestions to : envy@guernsey.net
					Latest version available at  : http://www.guernsey.net/~envy

	If you use this structure in your software please include something like
	'This product uses the RA 'C' Developer Kit from Envy Technologies' -
	it's not much to ask and using any part of the RACDK in your software
	is free (in compiled form - see RACDK.DOC for more information)
*/

/* C <> Pascal string conversion macros from SNIPPETS 'C' library
	C <> Pascal string copy macros by Damien Guard

 Convert a string:
	Pas2C(string) to convert string from Pascal to C (ie. after READING)
	C2Pas(string) to convert string to Pascal from C (ie. before WRITING)

 Copy a string:
	cpyPas2C(destination,source) to copy from a Pascal string to a C string
	cpyC2Pas(destination,source) to copy from a C string to a Pascal string */

typedef unsigned char UCHAR;
#define Pas2C(s) {UCHAR n = *(s); memmove((s), &(s)[1], n); s[n] = '\0';}
#define C2Pas(s) {int n = strlen(s); memmove(&(s)[1], (s), n); *(s) = n;}
#define cpyPas2C(d,s) {UCHAR n = *(s); memmove((d), &(s)[1], n); d[n] = '\0';}
#define cpyC2Pas(d,s) {int n = strlen(s); memmove(&(d)[1], (s), n); *(d) = n;}

/* Fake Pascal boolean type for clarity */
typedef unsigned char booleanf;

/* enums here for clarity - not sure if they work */
enum AskType {Yes, No, Ask, Only};
enum VideoType {Auto, Short, Long};
enum MsgType {LocalMail, NetMail, EchoMail, Internet, Newsgroup};
enum MsgKindsType {Both, Private, Public, ROnly, NoReply};
enum OrphanType {Ignore, Create, Kill };
enum ResetType {Never, Week, Month, Year};

/* Typedef the RemoteAccess 'types' */
typedef unsigned char FlagType[4];
typedef unsigned char TimeF[6];				/* Time format				*/
typedef unsigned char DateF[9];				/* Date format				*/
typedef unsigned char LongDate[10];			/* Long date format		*/
typedef unsigned char ByteArray32[32];
typedef unsigned char MSGTOIDXrecord[36];
typedef unsigned char MSGTXTrecord[256];
typedef unsigned int  LASTREADrecord[200];
typedef unsigned int  COMBINEDrecord[200];

/* Mail network address (internal) */
struct NetAddress {
    unsigned int   Zone,
             Net,
             Node,
             Point;
};

/* Security limits (LIMITS.RA) */
struct LIMITSrecord {
    unsigned int   Security,
             Ltime,
             L300,
             L1200,
             L2400,
             L4800,
             L7200,
             L9600,
             L12000,
             L14400,
             L16800,
             L19200,
             L38400,
             Llocal,
             RatioNum,
             RatioK;
    float	       PerMinCost;
    unsigned int   L21600,
             L24000,
             L26400,
             L28800,
             L57600,
             L64000;
    float	       FlexiTime;
    unsigned int   LsessionTime,
             ResetAmt;
    enum ResetType      ResetPeriod;
    unsigned int   ResetOffset,
             L31200,
             L33600;
    unsigned char  FreeSpace[14];
};

/* Languages (LANGUAGE.RA) */
struct LANGUAGErecord {
    unsigned char  Name[21],
             Attribute,
             DefName[61],
             MenuPath[61],
             TextPath[61],
             QuesPath[61];
    unsigned int   Security;
    FlagType	    Flags,
                    NotFlagsMask;
    unsigned char  FreeSpace[191];
};

/* Hudson message information (MSGINFO.BBS) */
struct MSGINFOrecord {
    unsigned int   LowMsg,
             HighMsg,
             TotalMsgs;
    unsigned char  TotalOnBoard[200];
};

/* Hudson message index (MSGIDX.BBS) */
struct HMBMSGIDXrecord {
    unsigned int   MsgNum;
    unsigned char  Board;
};

/* Hudson message headers (MSGHDR.BBS) */
struct HMBMSGHDRrecord {
    unsigned int   MsgNum,
             PrevReply,
             NextReply,
             TimesRead,
             StartBlock,
             NumBlocks,
             DestNet,
             DestNode,
             OrigNet,
             OrigNode,
             DestZone;
    unsigned char  OrigZone;
    unsigned int   Cost;
    unsigned char  MsgAttr,
             NetAttr,
             Board;
    TimeF	       PostTime;
    DateF	       PostDate;
    MSGTOIDXrecord WhoTo,
                   WhoFrom;
    unsigned char  Subject[73];
};

/* Current online status (USERON.BBS) */
struct USERONrecord {
    MSGTOIDXrecord Name,
                   Handle;
    unsigned char  Line;
    unsigned int   Baud;
    unsigned char  City[26],
             Status,
             /* 0 : Browsing/menu
             	1 : File transfer
             	2 : Messaging
             	3 : Door
             	4 : Sysop chat
             	5 : Questionnaire
             	6 : Real-time-conferencing
             	7 : New user logon
              255 : User-defined - display StatDesc */
             Attribute,
             /* Bit 0 : Hidden
             		 1 : Wants chat
             		 2 : Reserved for RANETMGR (RA/Pro)
             		 3 : Do not disturb flag
             		 6 : Ready */
             StatDesc[11],
             FreeSpace[98];
    unsigned int   NoCalls;
};

/* Todays callers list (LASTCALL.BBS) */
struct LASTCALLrecord {
    unsigned char  Line;
    MSGTOIDXrecord Name,
                   Handle;
    unsigned char  City[26];
    unsigned int   Baud;
    long           Times;
    unsigned char  LogOn[6],
             LogOff[6];
    unsigned char  Attribute;
    /* Bit 0 : Hidden */
};

/* File area header (FDBxxx.HDR) */
struct FILESHDRrecord {
    unsigned char  Name[13];
    long	       	 Size,
                     CRC32;
    unsigned char  Uploader[36];
    long	       	 UploadDate,
                     FileDate,
                     LastDL;
    unsigned int   TimesDL;
    unsigned char  Attrib,
             /* Bit 0 : Deleted
             		 1 : Unlisted
             		 2 : Free - Does NOT affect "Cost"
             		 3 : Not available (don't allow downloads)
             		 4 : Locked (no kill)
             		 5 : Missing/offline
             		 6 : No time restrictions - always allow DL */
             Password[16],
             KeyWord [5] [16];
    unsigned int   Cost;
    long		       LongDescPtr;
    unsigned char  FreeSpace[20];
};

/* File area index (FDBxxx.IDX) */
struct FILESIDXrecord {
    unsigned char	 Name[13];
    long	      	 UploadDate,
                     KeyWordCRC[5],
                     LongDescPtr;
};

/* User base index (USERSIDX.BBS) */
struct USERSIDXrecord {
    long           NameCRC32,
                   HandleCRC32;
};

/* User base (USERS.BBS) */
struct USERSrecord {
    MSGTOIDXrecord Name;
    unsigned char  Location[26],
             Organisation[51],
             Address1[51],
             Address2[51],
             Address3[51],
             Handle[36],
             Comment[81];
    long	       	 PasswordCRC;
    unsigned char  DataPhone[16],
             VoicePhone[16];
    TimeF	       LastTime;
    DateF	       LastDate;
    unsigned char  Attribute,
             /* Bit 0 : Flagged for delete
             		 1 : Clear screen
             		 2 : More? prompt
             		 3 : ANSI emulation
             		 4 : No-kill
             		 5 : Xfer priority
             		 6 : Full screen msg editor
             		 7 : Quiet mode */
             Attribute2;
    /* Bit 0 : Hot-keys
    		 1 : AVT/0 (Avatar)
    		 2 : Full screen message viewer
    		 3 : Hidden
    		 4 : Page priority
    		 5 : No echomail in mailbox scan
    		 6 : Guest account
    		 7 : Post bill enabled */
    FlagType       Flags;
    long		       Credit,
                       Pending;
    unsigned int   MsgsPosted,
             Security;
    long			    LastRead,
                        NoCalls,
                        Uploads,
                        Downloads,
                        UploadsK,
                        DownloadsK,
                        TodayK;
    int 		       Elapsed;
    unsigned int   ScreenLength;
    unsigned char  LastPwdChange;
    unsigned int   Group;
    COMBINEDrecord CombinedInfo;
    DateF	       FirstDate,
                   BirthDate,
                   SubDate;
    unsigned char  ScreenWidth,
             Language,
             DateFormat,
             ForwardTo[36];
    unsigned int   MsgArea,
             FileArea;
    unsigned char  DefaultProtocol;
    unsigned int   FileGroup;
    unsigned char  LastDOBCheck,
             Sex;
    long		       XIrecord;
    unsigned int   MsgGroup;
    unsigned char  Attribute3,
             /* Bit 0 : Mailbox check: scan selected areas only */
             Password[16],
             FreeSpace[31];
};

/* User base index (USERSXI.BBS) */
struct USERSXIrecord {
    unsigned char  FreeSpace[200];
};

/* System information (SYSINFO.BBS) */
struct SYSINFOrecord {
    long           TotalCalls;
    MSGTOIDXrecord LastCaller,
                   LastHandle;
    unsigned char  ExtraSpace[92];
};

/* Timelog stat (TIMELOG.BBS) for EACH node */
struct TIMELOGrecord {
    DateF	       StartDate;
    unsigned int   BusyPerHour[24],
             BusyPerDay[7];    /* not implemented */
};

/* Menu (*.MNU) */
struct MNUrecord {
    unsigned char  Typ;
    unsigned int   Security,
             MaxSec;
    FlagType	    NotFlagsMask,
                    Flags;
    unsigned int   TimeLeft,
             TimeUsed;
    unsigned char  Age,
             TermAttrib;
    /* Bit 0 : ANSI
    		 1 : Avatar
    		 2 : RIPscript */
    long	       	 MinSpeed,
                     MaxSpeed,
                     Credit,
                     OptionCost,
                     PerMinCost;
    ByteArray32    Node,
                   Group;
    unsigned int   StartTime[7],
             StopTime[7];
    unsigned char  Display[136],
             HotKey[9],
             MiscData[136],
             Foreground,
             Background,
             FreeSpace[50];
};

/* System events (EVENTS.RA) */
struct EVENTrecord {
    unsigned char  Status;  /* 0=Deleted 1=Enabled 2=Disabled */
    TimeF	       StartTime;
    unsigned char  ErrorLevel,
             Days;
    booleanf       Forced;
    DateF	       LastTimeRun;
};

struct EVENTrecord EVENTrecordArray[20];

/* Message area configuration (MESSAGES.RA) */
struct MESSAGErecord {
    unsigned int   AreaNum,
             Unused;
    unsigned char  Name[41];
    enum MsgType        Typ;
    enum MsgKindsType   MsgKinds;
    unsigned char  Attribute,
             /* Bit 0 : Enable EchoInfo
             		 1 : Combined access
             		 2 : File attaches
             		 3 : Allow aliases
             		 4 : Use SoftCRs as characters
             		 5 : Force handle
             		 6 : Allow deletes
             		 7 : Is a JAM area */
             DaysKill,   /* Kill older than 'x' days */
             RecvKill;   /* Kill recv msgs, recv for more than 'x' days */
    unsigned int   CountKill,
             ReadSecurity;
    FlagType       ReadFlags,
                   ReadNotFlags;
    unsigned int   WriteSecurity;
    FlagType       WriteFlags,
                   WriteNotFlags;
    unsigned int   SysopSecurity;
    FlagType       SysopFlags,
                   SysopNotFlags;
    unsigned char  OriginLine[61],
             AkaAddress,
             Age,
             JAMbase[61];
    unsigned int   Group,
             AltGroup[3];
    unsigned char  Attribute2;
    /* Bit 0 : Include in all groups */
    unsigned int   NetmailArea;
    unsigned char  FreeSpace2[7];
};

/* Groups (MGROUPS.RA & FGROUPS.RA) */
struct GROUPrecord {
    unsigned int   AreaNum;
    unsigned char  Name[41];
    unsigned int   Security;
    FlagType       Flags,
                   NotFlagsMask;
    unsigned char  FreeSpace[100];
};

/* File area configuration (FILES.RA) */
struct FILESrecord {
    unsigned int   AreaNum,
             Unused;
    unsigned char  Name[41],
             Attrib,
             /* Bit 0 : Include in new files scan
             		 1 : Include in upload dupe scan
             		 2 : Permit long descriptions
             		 3 : Area is on CD-ROM
             		 4 : All files are FREE
             		 5 : Allow DLs not in FDB
             		 6 : Allow users to password uploads
             		 7 : Scan uploads */
             FilePath[41];
    unsigned int   KillDaysDL,
             KillDaysFD;
    unsigned char  Password[16];
    unsigned int   MoveArea;
    unsigned char  Age,
             ConvertExt;
    unsigned int   Group;
    unsigned char  Attrib2;
    /* Bit 0 : Include in all groups */
    unsigned int   DefCost,
             UploadArea,
             UploadSecurity;
    FlagType       UploadFlags,
                   UploadNotFlags;
    unsigned int   Security;
    FlagType       Flags,
                   NotFlags;
    unsigned int   ListSecurity;
    FlagType       ListFlags,
                   ListNotFlags;
    unsigned int   AltGroup[3];
    unsigned char  Device,
             FreeSpace[13];
};

/* Multi-line conferencing (CONF.RA?) */
struct CONFrecord {
    unsigned char  Name[9],
             Parent[9],
             Desc[71],
             Attr,
             /* Bit 0 : Private
             		 1 : Unlisted
             		 2 : Global
             		 3 : Permanent
             		 4 : Use handles */
             Moderator[36],
             Language[21],
             Password[16];
    unsigned int   Security;
    FlagType	    Flags;
    unsigned char  NumNodes,
             Active[250];
    booleanf       Child[250];
    FlagType       NotFlagsMask;
    unsigned char  FreeSpace[96];
};

/* Modem configuration (MODEM.RA) */
struct MODEMrecord {
    unsigned char  ComPort,
             InitTries;
    unsigned int   BufferSize,
             ModemDelay;
    long		       MaxSpeed;
    booleanf       SendBreak,
                   LockModem,
                   AnswerPhone,
                   OffHook;
    unsigned char  InitStr[71],
             InitStr2[71],
             BusyStr[71],
             InitResp[41],
             BusyResp[41],
             Connect300[41],
             Connect1200[41],
             Connect2400[41],
             Connect4800[41],
             Connect7200[41],
             Connect9600[41],
             Connect12k[41],
             Connect14k[41],
             Connect16k[41],
             Connect19k[41],
             Connect38k[41],
             ConnectFax[41],
             RingStr[21],
             AnswerStr[21],
             ErrorFreeString[16],
             Connect21k[41],
             Connect24k[41],
             Connect26k[41],
             Connect28k[41],
             Connect57k[41],
             Connect64k[41],
             Connect31k[41],
             Connect33k[41],
             FreeSpace[100];
};

/* Archiver control (internal) */
struct ARCrecord {
    unsigned char  Extension[4],
             UnpackCmd[61],
             PackCmd[61];
};

/* Main configuration (CONFIG.RA) */
/* All fields prefixed with 'x' no longer in use */
struct CONFIGrecord {
    unsigned int   VersionID;
    unsigned char  xCommPort;       /* unused - found in MODEM.RA */
    long	       	 xBaud; 				/* unused - found in MODEM.RA */
    unsigned char  xInitTries,		/* unused - found in MODEM.RA */
             xInitStr[71], 	/* unused - found in MODEM.RA */
             xBusyStr[71], 	/* unused - found in MODEM.RA */
             xInitResp[41], 	/* unused - found in MODEM.RA */
             xBusyResp[41],   /* unused - found in MODEM.RA */
             xConnect300[41], /* unused - found in MODEM.RA */
             xConnect1200[41],/* unused - found in MODEM.RA */
             xConnect2400[41],/* unused - found in MODEM.RA */
             xConnect4800[41],/* unused - found in MODEM.RA */
             xConnect9600[41],/* unused - found in MODEM.RA */
             xConnect19k[41], /* unused - found in MODEM.RA */
             xConnect38k[41]; /* unused - found in MODEM.RA */
    booleanf       xAnswerPhone;    /* unused - found in MODEM.RA */
    unsigned char  xRing[21],		 	/* unused - found in MODEM.RA */
             xAnswerStr[21];  /* unused - found in MODEM.RA */
    booleanf       xFlushBuffer;    /* unused - found in MODEM.RA */
    int	    	    xModemDelay;     /* unused - found in MODEM.RA */
    unsigned int   MinimumBaud,
             GraphicsBaud,
             TransferBaud;
    TimeF	       SlowBaudTimeStart,
                   SlowBaudTimeEnd,
                   DownloadTimeStart,
                   DownloadTimeEnd,
                   PageStart[7],
                   PageEnd[7];
    unsigned char  SeriNum[23],
             CustNum[23],
             FreeSpace1[24];
    unsigned int	 PwdExpiry;
    unsigned char	 MenuPath[61],
               TextPath[61],
               AttachPath[61],
               NodelistPath[61],
               MsgBasePath[61],
               SysPath[61],
               ExternalEdCmd[61];
    struct NetAddress
        Address[10]; /* 0 = Main address, 1 = AKA 1... */
    unsigned char  SystemName[31];
    unsigned int   NewSecurity,
             NewCredit;
    FlagType       NewFlags;
    unsigned char  OriginLine[61],
             QuoteString[16],
             Sysop[36],
             LogFileName[61];
    booleanf       FastLogon,
                   AllowSysRem,
                   MonoMode,
                   StrictPwdChecking,
                   DirectWrite,
                   SnowCheck;
    int		       CreditFactor;
    unsigned int   UserTimeOut,
             LogonTime,
             PasswordTries,
             MaxPage,
             PageLength;
    booleanf	    CheckForMultiLogon,
                    ExcludeSysopFromList,
                    OneWordNames;
    enum AskType	       CheckMail;
    booleanf	    AskVoicePhone,
                    AskDataPhone,
                    DoFullMailCheck,
                    AllowFileShells,
                    FixUploadDates,
                    FreezeChat;
    enum AskType	       ANSI,            /* ANSI:  Yes/no/ask new users */
            ClearScreen,     /* Clear: "                  " */
            MorePrompt;      /* More:  "                  " */
    booleanf       UploadMsgs;
    enum AskType	       KillSent;        /* Kill/Sent     "             */
    unsigned int   CrashAskSec;  	/* Min sec# to ask 'Crash Mail ?' */
    FlagType       CrashAskFlags;
    unsigned int   CrashSec;     	/* Min sec# to always send crash mail */
    FlagType       CrashFlags;
    unsigned int   FAttachSec;    	/*         "    ask 'File Attach ?' */
    FlagType       FAttachFlags;
    unsigned char  NormFore,			/* foreground & background colours */
             NormBack,
             StatFore,
             StatBack,
             HiBack,
             HiFore,
             WindFore,
             WindBack,
             ExitLocal,			/* exit error levels - Unused?*/
             Exit300,
             Exit1200,
             Exit2400,
             Exit4800,
             Exit9600,
             Exit19k,
             Exit38k;
    booleanf       MultiLine;
    unsigned char  MinPwdLen;
    unsigned int   MinUpSpace;
    enum AskType	       HotKeys;
    unsigned char  BorderFore,
             BorderBack,
             BarFore,
             BarBack,
             LogStyle,
             MultiTasker,
             PwdBoard;
    unsigned int   xBufferSize;     /* unused - found in MODEM.RA */
    unsigned char  FKeys[10] [61];
    booleanf	    WhyPage;
    unsigned char  LeaveMsg;
    booleanf	    ShowMissingFiles,
                    xLockModem;      /* unused - found in MODEM.RA */
    unsigned char  FreeSpace2[10];
    booleanf	    AllowNetmailReplies;
    unsigned char  LogonPrompt[41];
    enum AskType        CheckNewFiles;
    unsigned char  ReplyHeader[61];
    unsigned char  BlankSecs;
    unsigned char  ProtocolAttrib[6];
    unsigned char  xErrorFreeString[16], /* unused - found in MODEM.RA */
             xDefaultCombined[25]; /* replaced with DefaultCombined */
    unsigned int   RenumThreshold;
    unsigned char  LeftBracket,
             RightBracket;
    booleanf       AskForHandle,
                   AskForBirthDate;
    unsigned int   GroupMailSec;
    booleanf	    ConfirmMsgDeletes;
    unsigned char  FreeSpace4[30],
             TempScanDir[61];
    enum AskType        ScanNow;
    unsigned char  xUnknownArcAction,  /* unused - found in ARCHIVE.RA ?*/
             xFailedUnpackAction,/* unused - found in ARCHIVE.RA ?*/
             FailedScanAction;
    /* Bit 0 : Mark deleted,
    		 1 : Mark unlisted,
    		 2 : Mark not available */
    unsigned int   xUnknownArcArea, 	/* no longer in use */
             xFailedUnpackArea, 	/* no longer in use */
             FailedScanArea;
    unsigned char  ScanCmd[61];
    booleanf	    xDeductIfUnknown; /* no longer in use */
    unsigned char  NewUserGroup;
    enum AskType        AVATAR;
    unsigned char  BadPwdArea,
             Location[41],
             DoAfterAction,  /* 0 = wait for CR
													 else wait for x seconds */
             OldFileLine[41], /* unused - replaced with FileLine*/
             CRfore,
             CRback,
             LangHdr[41];
    booleanf       xSendBreak;      /* unused - found in MODEM.RA */
    unsigned char  ListPath[61];    /* unused ??*/
    enum AskType	       FullMsgView,
            EMSI_Enable;
    booleanf	    EMSI_NewUser;
    unsigned char  EchoChar[2],
             xConnect7200[41],	/* unused - found in MODEM.RA */
             xConnect12000[41], 	/* unused - found in MODEM.RA */
             xConnect14400[41], 	/* unused - found in MODEM.RA */
             Exit7200,
             Exit12000,
             Exit14400,
             ChatCommand[61];
    enum AskType	       ExtEd;
    unsigned char  NewuserLanguage,
             LanguagePrompt[41];
    enum VideoType      VideoMode;
    booleanf	    AutoDetectANSI,
                    xOffHook; /* unused - found in MODEM.RA */
    unsigned char  NewUserDateFormat;
    unsigned char  KeyboardPwd[16];
    booleanf       CapLocation;
    unsigned char  NewuserSub,
             PrinterName[5],
             HilitePromptFore,	/* note lowercase 'l' in hilite */
             HiLitePromptBack,
             xInitStr2[71]; /* unused - found in MODEM.RA */
    booleanf	    AltJSwap;
    unsigned char  SemPath[61];
    booleanf       AutoChatCapture;
    unsigned char  FileBasePath[61];
    booleanf	    NewFileTag,
                    IgnoreDupeExt;
    unsigned char  TempCDFilePath[61],
             TagFore,
             TagBack,
             xConnect16k[41], /* unused - found in MODEM.RA */
             Exit16k,
             FilePayback,
             FileLine[201],
             FileMissingLine[201],
             NewUserULCredit;
    unsigned int   NewUserULCreditK;
    struct ARCrecord
        ArcInfo[10];
    unsigned char  RAMGRAltFKeys [5] [61],
             ArcViewCmd[61],
             xConnectFax[41], /* unused - found in MODEM.RA */
             ExitFax;
    booleanf	    UseXMS,
                    UseEMS;
    unsigned char  CheckDOB;
    enum AskType	       EchoCheck;
    unsigned int   ccSec,
             ReturnRecSec;
    booleanf	    HonourNetReq;
    COMBINEDrecord DefaultCombined;
    booleanf       AskForSex,
                   AskForAddress;
    enum AskType	       DLdesc;
    booleanf	    NewPhoneScan;
    unsigned char  Exit21k,
             Exit24k,
             Exit26k,
             Exit28k,
             Exit57k,
             Exit64k;
    booleanf       TagLogoffWarning, /* RA 2.5 - Warn if files are tagged
														 at log off */
                   LimitLocal,		 /* RA 2.5 - Turn off sysop control
														 keys for non-sysop local users*/
                   SavePasswords;	 /* RA 2.5 - Save user passwords */
    unsigned char  BlankLogins,		 /* RA 2.5 - Log off after x blank
														 logins (returns)*/
             ripiconpath[61],	 /* RA 2.5 - Path to RIPscript icons */
             Exit31k,			 /* RA 2.5 - Exit level for 31kbps */
             Exit33k;			 /* RA 2.5 - Exit level for 33kbps */
    booleanf       IncludeNewCDareas;/* RA 2.5 - Include CD areas in new
														 files list */
    unsigned char  FutureExpansion[513];
};

/* Exit-info dropfile (EXITINFO.BBS) */
struct EXITINFOrecord {
    unsigned int   Baud;
    struct SYSINFOrecord
        SysInfo;
    struct TIMELOGrecord
        TimeLogInfo;
    struct USERSrecord
        UserInfo;
    struct EVENTrecord
        EventInfo;
    booleanf	    NetMailEntered,
                    EchoMailEntered;
    TimeF	       LoginTime;
    DateF	       LoginDate;
    unsigned int   TimeLimit;
    long	       	 LoginSec;
    unsigned int   UserRecord,
             ReadThru,
             NumberPages,
             DownloadLimit;
    TimeF	       TimeOfCreation;
    long	       	 LogonPasswordCRC;
    booleanf	    WantChat;
    int	       	 DeductedTime;
    unsigned char  MenuStack [50] [9],
             MenuStackPointer;
    struct USERSXIrecord
        UserXIinfo;
    booleanf	    ErrorFreeConnect,
                    SysopNext,
                    EMSI_Session;
    unsigned char  EMSI_Crtdef[41],
             EMSI_Protocols[41],
             EMSI_Capabilities[41],
             EMSI_Requests[41],
             EMSI_Software[41],
             Hold_Attr1,
             Hold_Attr2,
             Hold_Len,
             PageReason[81],
             StatusLine,
             LastCostMenu[9];
    unsigned int   MenuCostPerMin;
    booleanf	    DoesAVT,
                    RIPmode,
                    RIPVersion;
    unsigned char  ExtraSpace[85];
};

/* File transfer protocols (PROTOCOL.RA) */
struct PROTOCOLrecord {
    unsigned char  Name[16],
             ActiveKey;
    booleanf	    OpusTypeCtlFile,
                    BatchAvailable;
    unsigned char  Attribute,
             /* 0=Disabled
             	1=Enabled */
             LogFileName[81],
             CtlFileName[81],
             DnCmdString[81],
             DnCtlString[81],
             UpCmdString[81],
             UpCtlString[81],
             UpLogKeyword[21],
             DnLogKeyword[21];
    unsigned int   XferDescWordNum,
             XferNameWordNum;
};