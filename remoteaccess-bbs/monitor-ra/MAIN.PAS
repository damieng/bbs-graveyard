unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Menus, RA250, ExtCtrls, NodeProp, Config, Vtracfg, SendNote,
  Routines, TrayIcon, CRC32c, Buttons, Locale, Userprp, Registry,
  CoolAboutDlg, CoolListView, CoolTipOfTheDay, TB97;

type
  TfrmMain = class(TForm)
    lstStatus: TCoolListView;
    staStatus: TStatusBar;
    mnuMain: TMainMenu;
    itmInfoNode: TMenuItem;
    itmHelp: TMenuItem;
    itmAbout: TMenuItem;
    itmObject: TMenuItem;
    itmClose: TMenuItem;
    itmView: TMenuItem;
    N1: TMenuItem;
    itmLargeIcon: TMenuItem;
    itmSmallIcon: TMenuItem;
    itmDetail: TMenuItem;
    itmRefresh: TMenuItem;
    itmList: TMenuItem;
    itmEdit: TMenuItem;
    itmSelectAll: TMenuItem;
    itmInvert: TMenuItem;
    imlLarge: TImageList;
    mnuPop: TPopupMenu;
    itmPopInfo: TMenuItem;
    itmOptions: TMenuItem;
    tmrRefresh: TTimer;
    dlgOpen: TOpenDialog;
    dlgSave: TSaveDialog;
    popTray: TPopupMenu;
    itmTrayRest: TMenuItem;
    N4: TMenuItem;
    itmTrayProp: TMenuItem;
    itmTrayClose: TMenuItem;
    TrayIcon: TTrayIcon;
    itmStatusBar: TMenuItem;
    itmToolbar: TMenuItem;
    dlgAbout: TCoolAboutDlg;
    N6: TMenuItem;
    N2: TMenuItem;
    itmExit: TMenuItem;
    N7: TMenuItem;
    itmPopSelectAll: TMenuItem;
    itmPopInvert: TMenuItem;
    N8: TMenuItem;
    itmUserView: TMenuItem;
    itmSendNote: TMenuItem;
    itmNoteSend: TMenuItem;
    itmNoteClear: TMenuItem;
    itmLogOff: TMenuItem;
    itmLogOffNormal: TMenuItem;
    itmLogOffShutDown: TMenuItem;
    N3: TMenuItem;
    itmLogOffCancel: TMenuItem;
    N9: TMenuItem;
    itmPopViewUser: TMenuItem;
    itmPopNote: TMenuItem;
    itmPopNoteClear: TMenuItem;
    itmPopNoteSend: TMenuItem;
    itmPopLogOff: TMenuItem;
    itmPopCancel: TMenuItem;
    itmPopLogShutDown: TMenuItem;
    itmPopLogNormal: TMenuItem;
    itmCustom: TMenuItem;
    itmPopCustom: TMenuItem;
    TipDay: TCoolTipOfTheDay;
    itmTip: TMenuItem;
    N5: TMenuItem;
    DockTop: TDock97;
    DockLeft: TDock97;
    DockRight: TDock97;
    DockBottom: TDock97;
    Toolbar: TToolbar97;
    spdProperties: TSpeedButton;
    spdSendNote: TSpeedButton;
    spdUser: TSpeedButton;
    spdLogOff: TSpeedButton;
    spdLargeIcons: TSpeedButton;
    spdSmallIcons: TSpeedButton;
    spdList: TSpeedButton;
    spdDetails: TSpeedButton;
    ToolbarSep971: TToolbarSep97;
    procedure itmLargeIconClick(Sender: TObject);
    procedure itmSmallIconClick(Sender: TObject);
    procedure itmDetailClick(Sender: TObject);
    procedure itmListClick(Sender: TObject);
    procedure itmStatusBarClick(Sender: TObject);
    procedure itmRefreshClick(Sender: TObject);
    procedure itmSelectAllClick(Sender: TObject);
    procedure itmInvertClick(Sender: TObject);
    procedure itmCloseClick(Sender: TObject);
    procedure itmInfoNodeClick(Sender: TObject);
    procedure tmrRefreshTimer(Sender: TObject);
    procedure itmLogOffClick(Sender: TObject);
    procedure itmOptionsClick(Sender: TObject);
    procedure itmAboutClick(Sender: TObject);
    procedure itmNoteSendClick(Sender: TObject);
    procedure itmTrayRestClick(Sender: TObject);
    procedure itmTrayPropClick(Sender: TObject);
    procedure itmTrayCloseClick(Sender: TObject);
    procedure TrayIconDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lstStatusDblClick(Sender: TObject);
    procedure itmToolbarClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure itmPopUserClick(Sender: TObject);
    procedure itmNoteClearClick(Sender: TObject);
    procedure itmLogOffShutDownClick(Sender: TObject);
    procedure itmLogOffCancelClick(Sender: TObject);
    procedure itmCustomClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lstStatusClick(Sender: TObject);
    procedure lstStatusKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure AppMinimize(Sender: TObject);
    procedure lstStatusMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ToolbarVisibleChanged(Sender: TObject);
    procedure itmTipClick(Sender: TObject);
    procedure ToolbarClose(Sender: TObject);
  private
    iStoreSelect: array[0..255] of Boolean;
    iExitNow : Boolean;
    dtLastUpdate : TDateTime;
    procedure DisplayHint(Sender: TObject);
    procedure SetEnabled;
    procedure ReadConfigRA;
    function KeyCheck : Integer;
    function IsBBSSelected : Boolean;
  public
    sBasePath : String;
    Stack : Integer;
    bIsBBSSelected: Boolean;
    procedure ReadVTRAConfig;
    procedure SaveVTRAConfig;
    procedure ExitLevel(iLevel : Integer; sPrefix : String);
    procedure RefreshWindow;
    procedure LoadUser(UserName : String);
end;

var
  frmMain: TfrmMain;
  fhGeneral : Integer;
  iTemp: Integer;
  CONFIGrec: CONFIGrecord;
  KEYrec : KEYFILErecord;
  VTRACFGrec: VTRACFGrecord;
  sRealTpl : String;

const
  StateToImage : array[0..7] of byte = (0,4,3,2,7,6,1,5);

implementation

uses CustErr;

{$R *.DFM}

{ View as Large Icons                                                          }
procedure TfrmMain.itmLargeIconClick(Sender: TObject);
begin
  itmLargeIcon.Checked := True;
  lstStatus.ViewStyle := vsIcon;
  spdLargeIcons.Down := True;
end;

{ View as small icons                                                          }
procedure TfrmMain.itmSmallIconClick(Sender: TObject);
begin
  itmSmallIcon.Checked := True;
  lstStatus.ViewStyle := vsSmallIcon;
  spdSmallIcons.Down := True;
end;

{ View as details                                                              }
procedure TfrmMain.itmDetailClick(Sender: TObject);
begin
  itmDetail.Checked := True;
  lstStatus.ViewStyle := vsReport;
  spdDetails.Down := True;
end;

{ View as list                                                                 }
procedure TfrmMain.itmListClick(Sender: TObject);
begin
  itmList.Checked := True;
  lstStatus.ViewStyle := vsList;
  spdList.Down := True;
end;

{ Status bar toggle                                                            }
procedure TfrmMain.itmStatusBarClick(Sender: TObject);
begin
  itmStatusBar.Checked := not itmStatusBar.Checked;
  staStatus.Visible := itmStatusBar.Checked;
end;

{ Hint handler to handle the menu items                                        }
procedure TfrmMain.DisplayHint(Sender: TObject);
begin
  if (Application.Hint <> '') then
     begin
       staStatus.SimpleText := Application.Hint;
       staStatus.SimplePanel := True;
     end
   else
     begin
       staStatus.SimplePanel := False;
     end;
end;

{ Refresh the main list view window                                            }
procedure TfrmMain.RefreshWindow;
var
  USERONrec: USERONrecord;
  iNodeCounter : Integer;
  tlNewItem : TListItem;
  iOldFocus: integer;
  iInUse : integer;
  dtNewUpdate : TDateTime;
  srSema : TSearchRec;
  Icon : TIcon;
label NextNode,JumpOut,Final;
begin
  iNodeCounter := 0;
  iOldFocus := -1;
  dtNewUpdate := GetIntFileDate(CONFIGrec.SysPath + 'USERON.BBS');

  if (dtLastUpdate = dtNewUpdate) then goto Final;

  dtLastUpdate := dtNewUpdate;
  { Keep selections + focus }
  for iTemp := 1 to lstStatus.Items.Count do
      begin
        iStoreSelect[lstStatus.Items[iTemp-1].StateIndex+1] := lstStatus.Items[iTemp-1].Selected;
        if (lstStatus.Items[iTemp-1].Focused) then iOldFocus := lstStatus.Items[iTemp-1].StateIndex;
      end;

  { Read the file }
  fhGeneral := FileOpen(CONFIGrec.SysPath + 'USERON.BBS', fmOpenRead or fmShareDenyNone);
  lstStatus.Items.BeginUpdate;
  lstStatus.Items.Clear;

  { Add BBS object to listview }
  tlNewItem := lstStatus.Items.Add;
  tlNewItem.Caption := 'BBS';
  tlNewItem.SubItems.Add(CONFIGrec.SystemName);
  tlNewItem.ImageIndex := 12;
  tlNewItem.StateIndex := 0;

  while (FileRead(fhGeneral,USERONrec,SizeOf(USERONrec)) = SizeOf(USERONrec)) do
    begin
      inc(iNodeCounter);
      if (Stack = 0) and (iNodeCounter > 2)  then goto JumpOut; {Unregistered   }
      if (Stack = 1) and (iNodeCounter > 10) then goto JumpOut; {Non-commercial }
      if ((iNodeCounter <> USERONrec.Line) and (VTRACFGrec.IgnoreOffline)) then goto NextNode;
      tlNewItem := lstStatus.Items.Add;
      if (((USERONrec.Attribute and 2) <>0) and (iNodeCounter = USERONrec.Line)) then
         tlNewItem.Caption := Node + ' ' + IntToStr(iNodeCounter) + ' !'
       else
         tlNewItem.Caption := Node + ' ' + IntToStr(iNodeCounter);
      tlNewItem.StateIndex := iNodeCounter;
      {Node is ready for a call}
      if (FileExists(CONFIGrec.SemPath + 'RAREADY.' + IntToStr(iNodeCounter))) then
         begin
           tlNewItem.SubItems.Add('');
           tlNewItem.SubItems.Add('');
           tlNewItem.SubItems.Add(RemoteAccess);
           tlNewItem.SubItems.Add(Ready);
           tlNewItem.ImageIndex := 9;
           goto NextNode
         end;
      {Node is offline}
      if (iNodeCounter <> USERONrec.Line) then
         begin
           tlNewItem.SubItems.Add(Offline);
           tlNewItem.ImageIndex := 8;
           goto NextNode
         end;
      {Node is logging in}
      if (USERONrec.Name = '') then
         begin
           tlNewItem.SubItems.Add('');
           tlNewItem.SubItems.Add('');
           tlNewItem.SubItems.Add('');
           tlNewItem.SubItems.Add(LogIn);
           tlNewItem.ImageIndex := 11;
           goto NextNode
         end;
      tlNewItem.SubItems.Add(USERONrec.Name);
       if (USERONrec.Baud > 0) then
          tlNewItem.SubItems.Add(IntToStr(USERONrec.baud))
        else
          tlNewItem.SubItems.Add(Local);
      tlNewItem.SubItems.Add(USERONrec.City);
      { Now determine node status }
      case USERONrec.Status of
           0..7: begin
                   tlNewItem.SubItems.Add(StateToText[USERONrec.Status]);
                   tlNewItem.ImageIndex := StateToImage[USERONrec.Status];
                 end;
           255 : begin
                   tlNewItem.SubItems.Add(USERONrec.StatDesc);
                   if (USERONrec.StatDesc = Ready) then tlNewItem.ImageIndex := 9
                      else tlNewItem.ImageIndex := 10;
                 end;
      end;
NextNode: end; {while}

JumpOut:
  FileClose(fhGeneral);
  { Restore item selections + focus }
  for iTemp := 1 to lstStatus.Items.Count do
      begin
        lstStatus.Items[iTemp-1].Selected := iStoreSelect[lstStatus.Items[iTemp-1].StateIndex+1];
        if (lstStatus.Items[iTemp-1].StateIndex = iOldFocus) then lstStatus.Items[iTemp-1].Focused := True;
      end;
  lstStatus.Resort;
  if (VTRACFGrec.AutoSizeCol) then lstStatus.AutoSizeColumns;
  lstStatus.Items.EndUpdate;

Final:
  iInUse := 0;
  if (FindFirst(CONFIGrec.SemPath + 'RABUSY.*',faAnyFile,srSema) =0) then
     begin
       iInUse := 1;
       while (FindNext(srSema) =0) do inc(iInUse);
     end;
  FindClose(srSema);

  Icon := TIcon.Create;
  if (lstStatus.Items.Count > 1) then
     Icon.Handle := LoadIcon(HInstance,pchar(format('TRAY%.3d',[(14 div (lstStatus.Items.Count-1) * iInUse)])))
   else
     Icon.Handle := LoadIcon(HInstance,'TRAY000');
  TrayIcon.Icon := Icon;
  Icon.Free;

  TrayIcon.ToolTip := Plaural(iInUse,'user') + ' online';

  if (Stack = 0) then
     staStatus.Panels[1].Text := Unregistered
   else
     staStatus.Panels[1].Text := RefreshedAt + TimeToStr(Now);
end;

{ Forced window refresh                                                        }
procedure TfrmMain.itmRefreshClick(Sender: TObject);
begin
  dtLastUpdate := 0;
  RefreshWindow;
end;

{ Select all objects                                                           }
procedure TfrmMain.itmSelectAllClick(Sender: TObject);
begin
  for iTemp := 0 to (lstStatus.Items.Count - 1) do
      lstStatus.Items[iTemp].Selected := True;
  SetEnabled;
end;

{ Inverse object selections                                                    }
procedure TfrmMain.itmInvertClick(Sender: TObject);
begin
  for iTemp := 0 to (lstStatus.Items.Count - 1) do
      lstStatus.Items[iTemp].Selected := Not lstStatus.Items[iTemp].Selected;
  SetEnabled;
end;

{ Exit application                                                             }
procedure TfrmMain.itmCloseClick(Sender: TObject);
begin
  Close;
end;

{ Display object property sheets                                               }
procedure TfrmMain.itmInfoNodeClick(Sender: TObject);
begin
  for iTemp := 0 to (lstStatus.Items.Count - 1) do
      if (lstStatus.Items[iTemp].Selected) then
         TfrmProperties.Create(Application).CustomLoad(Self,lstStatus.Items[iTemp].StateIndex);
end;

{ Refresh on the timer                                                         }
procedure TfrmMain.tmrRefreshTimer(Sender: TObject);
begin
  if (frmMain.WindowState <> wsMinimized) or (TrayIcon.Active) then RefreshWindow;
end;

{ Log off the selected nodes                                                   }
procedure TfrmMain.itmLogOffClick(Sender: TObject);
begin
  ExitLevel(VTRACFGrec.MainExitLevel,'Log off');
end;

{ Show the configuration form                                                  }
procedure TfrmMain.itmOptionsClick(Sender: TObject);
begin
  TfrmConfig.Create(Application).ShowModal;
  ReadConfigRA;
  dtLastUpdate := 0;
end;

{ Read & apply RemoteAccess' configuration                                     }
procedure TfrmMain.ReadConfigRA;
var
  sConfigRAPath : String;
begin
  if (VTRACFGrec.MainUseEnvir) then
     begin
       sConfigRAPath := DoPath(GetEnvVar('RA'));
       sConfigRAPath := sConfigRAPath + 'CONFIG.RA';
     end
  else
     sConfigRAPath := VTRACFGrec.MainRAPath;

  if (FileExists(sConfigRAPath)) then
     begin
       fhGeneral := FileOpen(sConfigRAPath, fmOpenRead or fmShareDenyNone);
       FileRead(fhGeneral,CONFIGrec,sizeof(CONFIGrec));
       FileClose(fhGeneral);
     end
  else
     begin
       ShowMessage('CONFIG.RA '+ NotFound);
       if (TfrmConfig.Create(Application).ShowModal = mrCancel) then Application.Terminate
          else ReadConfigRA;
     end;
  CONFIGrec.SysPath := DoPath(CONFIGrec.SysPath);
  CONFIGrec.SemPath := DoPath(CONFIGrec.SemPath);
  CONFIGrec.MsgBasePath := DoPath(CONFIGrec.MsgBasePath);
end;

{ Show the about form                                                          }
procedure TfrmMain.itmAboutClick(Sender: TObject);
begin
  case frmMain.Stack of
       0 : dlgAbout.Company := RegisterToday;
       1 : dlgAbout.Company := 'Non-commercial (10 node)';
       2 : dlgAbout.Company := 'Commercial (250 node)';
  end;
  dlgAbout.User := KEYrec.kRegistered;
  dlgAbout.Execute;
end;

{-- Load & apply configuration ------------------------------------------}
procedure TfrmMain.ReadVTRAConfig;
var
  iTemp : Integer;
  Reg : TRegIniFile;
begin
  // Read from the registry
  Reg := TRegIniFile.Create('Software\Envy Technologies\MonitorRA');
  with VTRACFGrec do
    begin
       MonitorRefresh := Reg.ReadInteger('Settings','RefreshInterval',10);
       SaveOnExit := Reg.ReadBool('Settings','SaveConfigOnExit',False);
       IgnoreOffline := Reg.ReadBool('Settings','IgnoreOfflineNodes',False);
       MonitorTray := Reg.ReadBool('Settings','SystemTray',NewStyleControls);
       AutoSizeCol := Reg.ReadBool('Settings','AutoSizeColumnds',False);
       MainUseEnvir := Reg.ReadBool('RA','EnvironmentDetect',False);
       MainRAPath := Reg.ReadString('RA','Configuration','C:\RA\CONFIG.RA');
       MainNodeTpl := Reg.ReadString('RA','NodeTemplate','\NODE*N');
       MainExitLevel := Reg.ReadInteger('RA','LogoffErrorLevel',0);
       ShutdownLevel := Reg.ReadInteger('RA','ShutdownErrorLevel',0);
       MailerPath := Reg.ReadString('Mailer','Path','C:\FD');
       MailerType := Reg.ReadInteger('Mailer','Type',0);
       MailerMulti := Reg.ReadBool('Mailer','Multinode',False);
       ReverseOrder := Reg.ReadBool('Mailer','ReverseOrder',True);
       Height := Reg.ReadInteger('State','WindowHeight',226);
       Width := Reg.ReadInteger('State','WindowWidth',461);
       Top := Reg.ReadInteger('State','WindowTop',157);
       Left := Reg.ReadInteger('State','WindowLeft',230);
       MonitorView := Reg.ReadInteger('State','ViewStyle',3);
       MonitorStatus := Reg.ReadBool('State','StatusBar',True);
    end;

  // Handle not configured yet
  if (Reg.ReadString('RA','Configuration','') = '') then
     begin
       Reg.Free;
       ShowMessage(FirstTime);
       if (TfrmConfig.Create(Application).ShowModal = mrCancel) then
          begin
            iExitNow := True;
            ShowMessage(CancelInstall);
            Exit;
          end;
     end;

  // Adjust config for us
  if (VTRACFGrec.Left + VTRACFGrec.Width > Screen.Width) then
     begin
       VTRACFGrec.Width := 461;
       VTRACFGrec.Left := (Screen.Width div 2) - 230;
     end;
  if (VTRACFGrec.Top + VTRACFGrec.Height > Screen.Height) then
     begin
       VTRACFGrec.Height := 226;
       VTRACFGrec.Top := (Screen.Height div 2) - 113;
     end;
  VTRACFGrec.MainNodeTpl := UpperCase(VTRACFGrec.MainNodeTpl);
  iTemp := Pos('*N',VTRACFGrec.MainNodeTpl);
  if (iTemp > 0) then sRealTpl := Copy(VTRACFGrec.MainNodeTpl,1,iTemp-1) + '%d' +
                                  Copy(VTRACFGrec.MainNodeTpl,iTemp+2,100);

  // Apply config to us
  Left := VTRACFGrec.Left;
  Top := VTRACFGrec.Top;
  Width := VTRACFGrec.Width;
  Height := VTRACFGrec.Height;
  if (Copy(sRealTpl,1,1) = '\') then sRealTpl := Copy(sRealTpl,2,100);
  tmrRefresh.Interval := VTRACFGrec.MonitorRefresh * 1000;
  itmStatusBar.Checked := (VTRACFGrec.MonitorStatus = True);
  staStatus.Visible    := itmStatusBar.Checked;
  TrayIcon.Active      := VTRACFGrec.MonitorTray;
  VTRACFGrec.MailerPath := DoPath(VTRACFGrec.MailerPath);

  // Set view style
  case VTRACFGrec.MonitorView of
       1: itmLargeIconClick(Self);
       2: itmListClick(Self);
       4: itmSmallIconClick(Self);
     else itmDetailClick(Self);
  end;

  ReadCONFIGRA;
  if (KEYrec.kRegistered <> CONFIGrec.Sysop) and (Stack > 0) then
     begin
       ShowMessage('Monitor/RA' + NotThisSysop);
       Stack := 0;
     end;

  RefreshWindow;
  SetEnabled;
end;

{ Enable/disable menus based on selections                                     }
procedure TfrmMain.SetEnabled;
var
  bEnabled : Boolean;
begin
  if (lstStatus.SelCount > 0) then
     begin
       staStatus.Panels[0].Text := Plaural(lstStatus.SelCount,'object') + ' selected';
       bEnabled := True;
     end
  else
     begin
       staStatus.Panels[0].Text := Plaural(lstStatus.Items.Count,'object');
       bEnabled := False;
     end;

  if (bEnabled <> itmInfoNode.Enabled) then
     begin
       itmInfoNode.Enabled := bEnabled;
       itmLogOff.Enabled := bEnabled;
       itmSendNote.Enabled := bEnabled;
       itmUserView.Enabled := bEnabled;
       itmPopInfo.Enabled := bEnabled;
       itmPopLogOff.Enabled := bEnabled;
       itmPopNote.Enabled := bEnabled;
       itmPopViewUser.Enabled := bEnabled;
       spdProperties.Enabled := bEnabled;
       spdLogOff.Enabled := bEnabled;
       spdSendNote.Enabled := bEnabled;
       spdUser.Enabled := bEnabled;
     end;
end;

{ Show the send note form                                                      }
procedure TfrmMain.itmNoteSendClick(Sender: TObject);
begin
  bIsBBSSelected := IsBBSSelected;
  TfrmSendNote.Create(Application).ShowModal;
end;

{ Restore the main window from the system tray                                 }
procedure TfrmMain.itmTrayRestClick(Sender: TObject);
begin
  ShowWindow(Application.Handle,SW_RESTORE);
  SetForegroundWindow(Application.Handle);
end;

{ Show the configuration form from the system tray                             }
procedure TfrmMain.itmTrayPropClick(Sender: TObject);
begin
  TfrmConfig.Create(Application).ShowModal;
  ReadConfigRA;
end;

{ Close the application from the system tray                                   }
procedure TfrmMain.itmTrayCloseClick(Sender: TObject);
begin
  Application.Terminate;
end;

{ Default action for double-clicking on system tray icon                       }
procedure TfrmMain.TrayIconDblClick(Sender: TObject);
begin
  itmTrayRestClick(Sender);
end;

{ Main initialization code                                                     }
procedure TfrmMain.FormCreate(Sender: TObject);
begin
  iExitNow := False;
  FreeLibrary(GetModuleHandle('OleAut32'));
  Application.OnHint := DisplayHint;
  Application.OnMinimize := AppMinimize;
  if (Copy(string(CmdLine),1,1) = '"') then
     sBasePath := Copy(ExtractFilePath(string(CmdLine)),2,255)
   else
     sBasePath := Copy(ExtractFilePath(string(CmdLine)),1,255);

  Stack := KeyCheck;
  ReadVTRAConfig;
  lstStatus.ReadOnly := True;
  if (iExitNow) then Application.Terminate;

  Toolbar.LoadPosition('Software\Envy Technologies\MonitorRA');

  // Initialize array
  for iTemp := 0 to 255 do iStoreSelect[iTemp] := False;
  if (Stack = 0) then
     begin
       ShowMessage(UnregWarn);
       KEYrec.kRegistered := Unregistered;
     end;
  Show;
end;

{ Determine if the 'BBS' object is selected                                    }
function TfrmMain.IsBBSSelected : boolean;
begin
  for iTemp := 0 to (lstStatus.Items.Count - 1) do
      if (lstStatus.Items[iTemp].StateIndex = 0) and
         (lstStatus.Items[iTemp].Selected) then
         begin
           IsBBSSelected := True;
           Exit;
         end;
  IsBBSSelected := False;
end;

{ Registration keyfile check                                                   }
function TfrmMain.KeyCheck : Integer;
begin
  KeyCheck := 0;
  if (not FileExists(sBasePath + 'MONITOR.KEY')) then Exit;
  fhGeneral := FileOpen(sBasePath + 'MONITOR.KEY', fmOpenRead or fmShareDenyNone);
  FileRead(fhGeneral,KEYrec,sizeof(KEYrec));
  FileClose(fhGeneral);

  // Check this is our key
  if (KEYrec.kID <> 'EnvyKey') or (KEYrec.kBlockID = 0) then
     begin
       ShowMessage(KeyNotEnvy);
       Exit;
     end;
  // Failures
  if (CRC32(@KEYrec.kRegSite[1],2,KEYrec.kSerial) <> KEYrec.kSerialChk) or
     (CRC32(@KEYrec.kProduct[1],length(KEYrec.kProduct),KEYrec.kRegisteredC) <> KEYrec.kProdSerial) then
     begin
       ShowMessage(KeyTampered);
       Exit;
    end;
  // Non-commercial licence
  if (CRC32(@KEYrec.kRegistered[1],length(KEYrec.kRegistered),140774) = KEYrec.kRegisteredC) or
     (CRC32(@KEYrec,sizeof(KEYrec)-4,36699) = KEYrec.kBlockID) then
      begin
        KeyCheck := 1;
        Exit;
      end;
  // Commercial licence
  if (CRC32(@KEYrec.kRegistered[1],length(KEYrec.kRegistered),200676) = KEYrec.kRegisteredC) or
     (CRC32(@KEYrec,sizeof(KEYrec)-4,710881) = KEYrec.kBlockID) then
      begin
        KeyCheck := 2;
        Exit;
     end;
  // Corrupted key
  ShowMessage(KeyTampered);
end;


{ Load the object property sheet                                               }
procedure TfrmMain.lstStatusDblClick(Sender: TObject);
begin
  if (lstStatus.Selected <> nil) then
     TfrmProperties.Create(Application).CustomLoad(Self,lstStatus.Selected.StateIndex);
end;

{ Toggle the toolbar                                                           }
procedure TfrmMain.itmToolbarClick(Sender: TObject);
begin
  ToolBar.Visible := not itmToolbar.Checked;
  itmToolbar.Checked := not itmToolbar.Checked;
end;

{ Resize the status bar proportionally                                         }
procedure TfrmMain.FormResize(Sender: TObject);
begin
  staStatus.Panels[0].Width := (staStatus.Width div 15) * 10;
end;

{ Show this user                                                               }
procedure TfrmMain.itmPopUserClick(Sender: TObject);
begin
  LoadUser(lstStatus.Selected.SubItems[0]);
end;

{ Load this users details                                                      }
procedure TfrmMain.LoadUser(UserName : String);
var
  iUser : Integer;
begin
  iUser := FindUser(CONFIGrec.MsgBasePath,UserName);
  if (Stack = 0 ) then
     begin
       ShowMessage(RegOnly + ' Showing Sysop instead.');
       TfrmUser.Create(Application).CustomLoad(Self,1);
     end
    else
      if (iUser > 0) then TfrmUser.Create(Application).CustomLoad(Self,iUser)
                     else ShowMessage(UserLost);
end;

{ Exit custom error level                                                      }
procedure TfrmMain.ExitLevel(iLevel : Integer; sPrefix : String);
begin
  bIsBBSSelected := IsBBSSelected;
  if (bIsBBSSelected) then
     begin
       if (MessageDlg(sPrefix + AllNodes,mtConfirmation, [mbYes,mbNo],0) = mrNo) then Exit;
     end
   else
     if (MessageDlg(sPrefix + SelectedNodes,mtConfirmation,[mbYes,mbNo],0) = mrNo) then Exit;

  for iTemp := 1 to (lstStatus.Items.Count-1) do
      if (lstStatus.Items[iTemp].Selected) or
         (bIsBBSSelected and FileExists(CONFIGrec.SemPath + 'RABUSY.'+IntToStr(iTemp))) then
         begin
           fhGeneral := FileCreate(CONFIGrec.SemPath + 'RAXIT' + IntToStr(lstStatus.Items[iTemp].StateIndex)
                        + '.' + IntToStr(iLevel));
           if (fhGeneral <> -1) then FileClose(fhGeneral);
         end;
end;

{ Clear notes                                                                  }
procedure TfrmMain.itmNoteClearClick(Sender: TObject);
var
  iCount : Integer;
begin
  bIsBBSSelected := IsBBSSelected;
  iCount := 0;
  // Count number of notes
  for iTemp := 1 to (lstStatus.Items.Count - 1) do
      if (lstStatus.Items[iTemp].Selected) or
         (bIsBBSSelected and FileExists(CONFIGrec.SemPath + 'RABUSY.'+IntToStr(iTemp))) then
         if (FileExists(CONFIGrec.SemPath + 'NODE'+IntToStr(lstStatus.Items[iTemp].StateIndex) + '.RA')) then
            inc(iCount);

  if (iCount = 0) then
     ShowMessage('No unread notes to clear.')
   else
     if (MessageDlg('Clear ' + Plaural(iCount,'unread note') + '?',mtConfirmation,[mbYes,mbNo],0) = mrYes) then
        begin
          iCount := 0;
          for iTemp := 1 to (lstStatus.Items.Count - 1) do
              if (lstStatus.Items[iTemp].Selected) or (bIsBBSSelected) then
                 if DeleteFile(CONFIGrec.SemPath + 'NODE'+IntToStr(lstStatus.Items[iTemp].StateIndex) + '.RA') then
                    inc(iCount);
          ShowMessage(Plaural(iCount,'unread note') + ' cleared.');
        end;
end;

{ Shut down selected nodes                                                     }
procedure TfrmMain.itmLogOffShutDownClick(Sender: TObject);
begin
  ExitLevel(VTRACFGrec.ShutdownLevel,'Shut down');
end;

{ Cancel log-off requests on selected nodes                                    }
procedure TfrmMain.itmLogOffCancelClick(Sender: TObject);
var
  iCount : Integer;
  tsExit : TSearchRec;
  iNode : Integer;
begin
  bIsBBSSelected := IsBBSSelected;
  iCount := 0;
  for iTemp := 1 to (lstStatus.Items.Count - 1) do
      if (lstStatus.Items[iTemp].Selected) or (bIsBBSSelected) then
         begin
           iNode := lstStatus.Items[iTemp].StateIndex;
           while (FindFirst(CONFIGrec.SemPath + 'RAXIT' + IntToStr(iNode) + '.*',faAnyFile,tsExit) = 0) do
             begin
               DeleteFile(CONFIGrec.SemPath + tsExit.Name);
               inc(iCount);
             end;
         end;
  ShowMessage(Plaural(iCount,'log-off request') + ' cancelled.');
end;

{ Custom exit level                                                            }
procedure TfrmMain.itmCustomClick(Sender: TObject);
begin
  TfrmCustomErr.Create(Application).ShowModal;
end;

{ Release dynamic objects                                                      }
procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (VTRACFGrec.SaveOnExit) then SaveVTRAConfig;
  Application.OnHint := nil;
end;

{ Set the status of menu options                                               }
procedure TfrmMain.lstStatusClick(Sender: TObject);
begin
  SetEnabled;
end;

{ Set the status of menu options                                               }
procedure TfrmMain.lstStatusKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  SetEnabled;
end;

{ Hide the main form when minimized                                            }
procedure TfrmMain.AppMinimize(Sender: TObject);
begin
  if (VTRACFGrec.MonitorTray) then ShowWindow(Application.Handle,SW_HIDE);
end;

{ Set the status of menu options                                               }
procedure TfrmMain.lstStatusMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SetEnabled;
end;

{ Correct menu option for changing of toolbar                                  }
procedure TfrmMain.ToolbarVisibleChanged(Sender: TObject);
begin
  itmToolbar.Checked := Toolbar.Visible;
end;

{ Save the configuration to the file                                           }
procedure TfrmMain.SaveVTRAConfig;
var
  Reg : TRegIniFile;
begin
  VTRACFGrec.MonitorStatus  := staStatus.Visible;
  VTRACFGrec.Left           := Left;
  VTRACFGrec.Top            := Top;
  VTRACFGrec.Width          := Width;
  VTRACFGrec.Height         := Height;
  case lstStatus.ViewStyle of
       vsIcon :      VTRACFGrec.MonitorView := 1;
       vsList :      VTRACFGrec.MonitorView := 2;
       vsReport :    VTRACFGrec.MonitorView := 3;
       vsSmallIcon : VTRACFGrec.MonitorView := 4;
  end;

  Reg := TRegIniFile.Create('Software\Envy Technologies\MonitorRA');
  with VTRACFGrec do
    begin
      Reg.WriteInteger('Settings','RefreshInterval',MonitorRefresh);
      Reg.WriteBool('Settings','SaveConfigOnExit',SaveOnExit);
      Reg.WriteBool('Settings','IgnoreOfflineNodes',IgnoreOffline);
      Reg.WriteBool('Settings','SystemTray',MonitorTray);
      Reg.WriteBool('Settings','AutoSizeColumnds',AutoSizeCol);
      Reg.WriteBool('RA','EnvironmentDetect',MainUseEnvir);
      Reg.WriteString('RA','Configuration',MainRAPath);
      Reg.WriteString('RA','NodeTemplate',MainNodeTpl);
      Reg.WriteInteger('RA','LogoffErrorLevel',MainExitLevel);
      Reg.WriteInteger('RA','ShutdownErrorLevel',ShutdownLevel);
      Reg.WriteString('Mailer','Path',MailerPath);
      Reg.WriteInteger('Mailer','Type',MailerType);
      Reg.WriteBool('Mailer','Multinode',MailerMulti);
      Reg.WriteBool('Mailer','ReverseOrder',ReverseOrder);
      Reg.WriteInteger('State','WindowHeight',Height);
      Reg.WriteInteger('State','WindowWidth',Width);
      Reg.WriteInteger('State','WindowTop',Top);
      Reg.WriteInteger('State','WindowLeft',Left);
      Reg.WriteInteger('State','ViewStyle',MonitorView);
      Reg.WriteBool('State','StatusBar',MonitorStatus );
    end;
  Reg.Free;
  Toolbar.SavePosition('Software\Envy Technologies\MonitorRA');
end;

procedure TfrmMain.itmTipClick(Sender: TObject);
begin
  TipDay.Show;
end;

procedure TfrmMain.ToolbarClose(Sender: TObject);
begin
  itmToolbar.Checked := False;
end;

end.
