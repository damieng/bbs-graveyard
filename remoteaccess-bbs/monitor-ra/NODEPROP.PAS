unit NodeProp;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ComCtrls, ExtCtrls, Dialogs, Menus, Routines, VtraCfg, Locale,
  CoolListView, CoolCheckBox, CoolGradient;

type
  TfrmProperties = class(TForm)
    pnl1: TPanel;
    pnlB: TPanel;
    pag1: TPageControl;
    General: TTabSheet;
    cmdOK: TButton;
    cmdPrevious: TButton;
    cmdNext: TButton;
    Log: TTabSheet;
    txtLogName: TEdit;
    lLF: TLabel;
    Calls: TTabSheet;
    lblBBSCalls: TLabel;
    lblNodeCalls: TLabel;
    rchLog: TRichEdit;
    Info: TTabSheet;
    grpNote: TGroupBox;
    memNote: TMemo;
    lblSentTime: TLabel;
    cmdDelete: TButton;
    cmdExport: TButton;
    pnlNode: TPanel;
    edtNode: TEdit;
    b1: TBevel;
    lUN: TLabel;
    lHD: TLabel;
    edtName: TEdit;
    edtHandle: TEdit;
    lLO: TLabel;
    lCN: TLabel;
    edtLocation: TEdit;
    edtSpeed: TEdit;
    lSP: TLabel;
    lST: TLabel;
    edtStatus: TEdit;
    b2: TBevel;
    lLI: TLabel;
    lPC: TLabel;
    lAT: TLabel;
    chkNoDisturb: TCoolCheckBox;
    chkHidden: TCoolCheckBox;
    b3: TBevel;
    b4: TBevel;
    lPE: TLabel;
    chkNote: TCoolCheckBox;
    edtCall: TEdit;
    edtLogIn: TEdit;
    edtPrevCall: TEdit;
    chkLogOff: TCoolCheckBox;
    lNT: TLabel;
    pnlSystem: TPanel;
    lblLastCall: TLabel;
    lblTotCalls: TLabel;
    b6: TBevel;
    lblNodes: TLabel;
    lblSysop: TLabel;
    lblSysLoc: TLabel;
    b5: TBevel;
    edtLastCall: TEdit;
    edtTotCalls: TEdit;
    edtNodes: TEdit;
    edtSysLoc: TEdit;
    edtSysop: TEdit;
    edtBBS: TEdit;
    lUD: TLabel;
    memDoes: TMemo;
    popClipBoard: TPopupMenu;
    itmPopCopy: TMenuItem;
    N1: TMenuItem;
    itmPopAll: TMenuItem;
    N2: TMenuItem;
    Usage: TTabSheet;
    lTD: TLabel;
    bar1: TCoolGradient;
    bar2: TCoolGradient;
    bar3: TCoolGradient;
    bar4: TCoolGradient;
    bar5: TCoolGradient;
    bar6: TCoolGradient;
    bar7: TCoolGradient;
    bar8: TCoolGradient;
    bar9: TCoolGradient;
    bar10: TCoolGradient;
    bar11: TCoolGradient;
    bar12: TCoolGradient;
    bar13: TCoolGradient;
    bar14: TCoolGradient;
    bar15: TCoolGradient;
    bar16: TCoolGradient;
    bar17: TCoolGradient;
    bar18: TCoolGradient;
    bar19: TCoolGradient;
    bar20: TCoolGradient;
    bar21: TCoolGradient;
    bar22: TCoolGradient;
    bar23: TCoolGradient;
    bar24: TCoolGradient;
    itmPopDelete: TMenuItem;
    chkPagedSysop: TCoolCheckBox;
    NewUsers: TTabSheet;
    lUT: TLabel;
    lblNewUser: TLabel;
    lstNewUsers: TCoolListView;
    popUsage: TPopupMenu;
    itmReset: TMenuItem;
    lstCallers: TCoolListView;
    pnlBord: TPanel;
    imgModem: TImage;
    b7: TBevel;
    chkJAMNet: TCoolCheckBox;
    lblNetWait: TLabel;
    chkHudNet: TCoolCheckBox;
    lblEchoWait: TLabel;
    chkJAMEcho: TCoolCheckBox;
    chkHudEcho: TCoolCheckBox;
    lblLastUse: TLabel;
    edtLastUse: TEdit;
    lblUse: TLabel;
    lblLow: TLabel;
    lblHigh: TLabel;
    lTT: TLabel;
    lblUsed: TLabel;
    lAL: TLabel;
    lblAverage: TLabel;
    Mailer: TTabSheet;
    lstMailer: TCoolListView;
    tabMailDir: TTabControl;
    itmPrintLog: TMenuItem;
    lblMailCalls: TLabel;
    cmdRefresh: TButton;
    grpMsg: TGroupBox;
    lMS: TLabel;
    lFR: TLabel;
    lTO: TLabel;
    lAR: TLabel;
    lPR: TLabel;
    edtLastTime: TEdit;
    edtFrom: TEdit;
    edtTo: TEdit;
    edtArea: TEdit;
    edtPriv: TEdit;
    lSJ: TLabel;
    edtSubj: TEdit;
    lBT: TLabel;
    lSA: TLabel;
    imgSys: TImage;
    procedure FormShow(Sender: TObject);
    procedure cmdPreviousClick(Sender: TObject);
    procedure cmdNextClick(Sender: TObject);
    procedure pag1Change(Sender: TObject);
    procedure cmdDeleteClick(Sender: TObject);
    procedure cmdExportClick(Sender: TObject);
    procedure RefreshGeneral;
    procedure RefreshLog;
    procedure RefreshCalls;
    procedure RefreshInfo;
    procedure RefreshSystem;
    procedure RefreshUsage;
    procedure RefreshNewUsers;
    procedure RefreshMailer;
    procedure ChangeNode;
    procedure UpdateTabs;
    procedure itmPopCopyClick(Sender: TObject);
    procedure itmPopAllClick(Sender: TObject);
    procedure itmPopDeleteClick(Sender: TObject);
    procedure itmResetClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cmdOKClick(Sender: TObject);
    procedure tabMailDirChange(Sender: TObject);
    procedure itmPrintLogClick(Sender: TObject);
    procedure lstCallersDblClick(Sender: TObject);
    procedure lstNewUsersDblClick(Sender: TObject);
  private
    iNode : Integer;
    sNoteFile: string;
    sMailName : string;
    sTIMELOGname : string;
    sTemp : string;
    fhGeneral : Integer;
    tiNew : TListItem;
  public
    procedure BeginHere;
    procedure CustomLoad(Sender : TObject; Node : Integer);
  end;

var
   frmProperties: TfrmProperties;

implementation

uses Main,RA250;

{$R *.DFM}

{ Initialize the form                                                          }
procedure TfrmProperties.FormShow(Sender: TObject);
begin
  Pag1.ActivePage := General;
  BeginHere;
end;

{ Secondary form initialization                                                }
procedure TfrmProperties.BeginHere;
begin
  UpdateTabs;
  ChangeNode;
end;

{ Refresh 'General' tab for a node                                             }
procedure TfrmProperties.RefreshGeneral;
var
  USERONrec: USERONrecord;
  tsExit : TSearchRec;
  tdTempDate : TDateTime;
begin
  frmMain.imlLarge.GetIcon(frmMain.lstStatus.Items[iNode].ImageIndex,imgModem.Picture.Icon);
  fhGeneral := FileOpen(CONFIGrec.SysPath + 'USERON.BBS', fmOpenRead or fmShareDenyNone);
  FileSeek(fhGeneral,(iNode-1)*SizeOf(USERONrec),0);
  FileRead(fhGeneral,USERONrec,SizeOf(USERONrec));
  FileClose(fhGeneral);

  if (iNode = USERONrec.Line) and (USERONrec.Name <> '') then
     begin
       edtNode.Text := 'Node ' + IntToStr(USERONrec.Line);
       edtName.Text := USERONrec.Name;
       if (USERONrec.Baud > 0) then
          edtSpeed.Text := IntToStr(USERONrec.Baud)
        else
          edtSpeed.Text := 'Local';
       edtLocation.Text := USERONrec.City;
       edtHandle.Text := USERONrec.Handle;
       edtCall.Text := IntToStr(USERONrec.NoCalls);
       chkHidden.Checked := ((USERONrec.Attribute and 1) <>0);
       chkPagedSysop.Checked := ((USERONrec.Attribute and 2) <>0);
       chkNoDisturb.Checked :=  ((USERONrec.Attribute and 8) <>0);
       tdTempDate := GetIntFileDate(CONFIGrec.SemPath + 'RABUSY.' + IntToStr(USERONrec.Line));
       if (tdTempDate > 0) then
          edtLogIn.Text := DateTimeToStr(tdTempDate) + Elapsed + TimeTo24HStr(Now - tdTempDate) + ')'
        else
          edtLogIn.Text := '';
       case USERONrec.Status of
          0..7 : edtStatus.Text := StateToText[USERONrec.Status];
            255: edtStatus.Text := USERONrec.StatDesc;
       end;
     end
   else
     begin
       edtNode.Text := 'Node ' + IntToStr(iNode);
       edtName.Text := '';
       edtSpeed.Text := '';
       edtLocation.Text := '';
       edtHandle.Text := '';
       edtCall.Text := '';
       if (iNode <> USERONrec.Line) then
          edtStatus.Text := 'Offline'
        else
          edtStatus.Text := 'Logging in';
       edtLogIn.Text := '';
       chkHidden.Checked := False;
       chkPagedSysop.Checked := False;
       chkNoDisturb.Checked := False;
       edtLogIn.Text := '';
     end;

  tdTempDate := GetIntFileDate(Format(CONFIGrec.SysPath + sRealTpl + '\TIMELOG.BBS',[iNode]));
  if (tdTempDate > 0) then
     edtPrevCall.Text := DateTimeToStr(tdTempDate) + Elapsed + TimeTo24HStr(Now-tdTempDate) + ')'
   else
     edtPrevCall.Text := '';
  if (chkHidden.Checked) then
     chkHidden.Hint := 'User not visible to others|'
   else
     chkHidden.Hint := 'User is visible to others|';
  if (chkPagedSysop.Checked) then
     chkPagedSysop.Hint := 'User has paged the sysop|'
   else
     chkPagedSysop.Hint := 'User has not paged the sysop|';
  if (chkNoDisturb.Checked) then
     chkNoDisturb.Hint := 'User is rejecting online notes|'
   else
     chkNoDisturb.Hint := 'User is accepting online notes|';
  chkLogOff.Checked := (FindFirst(CONFIGrec.SemPath + 'RAXIT' + IntToStr(iNode) + '.*',faAnyFile,tsExit) = 0);
  FindClose(tsExit);

  if chkLogOff.Checked then
     chkLogOff.Hint := 'Log-off request is pending|'
   else
     chkLogOff.Hint := 'No log-off request is pending|';
  chkNote.Checked := (FileExists(CONFIGrec.SemPath + 'NODE'+ IntToStr(iNode) + '.RA'));
  if chkNote.Checked then
     chkNote.Hint := 'Online note is pending|'
   else
     chkNote.Hint := 'No online note is pending|';
  sTemp := CONFIGrec.SemPath + 'USERDOES.' +IntToStr(iNode);
  if (FileExists(sTemp)) then
     memDoes.Lines.LoadFromFile(sTemp)
   else
     memDoes.Lines.Clear;
end;

{ Go back a node                                                               }
procedure TfrmProperties.cmdPreviousClick(Sender: TObject);
begin
  if (iNode > 0) then
     begin
       dec(iNode);
       if iNode = 0 then UpdateTabs;
       ChangeNode;
     end;
end;

{-- Update the tabs at top of page --------------------------------------}
procedure TfrmProperties.UpdateTabs;
var
  bSystem : Boolean;
begin
  if (Pag1.ActivePage <> Calls) then Pag1.ActivePage := General;
  bSystem := (iNode = 0);
  Info.TabVisible := not bSystem;
  Log.TabVisible := not bSystem;
  Usage.TabVisible := not bSystem;
  if (VTRACFGrec.MailerType > 0) then
     if (bSystem) then
        Mailer.TabVisible := not VTRACFGrec.MailerMulti
      else
        Mailer.TabVisible := VTRACFGrec.MailerMulti
   else
     Mailer.TabVisible := False;
  NewUsers.TabVisible := bSystem;
  pnlSystem.Visible := bSystem;
  pnlNode.Visible := not bSystem;
end;

{ Update information when node changed                                         }
procedure TfrmProperties.ChangeNode;
begin
  if (iNode = 0) then
     Caption := 'BBS Properties'
   else
     Caption := 'Node ' + IntToStr(iNode) + ' Properties';
  pag1Change(frmProperties);
  cmdPrevious.Enabled := (iNode > 0);
  cmdNext.Enabled := (iNode < frmMain.lstStatus.Items.Count-1);
end;

{ Go to next node                                                              }
procedure TfrmProperties.cmdNextClick(Sender: TObject);
begin
  if (iNode < frmMain.lstStatus.Items.Count) then
     begin
       inc(iNode);
       if (iNode = 1) then UpdateTabs;
       ChangeNode;
     end;
end;

{ Refresh the "Log" tab                                                        }
procedure TfrmProperties.RefreshLog;
var
  iTempPos : Integer;
begin
  if (frmMain.Stack = 0) then
     begin
       ShowMessage(RegOnly);
       rchLog.Lines.Add('Your log file would be here so why not register today!');
       rchLog.Lines.Add('See the included ORDER.FRM for pricing details');
       Exit;
     end;
  Screen.Cursor := crHourglass;
  rchLog.Lines.Clear;
  sTemp := CONFIGrec.LogFileName;
  while (Pos('*N',sTemp) > 0) do
     begin
       iTempPos := Pos('*N',sTemp);
       sTemp := Format(Copy(sTemp,1,iTempPos-1) + '%d' + Copy(sTemp,iTempPos+2,255),[iNode]);
     end;

  txtLogName.Text := sTemp;
  if (FileExists(sTemp)) then
     rchLog.Lines.LoadFromFile(sTemp);
  Screen.Cursor := crDefault;
end;

{ Refresh the "Callers" tab                                                    }
procedure TfrmProperties.RefreshCalls;
var
  LASTCALLrec : LASTCALLrecord;
  iTimeOn, iTimeOff : Integer;
  iBBSCount,iTimeUsex,iNodeCount : Integer;
begin
  iBBSCount := 0;
  iTimeUsex := 0;
  iNodeCount := 0;
  lstCallers.Items.BeginUpdate;
  lstCallers.Items.Clear;
  fhGeneral := FileOpen(CONFIGrec.SysPath + 'LASTCALL.BBS',fmOpenRead or fmShareDenyNone);
  while (FileRead(fhGeneral,LASTCALLrec,SizeOf(LASTCALLrec)) = SizeOf(LASTCALLrec)) do
     begin
       inc(iBBSCount);
       if ((LASTCALLrec.Line = iNode) or (iNode = 0)) then
          begin
            inc(iNodeCount);
            tiNew := lstCallers.Items.Add;
            tiNew.Caption := LASTCALLrec.Name;
            tiNew.SubItems.Add(IntToStr(LASTCALLrec.Line));
            tiNew.SubItems.Add(LASTCALLrec.LogOn);
            tiNew.SubItems.Add(LASTCALLrec.LogOff);
            iTimeOn := StrToInt(Copy(LASTCALLrec.LogOn,1,2))*60 +
                       StrToInt(Copy(LASTCALLrec.LogOn,4,2));
            iTimeOff := StrToInt(Copy(LASTCALLrec.LogOff,1,2))*60 +
                        StrToInt(Copy(LASTCALLrec.LogOff,4,2));
            if (iTimeOn > iTimeOff) then iTimeOff := iTimeOff + 1440;
            iTimeUsex := iTimeUsex + (iTimeOff - iTimeOn);
            if (LASTCALLrec.Baud) > 0 then
               tiNew.SubItems.Add(IntToStr(LASTCALLrec.Baud))
             else
               tiNew.SubItems.Add('Local');
            tiNew.SubItems.Add(IntToStr(LASTCALLrec.Times));
          end;
     end;
  FileClose(fhGeneral);
  if (VTRACFGrec.AutoSizeCol) then lstCallers.AutoSizeColumns;
  lstCallers.Items.EndUpdate;
  lblUsed.Caption := TimeTo24HStr(EncodeTime(iTimeUsex div 60,iTimeUsex mod 60,0,0));
  lblBBSCalls.Caption := IntToStr(iBBSCount);
  lblNodeCalls.Caption := Format('%d (%d%%)',[iNodeCount, Round((100 / iBBSCount) * iNodeCount)]);
  if (iNodeCount > 0) then iTimeUsex := iTimeUsex div iNodeCount
                     else iTimeUsex := 0;
  lblAverage.Caption := TimeTo24HStr(EncodeTime(iTimeUsex div 60,iTimeUsex mod 60,0,0));
end;

{ Decide on refresh procedure when tab changes                                 }
procedure TfrmProperties.pag1Change(Sender: TObject);
begin
  if (Pag1.ActivePage = General) then
     if (iNode = 0) then
        RefreshSystem
      else
        RefreshGeneral;
  if (Pag1.ActivePage = Calls)    then RefreshCalls;
  if (Pag1.ActivePage = Log)      then RefreshLog;
  if (Pag1.ActivePage = Info)     then RefreshInfo;
  if (Pag1.ActivePage = Usage)    then RefreshUsage;
  if (Pag1.ActivePage = NewUsers) then RefreshNewUsers;
  if (Pag1.ActivePage = Mailer)   then RefreshMailer;
end;

{ Refresh the "Note" tab                                                       }
procedure TfrmProperties.RefreshInfo;
var
  sMsgFile : String;
  tfMsgFile : TextFile;
  sTempBuf : AnsiString;
  sTempBuf2 : AnsiString;
  dtTempDate : TDateTime;
begin
  memNote.lines.clear;
  sNoteFile := CONFIGrec.SemPath + 'NODE' + IntToStr(iNode) + '.RA';
  if (FileExists(sNoteFile)) then
     begin
       cmdDelete.Enabled := True;
       cmdExport.Enabled := True;
       memNote.Lines.LoadFromFile(sNoteFile);
       memNote.Color := clWindow;
       memNote.Enabled := True;
       lblSentTime.Caption := GetFileDate(sNoteFile);
     end
   else
     begin
       cmdDelete.Enabled := False;
       cmdExport.Enabled := False;
       memNote.Color := clBtnFace;
       memNote.Enabled := False;
       lblSentTime.Caption := '';
     end;

  sMsgFile := Format(CONFIGrec.SysPath + sRealTpl + '\MSGINF',[iNode]);
  if (FileExists(sMsgFile)) then
     begin
       dtTempDate := GetIntFileDate(sMsgFile);
       edtLastTime.Text := DateTimeToStr(dtTempDate) + Elapsed + TimeTo24HStr(Now-dtTempDate) + ')';
       AssignFile(tfMsgFile,sMsgFile);
       Reset(tfMsgFile);
       Readln(tfMsgFile,sTempBuf);
       edtFrom.Text := sTempBuf;
       Readln(tfMsgFile,sTempBuf);
       edtTo.Text := sTempBuf;
       Readln(tfMsgFile,sTempBuf);
       edtSubj.Text := sTempBuf;
       Readln(tfMsgFile,sTempBuf);
       Readln(tfMsgFile,sTempBuf2);
       edtArea.Text := sTempBuf + ' - ' + sTempBuf2;
       Readln(tfMsgFile,sTempBuf);
       edtPriv.Text := sTempBuf[1] + StrLower(@sTempBuf[2]);
       CloseFile(tfMsgFile);
     end
   else
     begin
       edtLastTime.Text := '';
       edtFrom.Text := '';
       edtTo.Text := '';
       edtSubj.Text := '';
       edtArea.Text := '';
       edtPriv.Text := '';
     end;
end;

{ Delete the Note on the "Note" tab                                            }
procedure TfrmProperties.cmdDeleteClick(Sender: TObject);
begin
   if (MessageDlg('Delete this note?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
      begin
        DeleteFile(sNoteFile);
        RefreshInfo;
      end;
end;

{ Export the Note on the "Note" tab                                            }
procedure TfrmProperties.cmdExportClick(Sender: TObject);
begin
  frmMain.dlgSave.Title := 'Export text file';
  frmMain.dlgSave.DefaultExt := '*.TXT';
  frmMain.dlgSave.FileName := '*.TXT';
  frmMain.dlgSave.Filter := 'Text file|*.TXT*.*';
  if (frmMain.dlgSave.Execute) then
     memNote.Lines.SaveToFile(frmMain.dlgSave.Filename);
end;

{ Refresh the "General" tab for BBS object                                     }
procedure TfrmProperties.RefreshSystem;
var
  fhSYSINFO : Integer;
  SYSINFOrec: SYSINFOrecord;
  fhUSERON : Integer;
  iSize : Integer;
  dtLastUse : TDateTime;
begin
  fhSYSINFO := FileOpen(CONFIGrec.SysPath + 'SYSINFO.BBS', fmOpenRead or fmShareDenyNone);
  FileRead(fhSYSINFO,SYSINFOrec,SizeOf(SYSINFOrec));
  FileClose(fhSYSINFO);
  fhUSERON := FileOpen(CONFIGrec.SysPath + 'USERON.BBS', fmOpenRead or fmShareDenyNone);
  iSize := (FileSeek(fhUSERON,0,2) div 214); { SizeOf USERONrec }
  FileClose(fhUSERON);
  if (iSize > frmMain.lstStatus.Items.Count-1) then
     edtNodes.Text := IntToStr(iSize) + ' (Monitor/RA will access ' + IntToStr(frmMain.lstStatus.Items.Count-1) + ')'
   else
     edtNodes.Text := IntToStr(iSize);

  edtBBS.Text := CONFIGrec.SystemName;
  edtSysop.Text := CONFIGrec.Sysop;
  edtSysLoc.Text:= CONFIGrec.Location;
  edtTotCalls.Text := IntToStr(SYSINFOrec.TotalCalls);
  edtLastCall.Text := SYSINFOrec.LastCaller;
  dtLastUse := GetIntFileDate(CONFIGrec.SysPath + 'SYSINFO.BBS');
  edtLastUse.Text := DateTimeToStr(dtLastUse) + Elapsed + TimeTo24HStr(Now - dtLastUse) + ')';

  chkJAMNet.Checked := (FileExists(CONFIGrec.MsgBasePath + 'NETMAIL.JAM'));
  if (chkJAMNet.Checked) then
     chkJAMNet.Hint := 'JAM NetMail' + Outsince + GetFileDate(CONFIGrec.MsgBasePath + 'NETMAIL.JAM') + '|'
   else
     chkJAMNet.Hint := 'No JAM NetMail' + Outstand + '|';
  chkHudNet.Checked := (FileExists(CONFIGrec.MsgBasePath + 'NETMAIL.BBS'));
  if (chkHudNet.Checked) then
     chkHudNet.Hint := 'Hudson NetMail' +Outsince + GetFileDate(CONFIGrec.MsgBasePath + 'NETMAIL.BBS') + '|'
   else
     chkHudNet.Hint := 'No Hudson NetMail' + Outstand + '|';
  chkJAMEcho.Checked := (FileExists(CONFIGrec.MsgBasePath + 'ECHOMAIL.JAM'));
  if (chkJAMEcho.Checked) then
     chkJAMEcho.Hint := 'JAM EchoMail' + Outsince + GetFileDate(CONFIGrec.MsgBasePath + 'ECHOMAIL.JAM') + '|'
  else
     chkJAMEcho.Hint := 'No JAM EchoMail' + Outstand + '|';
  chkHudEcho.Checked := (FileExists(CONFIGrec.MsgBasePath + 'ECHOMAIL.BBS'));
  if (chkHudEcho.Checked) then
     chkHudEcho.Hint := 'Hudson EchoMail' + Outsince + GetFileDate(CONFIGrec.MsgBasePath + 'ECHOMAIL.BBS') + '|'
   else
     chkHudEcho.Hint := 'No Hudson EchoMail' + Outstand + '|';
end;

{ Refresh the "Mew users" tab                                                  }
procedure TfrmProperties.RefreshNewUsers;
var
  LASTCALLrec : LASTCALLrecord;
begin
  lstNewUsers.Items.BeginUpdate;
  lstNewUsers.Items.Clear;
  fhGeneral := FileOpen(CONFIGrec.SysPath + 'LASTCALL.BBS',fmOpenRead or fmShareDenyNone);
  while (FileRead(fhGeneral,LASTCALLrec,SizeOf(LASTCALLrec)) = SizeOf(LASTCALLrec)) do
     if (LASTCALLrec.Times = 1) then
        begin
          tiNew := lstNewUsers.Items.Add;
          tiNew.Caption := LASTCALLrec.Name;
          tiNew.SubItems.Add(LASTCALLrec.City);
          tiNew.SubItems.Add(IntToStr(LASTCALLrec.Baud));
          tiNew.SubItems.Add(IntToStr(LASTCALLrec.Line));
        end;
  FileClose(fhGeneral);
  if (VTRACFGrec.AutoSizeCol) then lstNewUsers.AutoSizeColumns;
  lstNewUsers.Items.EndUpdate;
  lblNewUser.Caption := IntToStr(lstNewUsers.Items.Count);
end;

{ Refresh the "Usage" tab                                                      }
procedure TfrmProperties.RefreshUsage;
var
  fhTIMELOG : Integer;
  TIMELOGrec : TIMELOGrecord;
  iTemp: Integer;
  lTotal,lDays : LongInt;
  dtStartDate: TDateTime;
begin
  for iTemp := 0 to 23 do
      with FindComponent('bar' + IntToStr(iTemp+1)) as TCoolGradient do
           FillPercent := 0;
  lblUse.Caption := '';
  sTIMELOGname := Format(CONFIGrec.SysPath + sRealTpl + '\TIMELOG.BBS',[iNode]);
  if (FileExists(sTIMELOGname)) then
     begin
       fhTIMELOG := FileOpen(sTIMELOGname, fmOpenRead or fmShareDenyNone);
       FileRead(fhTIMELOG,TIMELOGrec,SizeOf(TIMELOGrec));
       FileClose(fhTIMELOG);
     end
   else
     exit;

  dtStartDate := EncodeDate(StrToInt(Copy(TIMELOGrec.StartDate,7,2)) + 1900,
                            StrToInt(Copy(TIMELOGrec.StartDate,1,2)),
                            StrToInt(Copy(TIMELOGrec.StartDate,4,2)));
  lDays := Round((Now - (dtStartDate - 1))*0.60);
  if (lDays = 0) then lDays := 1;
  lTotal := 0;
  for iTemp := 0 to 23 do
      with FindComponent('bar' + IntToStr(iTemp+1)) as TCoolGradient do
         begin
           FillPercent := (TIMELOGrec.BusyPerHour[iTemp] div lDays);
           Hint := IntToStr(TIMELOGrec.BusyPerHour[iTemp]) + ' minutes ('
                 + IntToStr(TIMELOGrec.BusyPerHour[iTemp] div lDays) + '%) usage|';
           lTotal := lTotal + TIMELOGrec.BusyPerHour[iTemp];
         end;
  lblUse.Caption := IntToStr(lTotal div 60) + ' hours, ' +
                    IntToStr(lTotal mod 60) + ' minutes usage since ' +
                    DateToStr(dtStartDate);
end;

{ "Log" tab's right-mouse copy                                                 }
procedure TfrmProperties.itmPopCopyClick(Sender: TObject);
begin
  rchLog.CopyToClipboard;
end;

{ "Log" tab's right-mouse select all                                           }
procedure TfrmProperties.itmPopAllClick(Sender: TObject);
begin
  rchLog.SelectAll;
end;

{ "Log" tab's right-mouse delete log                                           }
procedure TfrmProperties.itmPopDeleteClick(Sender: TObject);
begin
  if (MessageDlg('Delete this log?',mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
     begin
       DeleteFile(txtLogName.Text);
       RefreshLog;
     end;
end;

{-- Right-mouse button to refresh usage and mailer-----------------------}
procedure TfrmProperties.itmResetClick(Sender: TObject);
var
  sMessage : String;
  sFilename : String;
begin
  if (pag1.ActivePage = Usage) then
     begin
       sMessage := 'Reset node usage?';
       sFilename := sTIMELOGname;
     end;
  if (pag1.ActivePage = Mailer) then
     begin
       if (tabMailDir.TabIndex = 0) then
          sMessage := 'Reset inbound history?'
        else
          sMessage := 'Reset outbound history?';
       sFilename := sMailName;
     end;
  if (MessageDlg(sMessage,mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
      begin
        DeleteFile(sFileName);
        pag1Change(Self);
      end;
end;

{ Close & free the form                                                        }
procedure TfrmProperties.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

{ Close the form                                                               }
procedure TfrmProperties.cmdOKClick(Sender: TObject);
begin
  Close;
end;

{ Refresh the "Mailer" tab (InterMail/FrontDoor)                               }
procedure TfrmProperties.RefreshMailer;
var
  sTemp : String;
  iIn,iOut : Integer;
  MCMHISTrec : MCMHISTrecord;
  MAILHISTrec : MAILHISTrecord;
begin
  if (tabMailDir.TabIndex = 0) then
     begin
       sTemp := 'INBOUND.HIS';
       case VTRACFGrec.MailerType of
            2 : if (iNode > 0) then sTemp := 'INB' + IntToStr(iNode) + '.HIS';
            3 : if (iNode > 1) then sTemp := 'INBOUND.' + Format('%.3d',[iNode]);
            4 : if (iNode = 0) then sTemp := 'MCMAIL1.INH'
                               else sTemp := Format('MCMAIL%d.INH',[iNode]);
       end;
     end
   else
     begin
       sTemp := 'OUTBOUND.HIS';
       case VTRACFGrec.MailerType of
            2 : if (iNode > 0) then sTemp := 'OUTB' + IntToStr(iNode) + '.HIS';
            3 : if (iNode > 1) then sTemp := 'OUTBOUND.' + Format('%.3d',[iNode]);
            4 : if (iNode = 0) then sTemp := 'MCMAIL1.OUH'
                               else sTemp := Format('MCMAIL%d.OUH',[iNode]);
       end;
  end;

  fhGeneral := FileOpen(VTRACFGrec.MailerPath + sTemp,fmOpenRead or fmShareDenyNone);
  iOut := 0;
  iIn := 0;
  lstMailer.Items.BeginUpdate;
  lstMailer.Items.Clear;

  if (VTRACFGrec.MailerType = 4) then
     begin
       FileRead(fhGeneral,MCMHISTrec,SizeOf(MCMHISTrec));
       while (FileRead(fhGeneral,MCMHISTrec,SizeOf(MCMHISTrec)) = SizeOf(MCMHISTrec)) do
         begin
           if (VTRACFGrec.ReverseOrder) then
              tiNew := lstMailer.Items.Insert(0)
            else
              tiNew := lstMailer.Items.Add;
           tiNew.Caption := MCMHISTrec.s_Node;
           tiNew.SubItems.Add(MCMHISTrec.s_System);
           tiNew.SubItems.Add(MCMHISTrec.s_Date);
           tiNew.SubItems.Add(MCMHISTrec.s_Start);
           tiNew.SubItems.Add(IntToStr(MCMHISTrec.l_outb div 1024));
           tiNew.SubItems.Add(IntToStr(MCMHISTrec.l_inb div 1024));
           tiNew.SubItems.Add(IntToStr(MCMHISTrec.l_cost));
           iOut := iOut + (MCMHISTrec.l_outb div 1024);
           iIn  := iIn  + (MCMHISTrec.l_inb  div 1024);
         end;
     end
  else
     begin
       FileRead(fhGeneral,MAILHISTrec,SizeOf(MAILHISTrec));
       while (FileRead(fhGeneral,MAILHISTrec,SizeOf(MAILHISTrec)) = sizeof(MAILHISTrec)) do
         begin
           if (VTRACFGrec.ReverseOrder) then
              tiNew := lstMailer.Items.Insert(0)
            else
              tiNew := lstMailer.Items.Add;
           tiNew.Caption := IntToStr(MAILHISTrec.Zone) + ':' + IntToStr(MAILHISTrec.Net)
                            + '/' + IntToStr(MAILHISTrec.Node) + '.' + IntToStr(MAILHISTrec.Point);
           tiNew.SubItems.Add(MAILHISTrec.SystemName);
           tiNew.SubItems.Add(DateToStr(EncodeDate(MAILHISTrec.Year,MAILHISTrec.Month,MAILHISTrec.Day)));
           tiNew.SubItems.Add(TimeToStr(EncodeTime(MAILHISTrec.Hour,MAILHISTrec.Min,MAILHISTrec.Sec,0)));
           tiNew.SubItems.Add(IntToStr(MAILHISTrec.sent_bytes div 1024));
           tiNew.SubItems.Add(IntToStr(MAILHISTrec.rcvd_bytes div 1024));
           tiNew.SubItems.Add(IntToStr(MAILHISTrec.Cost));
           iOut := iOut + (MAILHISTrec.sent_bytes div 1024);
           iIn  := iIn  + (MAILHISTrec.rcvd_bytes div 1024);
         end;
     end;

  FileClose(fhGeneral);
  if (VTRACFGrec.AutoSizeCol) then lstMailer.AutoSizeColumns;
  lstMailer.Items.EndUpdate;
  lblMailCalls.Caption := 'Calls: ' + IntToStr(lstMailer.Items.Count) +
                          '  Out: ' + IntToStr(iOut) +
                          'k  In: ' + IntToStr(iIn) + 'k';
end;

{ Update the inbound/outbound mail info                                        }
procedure TfrmProperties.tabMailDirChange(Sender: TObject);
begin
  RefreshMailer;
end;

procedure TfrmProperties.CustomLoad(Sender : TObject; Node : Integer);
begin
  iNode := Node;
  Show;
end;

procedure TfrmProperties.itmPrintLogClick(Sender: TObject);
begin
  rchLog.Print(txtLogName.Text);
end;

procedure TfrmProperties.lstCallersDblClick(Sender: TObject);
begin
  if (lstCallers.Selected <> nil) then frmMain.LoadUser(lstCallers.Selected.Caption);
end;

procedure TfrmProperties.lstNewUsersDblClick(Sender: TObject);
begin
  if (lstNewUsers.Selected <> nil) then frmMain.LoadUser(lstNewUsers.Selected.Caption);
end;

end.


