unit config;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ComCtrls, ExtCtrls, Mask, Dialogs, CoolCheckBox;

type
  TfrmConfig = class(TForm)
    p1:           TPanel;
    p2:           TPanel;
    cmdOK:        TButton;
    cmdCancel:    TButton;
    pag1:         TPageControl;
    tabGeneral:   TTabSheet;
    lNTP: TLabel;
    edtNodeTemplate: TEdit;
    p4:           TPanel;
    lTH: TLabel;
    b2:           TBevel;
    lRE: TLabel;
    udRefresh:    TUpDown;
    lSE: TLabel;
    edtRefresh:   TMaskEdit;
    chkTray:      TCheckBox;
    tabMailer: TTabSheet;
    lHD: TLabel;
    edtMailPath: TEdit;
    cboMailType: TComboBox;
    lMT: TLabel;
    chkMailMulti: TCoolCheckBox;
    chkAutoSize: TCheckBox;
    tabRA: TTabSheet;
    p3: TPanel;
    edtSysPath: TEdit;
    cmdPath: TButton;
    optPathVar: TRadioButton;
    optPathSet: TRadioButton;
    lRAP: TLabel;
    lER: TLabel;
    edtErrorLevel: TMaskEdit;
    udError: TUpDown;
    lblTerminat: TLabel;
    edtTerminate: TMaskEdit;
    udTerminate: TUpDown;
    b1: TBevel;
    chkReverse: TCheckBox;
    chkSaveOnExit: TCheckBox;
    chkIgnoreOffline: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure optPathSetClick(Sender: TObject);
    procedure cmdPathClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cmdCancelClick(Sender: TObject);
    procedure cboMailTypeChange(Sender: TObject);
  end;

var
  frmConfig: TfrmConfig;

implementation

Uses Main;

{$R *.DFM}

{ Initialize the form & set parameters                                         }
procedure TfrmConfig.FormShow(Sender: TObject);
begin
  pag1.ActivePage := tabGeneral;
  { General tab }
  edtNodeTemplate.Text  := VTRACFGrec.MainNodeTpl;
  udRefresh.Position    := VTRACFGrec.MonitorRefresh;
  chkTray.Checked       := VTRACFGrec.MonitorTray;
  chkAutoSize.Checked   := VTRACFGrec.AutoSizeCol;
  chkSaveOnExit.Checked := VTRACFGrec.SaveOnExit;
  chkIgnoreOffline.Checked := VTRACFGrec.IgnoreOffline;
  { RA tab }
  optPathVar.Checked    := (VTRACFGrec.MainUseEnvir = True);
  optPathSet.Checked    := (VTRACFGrec.MainUseEnvir = False);
  edtSysPath.Text       := VTRACFGrec.MainRAPath;
  udError.Position      := VTRACFGrec.MainExitLevel;
  udTerminate.Position  := VTRACFGrec.ShutdownLevel;
  { Mailer tab }
  edtMailPath.Text      := VTRACFGrec.MailerPath;
  cboMailType.ItemIndex := VTRACFGrec.MailerType;
  chkMailMulti.Checked  := VTRACFGrec.MailerMulti;
  chkReverse.Checked    := VTRACFGrec.ReverseOrder;
end;

{ Save the configuration                                                       }
procedure TfrmConfig.cmdOKClick(Sender: TObject);
begin
  { General tab }
  VTRACFGrec.MainNodeTpl    := edtNodeTemplate.Text;
  VTRACFGrec.MonitorRefresh := udRefresh.Position;
  VTRACFGrec.MonitorTray    := chkTray.Checked;
  VTRACFGrec.AutoSizeCol    := chkAutoSize.Checked;
  VTRACFGrec.SaveOnExit     := chkSaveOnExit.Checked;
  VTRACFGrec.IgnoreOffline  := chkIgnoreOffline.Checked;
  { RA tab}
  VTRACFGrec.MainUseEnvir   := optPathVar.Checked;
  VTRACFGrec.MainRAPath     := edtSysPath.Text;
  VTRACFGrec.MainExitLevel  := udError.Position;
  VTRACFGrec.ShutdownLevel  := udTerminate.Position;
  { Mailer tab }
  VTRACFGrec.MailerPath     := edtMailPath.Text;
  VTRACFGrec.MailerType     := cboMailType.ItemIndex;
  VTRACFGrec.MailerMulti    := chkMailMulti.Checked;
  VTRACFGrec.ReverseOrder   := chkReverse.Checked;
  frmMain.SaveVTRAConfig;
  frmMain.ReadVTRAConfig;
  Close;
end;

{ Set edit box depending on option                                             }
procedure TfrmConfig.optPathSetClick(Sender: TObject);
begin
  edtSysPath.Enabled := (optPathSet.Checked);
  cmdPath.Enabled    := (optPathSet.Checked);
end;

{ Manual path search command                                                   }
procedure TfrmConfig.cmdPathClick(Sender: TObject);
begin
  frmMain.dlgOpen.Title := 'Select CONFIG.RA to use';
  frmMain.dlgOpen.DefaultExt := '*.RA';
  if (edtSysPath.Text <> '') then
     begin
       frmMain.dlgOpen.InitialDir := ExtractFileDir(edtSysPath.Text);
       frmMain.dlgOpen.FileName   := ExtractFileName(edtSysPath.Text);
     end;
  frmMain.dlgOpen.Filter := 'RA Configuration|CONFIG.RA|All files|*.*';
  if (frmMain.dlgOpen.Execute) then
     edtSysPath.Text := frmMain.dlgOpen.Filename;
end;

{ Release the form & memory                                                    }
procedure TfrmConfig.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

{ Close form without saving changes                                            }
procedure TfrmConfig.cmdCancelClick(Sender: TObject);
begin
  Close;
end;

{ Ensure FrontDoor 2.02 is not running multinode :-)                           }
procedure TfrmConfig.cboMailTypeChange(Sender: TObject);
begin
  if (cboMailType.ItemIndex < 2) then
     begin
       chkMailMulti.Checked := False;
       chkMailMulti.ReadOnly := True;
     end
   else
     chkMailMulti.ReadOnly := False;
end;
end.

