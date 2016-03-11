unit keygen;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CRC32c, VTRAcfg;

type
  TfrmMain = class(TForm)
    Label1: TLabel;
    lblName: TLabel;
    edtName: TEdit;
    edtSerial: TEdit;
    lblSer: TLabel;
    lblSite: TLabel;
    edtSite: TEdit;
    cmdCreate: TButton;
    chkPro: TCheckBox;
    cmdLoad: TButton;
    lblProd: TLabel;
    cboProduct: TComboBox;
    Label2: TLabel;
    edtDate: TEdit;
    dlgOpen: TOpenDialog;
    dlgSave: TSaveDialog;
    procedure cmdCreateClick(Sender: TObject);
    procedure cmdLoadClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

const ProdCode : array[1..1] of string = ('Monitor/RA');
const FileName : array[1..1] of string = ('MONITOR.KEY');
const NormCRC : array[1..1] of longint = (140774);
const NormCRC2 : array[1..1] of longint = (36699);
const ProCRC : array[1..1] of longint = (200676);
const ProCRC2 : array[1..1] of longint = (710881);

{$R *.DFM}

procedure TfrmMain.cmdCreateClick(Sender: TObject);
var
   KEYfile : file of KEYFILErecord;
   KEYrec : KEYFILErecord;
begin
   dlgSave.FileName := FileName[cboProduct.ItemIndex+1];
   ShowMessage(dlgSave.FileName);
   if dlgSave.Execute then
      begin
        AssignFile(KEYfile,dlgSave.FileName);
        FileMode := 2;
        Rewrite(KEYfile);
        KEYrec.kID := 'EnvyKey';
        KEYrec.kCR1 := 13;
        KEYrec.kCR2 := 13;
        KEYrec.kCR3 := 13;
        KEYrec.kCR4 := 13;
        KEYrec.kProduct := ProdCode[cboProduct.ItemIndex+1];
        KEYrec.kRegistered := edtName.Text;
        KEYrec.kRegDate := edtDate.Text;
        KEYrec.kRegSite := edtSite.Text;
        KEYrec.keof := 23;
        if chkPro.Checked then
           KEYrec.kRegisteredC := CRC32(@KEYrec.kRegistered[1],length(KEYrec.kRegistered),ProCRC[cboProduct.ItemIndex+1])
         else
           KEYrec.kRegisteredC := CRC32(@KEYrec.kRegistered[1],length(KEYrec.kRegistered),NormCRC[cboProduct.ItemIndex+1]);
        KEYrec.kExpire := 0;
        KEYrec.kSerial := StrToInt(edtSerial.Text);
        KEYrec.kSerialChk := CRC32(@KEYrec.kRegSite[1],2,KEYrec.kSerial);
        KEYrec.kProdSerial := CRC32(@KEYrec.kProduct[1],length(KEYrec.kProduct),KEYrec.kRegisteredC);
        if chkPro.Checked then
           KEYrec.kBlockID := CRC32(@KEYrec,sizeof(KEYrec)-4,ProCRC2[cboProduct.ItemIndex+1])
         else
           KEYrec.kBlockID := CRC32(@KEYrec,sizeof(KEYrec)-4,NormCRC2[cboProduct.ItemIndex+1]);
        Write(KEYfile,KEYrec);
        CloseFile(KEYfile);
   end;
end;

procedure TfrmMain.cmdLoadClick(Sender: TObject);
var
   KEYfile : file of KEYFILErecord;
   KEYrec : KEYFILErecord;
begin
   dlgOpen.FileName := '*.KEY';
   if (dlgOpen.Execute) then
      begin
        AssignFile(KEYfile,dlgOpen.FileName);
        FileMode := 0;
        Reset(KEYfile);
        Read(KEYfile,KEYrec);
        if (KEYrec.kID <> 'EnvyKey') then ShowMessage('Not EnvyKey');
        cboProduct.Text := KEYrec.kProduct;
        edtName.Text := KEYrec.kRegistered;
        edtDate.Text := KEYrec.kRegDate;
        edtSite.Text := KEYrec.kRegSite;
        if (KEYrec.keof <> 23) then ShowMessage('No EOF marker');
        chkPro.Checked := False;
        if (KEYrec.kRegisteredC = CRC32(@KEYrec.kRegistered[1],length(KEYrec.kRegistered),ProCRC[cboProduct.ItemIndex+1])) then
           begin
             if (KEYrec.kBlockID = CRC32(@KEYrec,sizeof(KEYrec)-4,ProCRC2[cboProduct.ItemIndex+1])) then chkPro.Checked := True
                else ShowMessage('Secondary Pro CRC failure');
           end
         else
         if (KEYrec.kRegisteredC = CRC32(@KEYrec.kRegistered[1],length(KEYrec.kRegistered),NormCRC[cboProduct.ItemIndex+1])) then
            begin
             if (KEYrec.kBlockID <> CRC32(@KEYrec,sizeof(KEYrec)-4,NormCRC2[cboProduct.ItemIndex+1])) then ShowMessage('Secondary Non-Pro CRC failure');
            end
         else ShowMessage('Neither Pro nor Normal key CRCs');

        edtSerial.Text := IntToStr(KEYrec.kSerial);
        if (KEYrec.kSerialChk <> CRC32(@KEYrec.kRegSite[1],2,KEYrec.kSerial)) then
           ShowMessage('Serial CRC failure');
        if (KEYrec.kProdSerial <> CRC32(@KEYrec.kProduct[1],length(KEYrec.kProduct),KEYrec.kRegisteredC)) then
           ShowMessage('Product/Name CRC failure');
        CloseFile(KEYfile);
    end;
end;

end.
