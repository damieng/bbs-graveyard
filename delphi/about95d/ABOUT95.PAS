unit about95;

{ Windows 95 stlye 'About Dialog'.  All code by Damien Guard/Envy Technologies
  except 'System Resources' code by Matt Pietrek/Roy Nelson.

  This form will attempt to pickup as much info as it can from your app but
  may need some customisation - user name & company name are NOT shown as
  they should be FOR YOUR APP and not the Windows 95 ones ;-)

  Recommended use is to add this to your object repository
  and create new instances each time, modifying as required
  but with a little more work perhaps could be reusable.

  An icon, ABOUT95.ICO, is included should you add this to the
  object repository.

  Show this form with frmAbout.ShowModal

  Release:       0.1 5/4/96
  This is freeware, share & enjoy.  envy@guernsey.net }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

const
  kernel32 = 'kernel32.dll';
  GFSR_USERRESOURCES = $0002;
  GFSR_GDIRESOURCES  = $0001;

type
  GFSR_PROC = function(iValue: integer) : integer;
  TfrmAbout = class(TForm)
    imgIcon: TImage;
    bev1: TBevel;
    cmdOK: TButton;
    lblPhys: TLabel;
    lblPhysical: TLabel;
    lblApp: TLabel;
    lblWindows: TLabel;
    lblCopyright: TLabel;
    lblReg: TLabel;
    lblUserName: TLabel;
    lblCompanyName: TLabel;
    lblSysRes: TLabel;
    lblResFree: TLabel;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  {Record to receive Memory Available to Windows }
  MemoryStatus = record
               dwLength,
               dwMemoryLoad,
               dwTotalPhys,
               dwAvailPhys,
               dwTotalPageFile,
               dwAvailPageFile,
               dwTotalVirtual,
               dwAvailVirtual : dword
  end;

{Calls to Kernel32.dll - referenced by index for run-speed }
procedure GlobalMemoryStatus(var MemoryStruct:MemoryStatus); stdcall;
          external kernel32;
procedure QT_Thunk; cdecl;
          external kernel32 index 559;
function  LoadLibrary16(lpStrLibrary: PAnsiChar): THandle stdcall;
          external kernel32 index 35;
procedure FreeLibrary16(AnINSTANCE:THandle); stdcall;
          external kernel32 index 36;
function  GetProcAddress16(AnINSTANCE:THandle; lpFuncName:PAnsiChar):TFarProc stdcall;
          external kernel32 index 37;

var
  frmAbout: TfrmAbout;
  user_fsr : word;
  userFunc : GFSR_PROC;

implementation

{$R *.DFM}

procedure TfrmAbout.FormShow(Sender: TObject);
var
     MemoryStruct: MemoryStatus;
     MemoryString: String;
     hdlLoadLib: THandle;
begin
     imgIcon.Picture.Icon := Application.Icon; {Icon}
     frmAbout.Caption := 'About ' + Application.Title; {About caption}
     lblApp.Caption := Application.Title;
     MemoryStruct.dwLength := sizeof(MemoryStruct);
     GlobalMemoryStatus(MemoryStruct);
     MemoryStruct.dwTotalPhys:= MemoryStruct.dwTotalPhys div 1024;
     MemoryString := IntToStr(MemoryStruct.dwTotalPhys);
     lblPhysical.Caption := Copy(MemoryString,1,length(MemoryString) -3) + ','
                         + Copy(MemoryString,length(MemoryString)-2,10) + ' KB';
     hdlLoadLib := LoadLibrary16('USER.EXE');
     FreeLibrary16(hdlLoadLib);
     @userFunc := GetProcAddress16(hdlLoadLib, 'GetFreeSystemResources');
     if @userFunc = nil then begin
        ShowMessage('GetProcAddress16 failure' );
        Exit;
     end;
     asm
       push GFSR_USERRESOURCES
       mov edx, [userFunc]
       call QT_Thunk
       mov [user_fsr], ax
     end;
     lblResFree.Caption := IntToStr(user_fsr) + '% Free';
end;

end.
