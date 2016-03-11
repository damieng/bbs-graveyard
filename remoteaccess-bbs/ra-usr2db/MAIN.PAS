unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, envydcp1, SQL, SQLext, ExtCtrls, RA250;

type
  TfrmMain = class(TForm)
    page: TPageControl;
    tab1: TTabSheet;
    lTI: TLabel;
    cmdFinish: TButton;
    cmdNext: TButton;
    cmdPrevious: TButton;
    Label1: TLabel;
    lWE: TLabel;
    lblWe: TLabel;
    lB4: TLabel;
    lblB4: TLabel;
    lRQ: TLabel;
    lblRq: TLabel;
    tab2: TTabSheet;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edtFileName: TEdit;
    cmdBrowse: TButton;
    cmdExamine: TButton;
    tab3: TTabSheet;
    Label5: TLabel;
    Label6: TLabel;
    lstFields: TCoolListView;
    cmdAll: TButton;
    cmdNone: TButton;
    cmdInvert: TButton;
    imlFields: TImageList;
    tab4: TTabSheet;
    Label7: TLabel;
    Label8: TLabel;
    lstDSN: TCoolListView;
    tab5: TTabSheet;
    lNA: TLabel;
    lblNA: TLabel;
    lTA: TLabel;
    edtTable: TEdit;
    tab6: TTabSheet;
    Label9: TLabel;
    pnlStatus: TPanel;
    barStatus: TProgressBar;
    lTable: TLabel;
    lConnect: TLabel;
    lAlloc: TLabel;
    lExport: TLabel;
    lDisconnect: TLabel;
    lRelease: TLabel;
    lblStatus: TLabel;
    lDSN: TLabel;
    lblDSN: TLabel;
    dlgOpen: TOpenDialog;
    lcAlloc: TLabel;
    lcConnect: TLabel;
    lcCreate: TLabel;
    lcExport: TLabel;
    lcDiscon: TLabel;
    lcRelease: TLabel;
    procedure cmdAllClick(Sender: TObject);
    procedure cmdNoneClick(Sender: TObject);
    procedure cmdInvertClick(Sender: TObject);
    procedure cmdPreviousClick(Sender: TObject);
    procedure cmdNextClick(Sender: TObject);
    procedure lstFieldsDblClick(Sender: TObject);
    procedure cmdFinishClick(Sender: TObject);
    procedure lstDSNClick(Sender: TObject);
    procedure cmdBrowseClick(Sender: TObject);
  private
    procedure RefreshDSN;
    procedure Process;
    procedure RefreshProcess;
    procedure WriteODBCRec;
  public
    { Public declarations }
  end;

const
     sField : array[1..40] of String = (
               'Record','Name','Location','Address1','Address2','Address3','Handle','Comment',
               'PasswordCRC','DataPhone','VoicePhone','LastCall','','Credit','Pending',
               'MsgPosted','Security','Calls','UploadFiles','UploadKb','DownloadFiles','DownloadKb',
               'TodayKb','Elapsed','ScreenLength','LastPassChange','GroupName','FirstCall',
               'Birthdate','SubsExpire','Language','DateFormat','ForwardTo','MessageArea',
               'MessageGroup','FileArea','FileGroup','Protocol','LastDOBCheck','Gender');
     sType : array[1..40] of String = (
               'LONG','TEXT','TEXT','TEXT','TEXT','TEXT','TEXT','TEXT',
               'LONG','TEXT','TEXT','DATETIME','','LONG','LONG',
               'LONG','LONG','LONG','LONG','LONG','LONG','LONG',
               'LONG','LONG','LONG','BYTE','LONG','DATETIME',
               'DATETIME','DATETIME','BYTE','TEXT','TEXT','LONG',
               'LONG','LONG','LONG','CHAR','LONG','CHAR');
     qt = '''';

var
  frmMain: TfrmMain;
  iTemp : Integer;
  fhndUSER : Integer;
  USERSrec : USERSrecord;
  szDSN : PAnsiChar;
  szUID : PAnsiChar;
  szAuthStr : PAnsiChar;
  szSQL : PAnsiChar;
  sSQL    : String;
  env : HENV;
  dbc : HDBC;
  stmt : HSTMT;
  fFields : Array[1..45] of boolean;

implementation

{$R *.DFM}

procedure TfrmMain.cmdAllClick(Sender: TObject);
begin
     for iTemp := 0 to lstFields.Items.Count-1 do
         lstFields.Items[iTemp].ImageIndex := 0;
end;

procedure TfrmMain.cmdNoneClick(Sender: TObject);
begin
     for iTemp := 0 to lstFields.Items.Count-1 do
         lstFields.Items[iTemp].ImageIndex := 1;
end;

procedure TfrmMain.cmdInvertClick(Sender: TObject);
begin
     for iTemp := 0 to lstFields.Items.Count-1 do
         if (lstFields.Items[iTemp].ImageIndex = 0) then
            lstFields.Items[iTemp].ImageIndex := 1
          else
            lstFields.Items[iTemp].ImageIndex := 0;
end;

procedure TfrmMain.cmdPreviousClick(Sender: TObject);
begin
     if (page.ActivePage = tab2) then page.ActivePage := tab1;
     if (page.ActivePage = tab3) then page.ActivePage := tab2;
     if (page.ActivePage = tab4) then page.ActivePage := tab3;
     if (page.ActivePage = tab5) then page.ActivePage := tab4;
     if (page.ActivePage = tab6) then page.ActivePage := tab5;

     cmdPrevious.Enabled := (page.ActivePage <> tab1);
     if (page.ActivePage = tab4) then RefreshDSN;
     if (page.ActivePage = tab5) then begin
        cmdNext.Caption := 'Next >';
        cmdNext.Enabled := True;
     end;
end;

procedure TfrmMain.cmdNextClick(Sender: TObject);
begin
     if (page.ActivePage = tab5) then
        if (edtTable.Text = '') then
            ShowMessage('You must enter a table name')
         else
            page.ActivePage := tab6;

     if (page.ActivePage = tab4) then
        if (lblDSN.Caption = '') then
           ShowMessage('You must select a Data Source')
         else
           page.ActivePage := tab5;

     if (page.ActivePage = tab3) then
         page.ActivePage := tab4;

     if (page.ActivePage = tab2) then
         if (FileExists(edtFileName.Text)) then
            page.ActivePage := tab3
          else
            ShowMessage('File can not be found');

     if (page.ActivePage = tab1) then page.ActivePage := tab2;

     cmdPrevious.Enabled := (page.ActivePage <> tab1);
     if (page.ActivePage = tab4) then RefreshDSN;
     if (page.ActivePage = tab5) then cmdNext.Caption := 'Start >';
     if (page.ActivePage = tab6) then
        begin
          RefreshProcess;
          Process;
        end;
end;

procedure TfrmMain.lstFieldsDblClick(Sender: TObject);
begin
     if (lstFields.Selected <> nil) then
        if (lstFields.Selected.ImageIndex = 0) then
           lstFields.Selected.ImageIndex := 1
         else
           lstFields.Selected.ImageIndex := 0;
end;

procedure TfrmMain.RefreshDSN;
var
   szDSN : PChar;
   cbDSN : SWORD;
   szDescription : PChar;
   cbDescription : SWORD;
   env : HENV;
   liNew : TListItem;
begin
     SQLAllocEnv(env);
     GetMem(szDSN,SQL_MAX_DSN_LENGTH + 1);
     GetMem(szDescription,255);
     lstDSN.Items.Clear;
     SQLDataSources(env,SQL_FETCH_FIRST,szDSN,SQL_MAX_DSN_LENGTH+1,cbDSN,szDescription,255,cbDescription);
     liNew := lstDSN.Items.Add;
     liNew.Caption := szDSN;
     liNew.SubItems.Add(szDescription);
     while (SQLDataSources(env,SQL_FETCH_NEXT,szDSN,SQL_MAX_DSN_LENGTH+1,cbDSN,szDescription,255,cbDescription) =0 ) do
           begin
             liNew := lstDSN.Items.Add;
             liNew.Caption := szDSN;
             liNew.SubItems.Add(szDescription);
           end;
     SQLFreeEnv(env);
     FreeMem(szDSN);
     FreeMem(szDescription);
end;

procedure TfrmMain.cmdFinishClick(Sender: TObject);
begin
     if (MessageDlg('Exit RAUSR2DB?',mtConfirmation,[mbYes,mbNo],0) = mrYes) then
        Application.Terminate;
end;

procedure TfrmMain.lstDSNClick(Sender: TObject);
begin
     if (lstDSN.Selected <> nil) then
         lblDSN.Caption := lstDSN.Selected.Caption;
end;

procedure TfrmMain.Process;
var
   sTemp : String;
label AlEnv, AlCon, Connect, Disconnect, FrCon, FrEnv, Leave;
begin

   cmdNext.Enabled := False;
   Screen.Cursor := crHourglass;

AlEnv: { Allocate SQL environment ---------------------------------------------}
   lAlloc.Font.Color := clBlack;
   Self.Update;
   if (SQLAllocEnv(env) <> SQL_SUCCESS) then
      begin
        lcAlloc.Caption := #251;
        lcAlloc.Font.Color := clRed;
        goto Leave;
      end;

AlCon: { Allocate SQL connection ----------------------------------------------}
   Self.Update;
   if (SQLAllocConnect(env,dbc) <> SQL_SUCCESS) then
      begin
        lcAlloc.Caption := #251;
        lcAlloc.Font.Color := clRed;
        goto FrEnv;
      end;

   lcAlloc.Caption := #252;
   lcAlloc.Font.Color := clGreen;

Connect: { Connect to Data Source ---------------------------------------------}
   lConnect.Font.Color := clBlack;
   Self.Update;
   szDSN := PChar(lblDSN.Caption);
   szUID := '';
   szAuthStr := '';
   if (SQLConnect(dbc,szDSN,strlen(szDSN),szUID,0,szAuthStr,0) <> SQL_SUCCESS) then
      begin
        lcConnect.Caption := #251;
        lcConnect.Font.Color := clRed;
        goto FrCon;
      end;
   lcConnect.Caption := #252;
   lcConnect.Font.Color := clGreen;

{-- Decide on fields to export ----------------------------------------------------}

for iTemp := 0 to lstFields.Items.Count-1 do
    with lstFields.Items[iTemp] do
    if (ImageIndex = 0) then
        fFields[StateIndex] := True
      else
        fFields[StateIndex] := False;

{-- Create the table --------------------------------------------------------------}

   lTable.Font.Color := clBlack;
   Self.Update;
   sSQL := 'CREATE TABLE [' + edtTable.Text + '] (';
   for iTemp := 1 to lstFields.Items.Count do
       if fFields[iTemp] then
          begin
            sTemp := '[' + sField[iTemp] + '] ' + sType[iTemp];
            sSQL := sSQL + sTemp + ',';
          end;
   sSQL[Length(sSQL)] := ')';
   ShowMessage(sSQL);
   szSQL := PChar(sSQL);

   SQLAllocStmt(dbc,stmt);
   if (SQLExecDirect(stmt,szSql,strlen(szSql)) <> SQL_SUCCESS) then
      begin
        lcCreate.Caption := #251;
        lcCreate.Font.Color := clRed;
        goto Disconnect;
      end;
    lcCreate.Caption := #252;
    lcCreate.Font.Color := clGreen;


{-- Process the userbase ----------------------------------------------------------}

   lExport.Font.Color := clBlack;
   Self.Update;
   fhndUSER := FileOpen(edtFileName.Text,fmOpenRead or fmShareDenyNone);
   barStatus.Max := FileSeek(fhndUSER,0,2) div SizeOf(USERSrec);
   FileSeek(fhndUSER,0,0);
   while (FileRead(fhndUSER,USERSrec,SizeOf(USERSrec)) = SizeOf(USERSrec)) do
      begin
         barStatus.Position := FileSeek(fhndUSER,0,1) div SizeOf(USERSrec);
         WriteODBCRec;
      end;
   FileClose(fhndUSER);
   SQLFreeStmt(stmt,SQL_DROP);
   lcExport.Caption := #252;
   lcExport.Font.Color := clGreen;

{----------------------------------------------------------------------------------}

Disconnect: { Disconnect from ODBC --------------------------------------------}
   lDisconnect.Font.Color := clBlack;
   Self.Update;
   if (SQLDisconnect(dbc) <> SQL_SUCCESS) then
      begin
        lcDiscon.Caption := #251;
        lcDiscon.Font.Color := clRed;
        goto FrCon;
      end;
   lcDiscon.Caption := #252;
   lcDiscon.Font.Color := clGreen;

FrCon: { Free ODBC connection -------------------------------------------------}
   lRelease.Font.Color := clBlack;
   Self.Update;
   if (SQLFreeConnect(dbc) <> SQL_SUCCESS) then
      begin
        lcRelease.Caption := #251;
        lcRelease.Font.Color := clRed;
        goto FrEnv;
      end;

FrEnv: { Free environment -----------------------------------------------------}
   Self.Update;
   if (SQLFreeEnv(env) <> SQL_SUCCESS) then
      begin
        lcRelease.Caption := #251;
        lcRelease.Font.Color := clRed;
        goto Leave;
      end;
   lcRelease.Caption := #252;
   lcRelease.Font.Color := clGreen;

Leave:
   Screen.Cursor := crDefault;

end;

procedure TfrmMain.cmdBrowseClick(Sender: TObject);
begin
     dlgOpen.InitialDir := ExtractFilePath(edtFileName.Text);
     if (dlgOpen.Execute) then
        edtFileName.Text := dlgOpen.FileName;
end;

procedure TfrmMain.RefreshProcess;
begin
     barStatus.Position := 0;
     lAlloc.Font.Color := clGrayText;
     lcAlloc.Caption := '';
     lConnect.Font.Color := clGrayText;
     lcConnect.Caption := '';
     lTable.Font.Color := clGrayText;
     lcCreate.Caption := '';
     lExport.Font.Color := clGrayText;
     lcExport.Caption := '';
     lDisconnect.Font.Color := clGrayText;
     lcDiscon.Caption := '';
     lRelease.Font.Color := clGrayText;
     lcRelease.Caption := '';
end;

procedure TfrmMain.WriteODBCRec;
var
   sFields : String;
   sValues : String;
   sFTemp  : String;
   sVTemp  : String;
begin

   sFields := '';
   sValues := '';

   for iTemp := 1 to 43 do
       if fFields[iTemp] then
          begin
            sFTemp := '[' + sField[iTemp] + ']';
            with USERSrec do
              case iTemp of
                 1 : sVTemp := IntToStr(barStatus.Position);
                 2 : sVTemp := qt + Name + qt;
                 3 : sVTemp := qt + Location + qt;
                 4 : sVTemp := qt + Address1 + qt;
                 5 : sVTemp := qt + Address2 + qt;
                 6 : sVTemp := qt + Address3 + qt;
                 7 : sVTemp := qt + Handle + qt;
                 8 : sVTemp := qt + Comment + qt;
                 9 : sVTemp := IntToStr(PasswordCRC);
                10 : sVTemp := qt + DataPhone + qt;
                11 : sVTemp := qt + VoicePhone + qt;
                12 : sVTemp := qt + LastDate + ' ' + LastTime + qt;
                13 : sVTemp := IntToStr(Credit);
                14 : sVTemp := IntToStr(Pending);
                15 : sVTemp := IntToStr(MsgsPosted);
                16 : sVTemp := IntToStr(Security);
                17 : sVTemp := IntToStr(NoCalls);
                18 : sVTemp := IntToStr(Uploads);
                19 : sVTemp := IntToStr(UploadsK);
                20 : sVTemp := IntToStr(Downloads);
                21 : sVTemp := IntToStr(DownloadsK);
                22 : sVTemp := IntToStr(TodayK);
                23 : sVTemp := IntToStr(Elapsed);
                24 : sVTemp := IntToStr(ScreenLength);
                25 : sVTemp := IntToStr(LastPwdChange);
                26 : sVTemp := IntToStr(Group);
                27 : sVTemp := qt + FirstDate + qt;
                28 : sVTemp := qt + SubDate + qt;
                29 : sVTemp := IntToStr(Language);
                30 : sVTemp := qt + IntToStr(DateFormat) + qt;
                31 : sVTemp := qt + ForwardTo + qt;
                32 : sVTemp := IntToStr(MsgArea);
                33 : sVTemp := IntToStr(MsgGroup);
                34 : sVTemp := IntToStr(FileArea);
                35 : sVTemp := IntToStr(FileGroup);
                36 : sVTemp := qt + DefaultProtocol + qt;
                37 : sVTemp := IntToStr(LastDOBCheck);
                38 : case Sex of
                      0 : sVTemp := qt + 'U' + qt;
                      1 : sVTemp := qt + 'M' + qt;
                      2 : sVTemp := qt + 'F' + qt;
                     end;
            end;
            sFields := sFields + sFTemp + ',';
            sValues := sValues + sVTemp + ',';
          end;
   sSQL := 'INSERT INTO ['+edtTable.Text + '] (' + Copy(sFields,1,Length(sFields)-1) + ') VALUES('+
          Copy(sValues,1,Length(sValues)-1) + ')';
   szSql := PChar(sSQL);
   SQLExecDirect(stmt,szSql,strlen(szSql));
end;

end.
