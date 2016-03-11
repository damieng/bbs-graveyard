unit Routines;

interface

uses Classes,SysUtils,Dialogs,Windows,Graphics,StdCtrls,RA250,ComCtrls,
     CoolListView;

function GetEnvVar(sVariable : PChar) : string;
function GetFileDate(sFileName: string): string;
function GetIntFileDate(sFileName: string): TDateTime;
function TimeTo24HStr(tdInput : TDateTime) : string;
function DoPath(sPath : string) : string;
function MagicCase(sInput : string) : string;
function GetFileSize(sFileName: string): LongInt;
function RADateToStr(sInput : string) : string;
function RATimeToStr(sInput : string) : string;
function StrToRADate(sInput : string) : string;
function StrToRATime(sInput : string) : string;
procedure LoadLanguageCbo(sPath : String; Target : TComboBox);
procedure LoadSecurityCbo(sPath : String; Target : TComboBox);
procedure LoadUserCbo(sPath : String; Target : TComboBox);
procedure LoadFlags(Target : TCoolListView);
function FindUser(sMsgBase : String; sUserName : String) : LongInt;
function Plaural(iNumber : Integer; sInput : String) : String;
function UnixDateToDate(iUnixDate : LongInt) : TDateTime;
procedure AddColumn(ListView : TCoolListView; Caption : String; Width : Integer; Alignment : TAlignment);

const
     ColourWinDos : array[0..15] of byte = (0,4,2,6,1,5,3,7,8,12,10,14,9,13,11,15);
     ColourWin : array[0..15] of TColor = (clBlack,clNavy,clGreen,clTeal,clMaroon,
               clPurple,clOlive,clSilver,clGray,clBlue,clLime,clAqua,clRed,clFuchsia,
               clYellow,clWhite);
     Power2 : array[1..8] of byte = (1,2,4,8,16,32,64,128);
     fmRead = fmOpenRead or fmShareDenyNone;
     YesNoAsk : array[0..2] of string = ('Yes','No','Ask');
     Sexy : array[0..2] of string = ('Unknown','Male','Female');
     DateFmt : array[0..4] of string = ('MM-DD-YY','DD-MM-YY','MM-DD-YY','YY-MM-DD','DD-Mmm-YY');

implementation

{-- Get DOS-style environment variables ---------------------------------}
function GetEnvVar(sVariable : PChar) : string;
var
   pBuffer: PChar;
begin
     GetEnvironmentVariable(sVariable,pBuffer,SizeOf(pBuffer));
     GetEnvVar := string(pBuffer);
end;

{-- Get a file date/time & return as string -----------------------------}
function GetFileDate(sFileName: string): string;
var
   fhGeneral: Integer;
   iDate: Integer;
begin
  Result := '';
  if (FileExists(sFileName)) then
     begin
       fhGeneral := FileOpen(sFileName, fmOpenRead or fmShareDenyNone);
       try
         iDate := FileGetDate(fhGeneral);
         if (iDate <> -1) then Result := DateTimeToStr(FileDateToDateTime(iDate));
       finally
         FileClose(fhGeneral);
       end;
     end;
end;

{-- Get a file date/time & return as integer ----------------------------}
function GetIntFileDate(sFileName: string): TDateTime;
var
   fhGeneral: Integer;
begin
  Result := -1;
  if (FileExists(sFileName)) then
     begin
       fhGeneral := FileOpen(sFileName, fmOpenRead or fmShareDenyNone);
       try
         Result := FileDateToDateTime(FileGetDate(fhGeneral));
       finally
         FileClose(fhGeneral);
       end;
     end;
end;

{-- Append back-slash to string if not one already ----------------------}
function DoPath(sPath : string) : string;
begin
     if (copy(sPath,Length(sPath),1) <> '\') then
        Result := sPath + '\'
      else
        Result := sPath;
end;

{-- Return a time/date field as a 24-hour string ------------------------}
function TimeTo24HStr(tdInput : TDateTime) : string;
var
   sTimeFormat : String;
   iPosition : Integer;
begin
    sTimeFormat := LongTimeFormat;
    iPosition := Pos('AMPM',LongTimeFormat);
    if (iPosition > 0) then
       LongTimeFormat := Trim(Copy(LongTimeFormat,1,iPosition-1));
    Result := TimeToStr(tdInput);
    LongTimeFormat := sTimeFormat;
end;

{-- Return a normally formatted case string -----------------------------}
function MagicCase(sInput : string) : string;
var
   sTemp : String;
begin
     sTemp := LowerCase(sInput);
     sTemp[1] := UpCase(sInput[1]);
     Result := sTemp;
end;

{-- Get a file size------------------------------------------------------}
function GetFileSize(sFileName: string): LongInt;
var
   fhGeneral : Integer;
begin
  Result := -1;
  if (FileExists(sFileName)) then
     begin
       fhGeneral := FileOpen(sFileName, fmOpenRead or fmShareDenyNone);
       try
         Result := FileSeek(fhGeneral,0,2);
       finally
         FileClose(fhGeneral);
       end;
     end;
end;

function RADateToStr(sInput : String) : string;
begin
     if (sInput = '  -  -  ') then Result := ''
        else Result := DateToStr(EncodeDate(StrToIntDef(Copy(sInput,7,2),1),
                                    StrToIntDef(Copy(sInput,1,2),1),
                                    StrToIntDef(Copy(sInput,4,2),1)));
end;

function RATimeToStr(sInput : String) : string;
begin
     if (sInput = '  :  ') then Result := ''
        else Result := TimeToStr(EncodeTime(StrToIntDef(Copy(sInput,1,2),0),
                                    StrToIntDef(Copy(sInput,4,2),0),0,0));
end;

function StrToRADate(sInput : String) : string;
begin
     if (sInput = '') then Result := '  -  -  '
        else Result := FormatDateTime('mm-dd-yy',StrToDate(sInput));
end;

function StrToRATime(sInput : String) : string;
begin
     if (sInput = '') then Result := '  :  '
        else Result := FormatDateTime('hh:nn',StrToTime(sInput));
end;

procedure LoadLanguageCbo(sPath : String; Target : TComboBox);
var
   fhndLanguage : Integer;
   LANGUAGErec : LANGUAGErecord;
   lRecord : LongInt;
begin
   Target.Items.Clear;
   lRecord := 0;
   fhndLanguage := FileOpen(sPath + '\LANGUAGE.RA',fmRead);
   while (FileRead(fhndLanguage,LANGUAGErec,SizeOf(LANGUAGErec)) = SizeOf(LANGUAGErec)) do
     begin
        inc(lRecord);
        Target.Items.Add(IntToStr(lRecord) + ' ' + LANGUAGErec.Name);
     end;
   FileClose(fhndLanguage);
end;

procedure LoadSecurityCbo(sPath : String; Target : TComboBox);
var
   fhndSecurity : Integer;
   LIMITSrec : LIMITSrecord;
begin
   Target.Items.Clear;
   fhndSecurity := FileOpen(sPath + '\LIMITS.RA',fmRead);
   while (FileRead(fhndSecurity,LIMITSrec,SizeOf(LIMITSrec)) = SizeOf(LIMITSrec)) do
        Target.Items.Add(IntToStr(LIMITSrec.Security));
   FileClose(fhndSecurity);
end;

procedure LoadUserCbo(sPath : String; Target : TComboBox);
var
   fhndUser : Integer;
   USERSrec : USERSrecord;
begin
   Target.Items.Clear;
   fhndUser := FileOpen(sPath + '\USERS.BBS',fmRead);
   while (FileRead(fhndUser,USERSrec,SizeOf(USERSrec)) = SizeOf(USERSrec)) do
        Target.Items.Add(USERSrec.Name);
   FileClose(fhndUser);
end;

procedure LoadFlags(Target : TCoolListView);
var
   tlNew : TListItem;
   iAFlag : Integer;
   iNFlag : Integer;
begin
   Target.Items.Clear;
   for iAFlag := 1 to 4 do
       for iNFlag := 1 to 8 do
           begin
             tlNew := Target.Items.Add;
             tlNew.Caption := Char(64+iAFlag) + IntToStr(iNFlag);
             tlNew.SubItems.Add('');
             tlNew.SubItems.Add('');
           end;
end;

function FindUser(sMsgBase : String; sUserName : String) : LongInt;
var
   fhUser  : Integer;
{   USERSIDXrec : USERSIDXrecord;
   iUserCRC : Integer;}
   USERSrec : USERSrecord;
begin
{   Result := -1;
   iUserCRC := CRC32(PChar(sUserName),Strlen(PChar(sUserName)),-1);
   fhUser := FileOpen(sMsgBase + 'USERSIDX.BBS',fmOpenRead or fmShareDenyNone);
   while (FileRead(fhUser,USERSIDXrec,SizeOf(USERSIDXrec)) = SizeOf(USERSIDXrec)) do
         begin
           if (USERSIDXrec.NameCRC32 = iUserCRC) then ShowMessage('OK');
           ShowMessage(IntToStr(USERSIDXrec.NameCRC32));
         end;
   if (USERSIDXrec.NameCRC32 = iUserCRC) then Result := FileSeek(fhUser,0,1);
   FileClose(fhUser);}

   Result := -1;
   fhUser := FileOpen(sMsgBase + 'USERS.BBS',fmOpenRead or fmShareDenyNone);
   while (FileRead(fhUser,USERSrec,SizeOf(USERSrec)) = SizeOf(USERSrec)) do
           if (USERSrec.Name = sUserName) then break;
   if (USERSrec.Name = sUserName) then Result := FileSeek(fhUser,0,1) div SizeOf(USERSrec);
   FileClose(fhUser);
end;

function Plaural(iNumber : Integer;sInput : String) : String;
begin
     if (iNumber<> 1) then
        sInput := sInput + 's';
     Result := IntToStr(iNumber) + ' ' + sInput
end;

function UnixDateToDate(iUnixDate : LongInt) : TDateTime;
var
   iWork : LongInt;
   iSec,iMin,iHour,iDays : Integer;
begin
   iWork := iUnixDate;
   iSec := iUnixDate mod 60;
   iUnixDate := iUnixDate div 60;
   iMin := iUnixDate mod 60;
   iUnixDate := iUnixDate div 60;
   iHour := iHour mod 24;
   iUnixDate := iUnixDate div 24;
   iDays := iUnixDate;
   Result := iDays + 25569;
end;

procedure AddColumn(ListView : TCoolListView; Caption : String; Width : Integer; Alignment : TAlignment);
var
  lcNew : TListColumn;
begin
  lcNew := ListView.Columns.Add;
  lcNew.Caption := Caption;
  lcNew.Width := Width;
  lcNew.Alignment := Alignment;
end;

end.
