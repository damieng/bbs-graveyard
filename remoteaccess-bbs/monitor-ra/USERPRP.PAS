unit userprp;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ComCtrls, ExtCtrls, RA250, Dialogs, Crc32c, Locale,
  CoolListView, CoolCheckBox;

type
  TfrmUser = class(TForm)
    p1: TPanel;
    p2: TPanel;
    pag1: TPageControl;
    tabPersonal: TTabSheet;
    tabSettings: TTabSheet;
    cmdOK: TButton;
    edtName: TEdit;
    lUN: TLabel;
    edtLocation: TEdit;
    lLO: TLabel;
    lAD: TLabel;
    edtAddress1: TEdit;
    edtAddress2: TEdit;
    edtAddress3: TEdit;
    edtHandle: TEdit;
    lHD: TLabel;
    lVP: TLabel;
    edtVoice: TEdit;
    lDP: TLabel;
    edtData: TEdit;
    lPW: TLabel;
    edtPassword: TEdit;
    lCM: TLabel;
    lSX: TLabel;
    tabAccount: TTabSheet;
    tabInfo: TTabSheet;
    edtComment: TMemo;
    edtCredits: TEdit;
    lCR: TLabel;
    lLan: TLabel;
    lFmt: TLabel;
    edtLastTime: TEdit;
    lLTi: TLabel;
    edtLastDate: TEdit;
    lLDa: TLabel;
    edtCalls: TEdit;
    lCal: TLabel;
    lPE: TLabel;
    edtPending: TEdit;
    edtBirthdate: TEdit;
    lBD: TLabel;
    lSD: TLabel;
    edtSubDate: TEdit;
    edtMsgPost: TEdit;
    lMsP: TLabel;
    edtElapsed: TEdit;
    lEla: TLabel;
    lSE: TLabel;
    lGR: TLabel;
    lFiG: TLabel;
    edtFiG: TEdit;
    lFiA: TLabel;
    edtFiA: TEdit;
    lFileGroup: TLabel;
    lFileArea: TLabel;
    lMsG: TLabel;
    lMsA: TLabel;
    edtMsA: TEdit;
    edtMsG: TEdit;
    lMsgArea: TLabel;
    lMsgGroup: TLabel;
    lFD: TLabel;
    edtFirstDate: TEdit;
    lPro: TLabel;
    edtProtocol: TEdit;
    lFor: TLabel;
    lDoC: TLabel;
    edtDOBCheck: TEdit;
    lPaC: TLabel;
    edtPassChange: TEdit;
    lDS: TLabel;
    edtGroup: TEdit;
    cmdRefresh: TButton;
    eFiG: TEdit;
    eFiA: TEdit;
    eMsG: TEdit;
    eMsA: TEdit;
    lLU: TLabel;
    b1: TBevel;
    b2: TBevel;
    lDwn: TLabel;
    lFil: TLabel;
    edtDownloads: TEdit;
    edtDLKB: TEdit;
    lKB: TLabel;
    lTod: TLabel;
    edtToday: TEdit;
    edtULKB: TEdit;
    edtUploads: TEdit;
    lUpl: TLabel;
    b3: TBevel;
    lXf: TLabel;
    lLen: TLabel;
    edtLength: TEdit;
    chkCLS: TCoolCheckBox;
    chkANSI: TCoolCheckBox;
    chkAVATAR: TCoolCheckBox;
    chkMore: TCoolCheckBox;
    chkFullView: TCoolCheckBox;
    chkFullEdit: TCoolCheckBox;
    b4: TBevel;
    lDi: TLabel;
    chkHotKeys: TCoolCheckBox;
    chkQuiet: TCoolCheckBox;
    lPr: TLabel;
    b5: TBevel;
    chkSkipEcho: TCoolCheckBox;
    chkScanSel: TCoolCheckBox;
    lNM: TLabel;
    b8: TBevel;
    chkDeleted: TCoolCheckBox;
    chkPagePriority: TCoolCheckBox;
    chkPostBill: TCoolCheckBox;
    chkHidden: TCoolCheckBox;
    chkGuest: TCoolCheckBox;
    chkXferPriority: TCoolCheckBox;
    chkNoKill: TCoolCheckBox;
    b7: TBevel;
    lAS: TLabel;
    lstFlags: TCoolListView;
    lCRC: TLabel;
    edtSex: TEdit;
    edtDateFmt: TEdit;
    edtForward: TEdit;
    edtLanguage: TEdit;
    edtSecurity: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdRefreshClick(Sender: TObject);
  private
    lUserRec : LongInt;
    procedure LoadFromFile;
  public
    procedure CustomLoad(Parent : TObject; lRecord : LongInt);
  end;

var
  frmUser: TfrmUser;

implementation

uses Main, Routines;

{$R *.DFM}

procedure TfrmUser.LoadFromFile;
var
   fhndUSER : Integer;
   USERSrec : USERSrecord;
   iAFlag   : Integer;
   iNFlag   : Integer;
   fhGen : Integer;
   FILESrec : FILESrecord;
   GROUPrec : GROUPrecord;
   MESSAGErec : MESSAGErecord;
begin
   fhndUSER := FileOpen(CONFIGrec.MsgBasePath + '\USERS.BBS', fmOpenRead or fmShareDenyNone);
      if (FileSeek(fhndUSER,(lUserRec*SizeOf(USERSrec)),0) = -1) then
         begin
           ShowMessage('Unable to locate user record');
           FileClose(fhndUSER);
           Close;
         end
         else
 begin
   FileRead(fhndUSER,USERSrec,SizeOf(USERSrec));
   FileClose(fhndUSER);
   Caption := 'User (' + USERSrec.Name + ')';

   { Apply the record to the form }
   with USERSrec do
     begin
       { Personal tab }
       edtName.Text            := Name;
       edtLocation.Text        := Location;
       edtHandle.Text          := Handle;
       edtSex.Text             := SexToText[Sex];
       edtBirthdate.Text       := RADateToStr(BirthDate);
       lCRC.Caption            := 'CRC is ' + Format('%.8x',[PasswordCRC]);
       if (CRC32(PChar(String(Password)),StrLen(PChar(String(Password))),-1) <> PasswordCRC) then
          edtPassword.Text     := 'Not available'
        else
          edtPassword.Text     := Password;
       edtAddress1.Text        := Address1;
       edtAddress2.Text        := Address2;
       edtAddress3.Text        := Address3;
       edtVoice.Text           := VoicePhone;
       edtData.Text            := DataPhone;
       edtComment.Text         := Comment;
       { Account tab }
       edtSecurity.Text        := IntToStr(Security);
       edtGroup.Text           := IntToStr(Group);
       edtCredits.Text         := IntToStr(Credit);
       edtPending.Text         := IntToStr(Pending);
       edtFirstDate.Text       := RADateToStr(FirstDate);
       edtSubDate.Text         := RADateToStr(SubDate);
       chkDeleted.Checked      := (Attribute and 1 <> 0);
       chkNoKill.Checked       := (Attribute and 16 <> 0);
       chkPagePriority.Checked := (Attribute2 and 16 <> 0);
       chkXferPriority.Checked := (Attribute and 32 <> 0);
       chkGuest.Checked        := (Attribute2 and 64 <> 0);
       chkPostBill.Checked     := (Attribute2 and 128 <> 0);
       chkHidden.Checked       := (Attribute2 and 8 <> 0);
       { Settings tab }
       edtLanguage.Text        := IntToStr(Language);
       lstFlags.Items.BeginUpdate;
       LoadFlags(lstFlags);
       for iAFlag := 0 to 3 do
           for iNFlag := 0 to 7 do
               if (Flags[iAFlag+1] and Power2[iNFlag+1] <>0) then
                  lstFlags.Items[(iAFlag*8)+iNFlag].SubItems[1] := 'Yes';
       lstFlags.Items.EndUpdate;
       if (DateFormat = 0) then DateFormat := 2; {Workaround for default}
       edtDateFmt.Text         := DateToText[DateFormat];
       edtProtocol.Text        := DefaultProtocol;
       edtForward.Text         := ForwardTo;
       edtLength.Text          := IntToStr(ScreenLength);
       chkCLS.Checked          := (Attribute and 2 <> 0);
       chkANSI.Checked         := (Attribute and 8 <> 0);
       chkAVATAR.Checked       := (Attribute2 and 2 <> 0);
       chkFullEdit.Checked     := (Attribute and 64 <> 0);
       chkFullView.Checked     := (Attribute2 and 4 <> 0);
       chkMore.Checked         := (Attribute and 4 <> 0);
       chkHotKeys.Checked      := (Attribute2 and 1 <> 0);
       chkQuiet.Checked        := (Attribute and 128 <> 0);
       chkSkipEcho.Checked     := (Attribute2 and 32 <> 0);
       chkScanSel.Checked      := (Attribute3 and 1 <> 0);
       { Info tab }
       edtLastTime.Text        := RATimeToStr(LastTime);
       edtLastDate.Text        := RADateToStr(LastDate);
       edtElapsed.Text         := IntToStr(Elapsed);
       edtCalls.Text           := IntToStr(NoCalls);
       edtDOBCheck.Text        := IntToStr(LastDOBCheck);
       edtPassChange.Text      := IntToStr(LastPwdChange);
       edtFiG.Text             := IntToStr(FileGroup);
       edtFiA.Text             := IntToStr(FileArea);
       edtMsG.Text             := IntToStr(MsgGroup);
       edtMsA.Text             := IntToStr(MsgArea);
       edtDownloads.Text       := IntToStr(Downloads);
       edtDLKB.Text            := IntToStr(DownloadsK);
       edtToday.Text           := IntToStr(TodayK);
       edtUploads.Text         := IntToStr(Uploads);
       edtULKB.Text            := IntToStr(UploadsK);
       eFiG.Text := '';
       eFiA.Text := '';
       eMsG.Text := '';
       eMsA.Text := '';
     end;
   try { File Group }
     fhGen := FileOpen(CONFIGrec.SysPath + '\FGROUPS.RA',fmRead);
     FileSeek(fhGen,(StrToInt(edtFiG.Text)-1)*SizeOf(GROUPrec),0);
     FileRead(fhGen,GROUPrec,SizeOf(GROUPrec));
     eFiG.Text := GROUPrec.Name;
   finally
     FileClose(fhGen);
   end;
   try { File Area }
     fhGen := FileOpen(CONFIGrec.SysPath + '\FILES.RA',fmRead);
     FileSeek(fhGen,(StrToInt(edtFiA.Text)-1)*SizeOf(FILESrec),0);
     FileRead(fhGen,FILESrec,SizeOf(FILESrec));
     eFiA.Text := FILESrec.Name;
   finally
     FileClose(fhGen);
   end;
   try { Message Group }
     fhGen := FileOpen(CONFIGrec.SysPath + '\MGROUPS.RA',fmRead);
     FileSeek(fhGen,(StrToInt(edtMsG.Text)-1)*SizeOf(GROUPrec),0);
     FileRead(fhGen,GROUPrec,SizeOf(GROUPrec));
     eMsG.Text := GROUPrec.Name;
   finally
     FileClose(fhGen);
   end;
   try { Message Area }
     fhGen := FileOpen(CONFIGrec.SysPath + '\MESSAGES.RA',fmRead);
     FileSeek(fhGen,(StrToInt(edtMsA.Text)-1)*SizeOf(MESSAGErec),0);
     FileRead(fhGen,MESSAGErec,SizeOf(MESSAGErec));
     eMsA.Text := MESSAGErec.Name;
   finally
     FileClose(fhGen);
   end;
  end;
end;

procedure TfrmUser.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     Action := caFree;
end;

procedure TfrmUser.cmdOKClick(Sender: TObject);
begin
     Close;
end;

procedure TfrmUser.CustomLoad(Parent : TObject; lRecord : LongInt);
begin
     lUserRec := lRecord-1;
     LoadFromFile;
     Show;
end;


procedure TfrmUser.cmdRefreshClick(Sender: TObject);
begin
   LoadFromFile;
end;

end.

