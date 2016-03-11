unit sysinfo;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ComCtrls, ExtCtrls;

type
  TfrmSysInfo = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    PageControl1: TPageControl;
    tabGeneral: TTabSheet;
    tabCalls: TTabSheet;
    cmdClose: TButton;
    pnlNode: TPanel;
    imgSys: TImage;
    b1: TBevel;
    lblTotCalls: TLabel;
    edtBBSName: TEdit;
    edtTotCalls: TEdit;
    lblLastCall: TLabel;
    edtLastCall: TEdit;
    lstCallers: TListView;
    lblBBSCalls: TLabel;
    Bevel1: TBevel;
    lblSysop: TLabel;
    edtSysop: TEdit;
    Label1: TLabel;
    lblNodes: TLabel;
    edtLocation: TEdit;
    edtNodes: TEdit;
    procedure FormShow(Sender: TObject);
    procedure cmdCloseClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure LoadGeneral;
    procedure LoadCalls;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSysInfo: TfrmSysInfo;

implementation

uses Main,RA250;

{$R *.DFM}



procedure TfrmSysInfo.FormShow(Sender: TObject);
begin
     LoadGeneral;
end;

procedure TfrmSysInfo.LoadGeneral;
var
     bOldFileMode: Byte;
     SYSINFOfile: file of SYSINFOrecord;
     SYSINFOrec: SYSINFOrecord;
begin
     PageControl1.ActivePage := tabGeneral;
     bOldFileMode := FileMode;
     FileMode := 0;
     AssignFile(SYSINFOfile,CONFIGrec.SysPath + 'SYSINFO.BBS');
     Reset(SYSINFOfile);
     Read(SYSINFOfile,SYSINFOrec);
     edtBBSName.Text := CONFIGrec.SystemName;
     edtSysop.Text := CONFIGrec.Sysop;
     edtLocation.Text:= CONFIGrec.Location;
     edtNodes.Text := IntToStr(frmMain.lstStatus.Items.Count);
     edtTotCalls.Text := IntToStr(SYSINFOrec.TotalCalls);
     edtLastCall.Text := SYSINFOrec.LastCaller;
     CloseFile(SYSINFOfile);
     FileMode := bOldFileMode;
end;

procedure TfrmSysInfo.cmdCloseClick(Sender: TObject);
begin
     frmSysInfo.Close;
end;

procedure TfrmSysInfo.PageControl1Change(Sender: TObject);
begin
     if PageControl1.ActivePage = tabGeneral then LoadGeneral;
     if PageControl1.ActivePage = tabCalls then LoadCalls;
end;

procedure TfrmSysInfo.LoadCalls;
var
    LASTCALLfile : file of LASTCALLrecord;
    LASTCALLrec : LASTCALLrecord;
    OldFileMode : Byte;
    iBBSCount : Integer;
    tlNewItem: TListItem;
begin
    lstCallers.Items.Clear;
    if FileExists(CONFIGrec.SysPath + '\LASTCALL.BBS') then
       begin
        OldFileMode := FileMode;
        FileMode := 0;
        AssignFile(LASTCALLfile,CONFIGrec.SysPath + 'LASTCALL.BBS');
        Reset(LASTCALLfile);
        iBBSCount := 0;
        While not eof (LASTCALLfile) do begin
           Read(LASTCALLfile,LASTCALLrec);
           inc(iBBSCount);
           tlNewItem := lstCallers.Items.Add;
           tlNewItem.Caption := LASTCALLrec.Name;
           tlNewItem.SubItems.Add(IntToStr(LASTCALLrec.Line));
           tlNewItem.SubItems.Add(LASTCALLrec.LogOn);
           tlNewItem.SubItems.Add(LASTCALLrec.LogOff);
           tlNewItem.SubItems.Add(IntToStr(LASTCALLrec.Baud));
           tlNewItem.SubItems.Add(IntToStr(LASTCALLrec.Times));
        end;
        CloseFile(LASTCALLfile);
        lblBBSCalls.Caption := IntToStr(iBBSCount);
        FileMode := OldFileMode;
    end;
end;

end.

