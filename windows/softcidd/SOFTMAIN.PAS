unit softmain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, XToolBar, Menus, Buttons, CoolListView,
  About, CoolApplication, Options, ATComm32;

type
  TMainForm = class(TForm)
    MainMenu: TMainMenu;
    FileCourse: TMenuItem;
    ViewCourse: TMenuItem;
    HelpCourse: TMenuItem;
    ContentsItem: TMenuItem;
    N1: TMenuItem;
    AboutItem: TMenuItem;
    StatusBar: TStatusBar;
    DockTop: TDocks;
    DockLeft: TDocks;
    DockRight: TDocks;
    DockBottom: TDocks;
    pnlLeft: TPanel;
    Splitter1: TSplitter;
    pnlRight: TPanel;
    TreeView: TTreeView;
    pnlTitleL: TPanel;
    ListView: TCoolListView;
    pnlTitleR: TPanel;
    ExitItem: TMenuItem;
    ToolbarItem: TMenuItem;
    StatusBarItem: TMenuItem;
    N2: TMenuItem;
    LargeIconsItem: TMenuItem;
    SmallIconsItem: TMenuItem;
    ListItem: TMenuItem;
    DetailsItem: TMenuItem;
    N3: TMenuItem;
    RefreshItem: TMenuItem;
    OptionsItem: TMenuItem;
    ToolsCourse: TMenuItem;
    DatabaseItem: TMenuItem;
    ExportItem: TMenuItem;
    N4: TMenuItem;
    ClearItem: TMenuItem;
    ToolMain: TXToolBar;
    BtnExport: TSpeedButton;
    BtnClear: TSpeedButton;
    BtnLargeIcons: TSpeedButton;
    BtnList: TSpeedButton;
    BtnSmallIcons: TSpeedButton;
    BtnDetails: TSpeedButton;
    BtnRefresh: TSpeedButton;
    BtnOptions: TSpeedButton;
    BtnDatabase: TSpeedButton;
    BtnHelp: TSpeedButton;
    CoolApplication1: TCoolApplication;
    Comm: T_ATComm32;
    ActiveItem: TMenuItem;
    N5: TMenuItem;
    Timer1: TTimer;
    procedure LargeIconsItemClick(Sender: TObject);
    procedure SmallIconsItemClick(Sender: TObject);
    procedure ListItemClick(Sender: TObject);
    procedure DetailsItemClick(Sender: TObject);
    procedure ExitItemClick(Sender: TObject);
    procedure ToolMainVisibleChanged(Sender: TObject);
    procedure ToolbarItemClick(Sender: TObject);
    procedure StatusBarItemClick(Sender: TObject);
    procedure RefreshItemClick(Sender: TObject);
    procedure TreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure FormCreate(Sender: TObject);
    procedure AboutItemClick(Sender: TObject);
    procedure CoolApplication1Hint(Sender: TObject);
    procedure OptionsItemClick(Sender: TObject);
    procedure ActiveItemClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure PreparePort;
    procedure ProcessData;
    function WriteOKCmd(Cmd: string): string;
    function StripCmd(Cmd: string): string;
  public
    sCurrentFile: String;
    sPath: String;
    Port: Integer;
    procedure RefreshTree;
    procedure RefreshList;
  end;

type
  LogStruct = record
    CTime: TDateTime;
    CNumb: String[50];
  end;

var
  MainForm: TMainForm;
  Response: TStringList;

implementation

{$R *.DFM}

procedure TMainForm.LargeIconsItemClick(Sender: TObject);
begin
  ListView.ViewStyle := vsIcon;
  LargeIconsItem.Checked := True;
  BtnLargeIcons.Down := True;
end;

procedure TMainForm.SmallIconsItemClick(Sender: TObject);
begin
  ListView.ViewStyle := vsSmallIcon;
  SmallIconsItem.Checked := True;
  BtnSmallIcons.Down := True;
end;

procedure TMainForm.ListItemClick(Sender: TObject);
begin
  ListView.ViewStyle := vsList;
  ListItem.Checked := True;
  BtnList.Down := True;
end;

procedure TMainForm.DetailsItemClick(Sender: TObject);
begin
  ListView.ViewStyle := vsReport;
  DetailsItem.Checked := True;
  BtnDetails.Down := True;
end;

procedure TMainForm.ExitItemClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TMainForm.ToolMainVisibleChanged(Sender: TObject);
begin
  ToolbarItem.Checked := ToolMain.Visible;
end;

procedure TMainForm.ToolbarItemClick(Sender: TObject);
begin
  ToolMain.Visible := not ToolbarItem.Checked;
end;

procedure TMainForm.StatusBarItemClick(Sender: TObject);
begin
  StatusBarItem.Checked := not StatusBarItem.Checked;
  StatusBar.Visible := StatusBarItem.Checked;
end;

procedure TMainForm.RefreshTree;
var
  sFiles: String;
  SearchRec: TSearchRec;
  Found: Integer;
  DateNode: TTreeNode;
  sDate: String;
begin
  TreeView.Items.BeginUpdate;
  TreeView.Items.Clear;
  sFiles := sPath + '*.CIL';
  DateNode := TreeView.Items.AddFirst(nil, 'By date');
  Found := FindFirst(sFiles, faAnyFile, SearchRec);
  while Found = 0 do
    begin
      sDate := Copy(SearchRec.Name, 0, 4) + '/' +
               Copy(SearchRec.Name, 5, 2) + '/' +
               Copy(SearchRec.Name, 7, 2);
      TreeView.Items.AddChild(DateNode, sDate);
      Found := FindNext(SearchRec);
    end;
  FindClose(SearchRec);
  DateNode.Expanded := True;
  TreeView.Items.EndUpdate;
end;

procedure TMainForm.RefreshItemClick(Sender: TObject);
begin
  RefreshTree;
end;

procedure TMainForm.TreeViewChange(Sender: TObject; Node: TTreeNode);
var
  sTempName: String;
begin
  if (TreeView.Selected <> nil) then
     begin
       sTempName := TreeView.Selected.Text;
       sCurrentFile := Copy(sTempName,0,4) + Copy(sTempName, 6, 2) + Copy(sTempName, 9, 2) + '.CIL';
       if (not FileExists(sPath + sCurrentFile)) then
          begin
            sCurrentFile := '';
            pnlTitleR.Caption := '';
          end
        else
          pnlTitleR.Caption := 'Contents of ''' + sTempName + '''';
       RefreshList;
     end;
end;

procedure TMainForm.RefreshList;
var
  hFile: Integer;
  rCall: LogStruct;
  liNew: TListItem;
  CallCount: Integer;
begin
  ListView.Items.BeginUpdate;
  ListView.Items.Clear;

  hFile := FileOpen(sPath + sCurrentFile, fmOpenRead or fmShareDenyNone);
  CallCount := 0;
  while FileRead(hFile, rCall, SizeOf(rCall)) = SizeOf(rCall) do
    begin
      inc(CallCount);
      liNew := ListView.Items.Add;
      liNew.Caption := TimeToStr(rCall.CTime);
      liNew.SubItems.Add(rCall.CNumb);
    end;

  ListView.Items.EndUpdate;
  StatusBar.Panels[1].Text := IntToStr(CallCount)  + ' calls';
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  sPath := ExtractFilePath(ParamStr(0));
  Response := TStringList.Create;
  RefreshTree;
end;

procedure TMainForm.AboutItemClick(Sender: TObject);
begin
  TFormAbout.Create(Application).ShowModal;
end;

procedure TMainForm.CoolApplication1Hint(Sender: TObject);
begin
  if (Application.Hint = '') then
     begin
       StatusBar.SimplePanel := False;
       StatusBar.SimpleText := '';
     end
   else
     begin
       StatusBar.SimpleText := Application.Hint;
       StatusBar.SimplePanel := True;
     end;
end;

procedure TMainForm.OptionsItemClick(Sender: TObject);
begin
  TOptionsForm.Create(Application).ShowModal;
end;

procedure TMainForm.PreparePort;
begin
  Comm.Port := Port;
  Comm.Open;
  Comm.EndOfResponse := #13#10;
  Comm.Flush;
end;

function TMainForm.WriteOKCmd(Cmd: String): String;
begin
  Comm.Write(Cmd + #13#10);
  Result := StripCmd(Comm.Read);
  if (Result <> 'OK') then
     ShowMessage('Command ' + cmd + ' did not OK');
end;

function TMainForm.StripCmd(Cmd: string): string;
var
  Collect: Boolean;
  Index: Integer;
  Chr: string;
begin
  Result := '';
  Collect := True;
  for Index := 0 to Length(Cmd)-1 do
      begin
        Chr := Copy(Cmd, Index, 1);
        if (Chr = #13) then Collect := False;
        if (Collect) then Result := Result + Chr;
        if (Chr = #10) then Collect := True;
      end;
end;

procedure TMainForm.ActiveItemClick(Sender: TObject);
begin
  ActiveItem.Checked := not ActiveItem.Checked;
  if (ActiveItem.Checked) then
     begin
       StatusBar.Panels[3].Text := 'Initializing';
       if (not Comm.IsOpen) then
          begin
            Port := 2;
            PreparePort;
            WriteOKCmd('ATE0');
            if (WriteOKCmd('AT') <> 'OK') then
               begin
                 StatusBar.Panels[3].Text := 'Inactive';
                 Comm.Close;
                 Exit;
               end;
            WriteOKCmd('AT%CCID=1');
          end;
       Timer1.Enabled := True;
       StatusBar.Panels[3].Text := 'Active';
     end
   else
     begin
       StatusBar.Panels[3].Text := 'Inactive';
       Timer1.Enabled := False;
       if (Comm.IsOpen) then Comm.Close;
     end;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  if (Comm.IsOpen) then
     if (Comm.InCount > 0) then Response.Text := Response.Text + Comm.Read;
  if (Length(Response.Text) > 0) then ProcessData;
  Application.ProcessMessages;
end;

procedure TMainForm.ProcessData;
var
  Index: Integer;
  liNew: TListItem;
begin
  while (Response.Count > 0) do
    begin
      if (Copy(Response[0], 0, 4) = 'CALR') then
         begin
           liNew := ListView.Items.Add;
           liNew.Caption := TimeToStr(Time);
           liNew.SubItems.Add(Copy(Response[0], 8, 255));
         end;
      Response.Delete(0);
    end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Response.Free;
end;

end.
