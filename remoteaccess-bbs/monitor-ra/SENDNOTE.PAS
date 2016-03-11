unit sendnote;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Routines;

type
  TfrmSendNote = class(TForm)
    memText: TMemo;
    cmdSend: TButton;
    cmdCancel: TButton;
    cmdImport: TButton;
    procedure cmdSendClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cmdImportClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSendNote: TfrmSendNote;

implementation

Uses Main;

{$R *.DFM}

{-- Actually send the note ----------------------------------------------}
procedure TfrmSendNote.cmdSendClick(Sender: TObject);
var
   fTempFile: TextFile;
   sTempFile: String;
   iLoop: Integer;
begin
   FileMode := fmOpenWrite or fmShareDenyWrite;
   for iLoop := 1 to frmMain.lstStatus.Items.Count-1 do
       begin
         if (frmMain.lstStatus.Items[iLoop].Selected) or
            (frmMain.bIsBBSSelected and FileExists(CONFIGrec.SemPath + 'RABUSY.'+IntToStr(iLoop))) then
            begin
              sTempFile := CONFIGrec.SemPath + 'NODE' +
                           IntToStr(frmMain.lstStatus.Items[iLoop].StateIndex) + '.RA';
              AssignFile(fTempFile,sTempFile);
              if FileExists(sTempFile) then
                 Append(fTempFile)
               else
                 Rewrite(fTempFile);
              Write(fTempFile,#13#10#11 + ']497 ');
              Write(fTempFile,CONFIGrec.Sysop);
              if (frmMain.Stack = 0) then
                 Write(fTempFile,' (Monitor/RA [Unregistered])'+#13#10#13#10);
              if (frmMain.Stack = 1) then
                 Write(fTempFile,' (Monitor/RA [N])'+#13#10#13#10);
              if (frmMain.Stack = 2) then
                 Write(fTempFile,' (Monitor/RA [C])'+#13#10#13#10);
              Write(fTempFile,memText.Text);
              Write(fTempFile,#13#10#13#10#11+']258'+#01);
              CloseFile(fTempFile);
            end;
      end;
   FileMode := fmOpenRead or fmShareDenyNone;
   Close;
end;

{-- Initialize the form -------------------------------------------------}
procedure TfrmSendNote.FormShow(Sender: TObject);
begin
     ActiveControl := MemText;
     memText.Text := '';
end;

{-- Import note from a text file ----------------------------------------}
procedure TfrmSendNote.cmdImportClick(Sender: TObject);
begin
      frmMain.dlgOpen.Title := 'Import text file';
      frmMain.dlgOpen.DefaultExt := '*.TXT';
      frmMain.dlgOpen.FileName := '*.TXT';
      frmMain.dlgOpen.Filter := 'Text files|*.TXT|All files|*.*';
      if (frmMain.dlgOpen.Execute) then
           memText.Lines.LoadFromFile(frmMain.dlgOpen.FileName);
end;
{-- Release form & memory -----------------------------------------------}
procedure TfrmSendNote.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     Action := caFree;
end;

end.
