unit rafield;

{ This unit's function is to return a RemoteAccess field as a string from an enumerated type }

interface

const
   USERtitle : array[1..63] of string =
              ('Name','Location','Organisation','Address 1','Address 2','Address 3',
               'Handle','Comment','Password CRC','Data phone','Voice phone','Last time',
               'Last date','Deleted','CLS','More?','ANSI','No kill','Xfer priority',
               'ANSI editor','No notes','Hot keys','AVATAR','ANSI viewer','Hidden',
               'Page priority','No echomail scan','Guest','Post bill','Flags 1','Flags 2',
               'Flags 3','Flags 4','Credit','Pending','Messages','Security','Last read',
               'Calls','Uploads','Downloads','Upload KB','Download KB','Today KB',
               'Elapsed','Screen length','Last pass change','Group','First date',
               'Birth date','Sub date','Language','Date format','Forward to',
               'Mail area','File area','Protocol','File group','DOB check','Sex',
               'Mail group','Scan only','Password');

implementation

uses Routines, RA250, SysUtils, CRC32c;

function USERfield(USERrec : USERSrecord; Index : Integer) : String;
var
  Password2 : String;
begin
  Password2 := USERrec.Password;
  with USERrec do
    case Index of
      1 : Result := Name;
      2 : Result := Location;
      3 : Result := Organisation;
      4 : Result := Address1;
      5 : Result := Address2;
      6 : Result := Address3;
      7 : Result := Handle;
      8 : Result := Comment;
      9 : Result := IntToStr(PasswordCRC);
     10 : Result := DataPhone;
     11 : Result := VoicePhone;
     12 : Result := RATimeToStr(LastTime);
     13 : Result := RADateToStr(LastDate);
     14 : Result := YesNoAsk[Attribute and 1];    // Deleted
     15 : Result := YesNoAsk[Attribute and 2];    // CLS
     16 : Result := YesNoAsk[Attribute and 4];    // More prompt
     17 : Result := YesNoAsk[Attribute and 8];    // ANSI
     18 : Result := YesNoAsk[Attribute and 16];   // No kill
     19 : Result := YesNoAsk[Attribute and 32];   // Xfer priority
     20 : Result := YesNoAsk[Attribute and 64];   // Full screen editor
     21 : Result := YesNoAsk[Attribute and 128];  // Quiet
     22 : Result := YesNoAsk[Attribute2 and 1];   // Hot keys
     23 : Result := YesNoAsk[Attribute2 and 2];   // Avatar
     24 : Result := YesNoAsk[Attribute2 and 4];   // Full screen viewer
     25 : Result := YesNoAsk[Attribute2 and 8];   // Hidden
     26 : Result := YesNoAsk[Attribute2 and 16];  // Page priority
     27 : Result := YesNoAsk[Attribute2 and 32];  // No echomail scan
     28 : Result := YesNoAsk[Attribute2 and 64];  // Guest account
     29 : Result := YesNoAsk[Attribute2 and 128]; // Post bill
     30 : Result := '';
     31 : Result := '';
     32 : Result := '';
     33 : Result := '';
     34 : Result := IntToStr(Credit);
     35 : Result := IntToStr(Pending);
     36 : Result := IntToStr(MsgsPosted);
     37 : Result := IntToStr(Security);
     38 : Result := IntToStr(LastRead);
     39 : Result := IntToStr(NoCalls);
     40 : Result := IntToStr(Uploads);
     41 : Result := IntToStr(Downloads);
     42 : Result := IntToStr(UploadsK);
     43 : Result := IntToStr(DownloadsK);
     44 : Result := IntToStr(TodayK);
     45 : Result := IntToStr(Elapsed);
     46 : Result := IntToStr(ScreenLength);
     47 : Result := IntToStr(LastPwdChange);
     48 : Result := IntToStr(Group);
     49 : Result := RADateToStr(FirstDate);
     50 : Result := RADateToStr(BirthDate);
     51 : Result := RADateToStr(SubDate);
     52 : Result := IntToStr(Language);
     53 : Result := DateFmt[DateFormat];
     54 : Result := ForwardTo;
     55 : Result := IntToStr(MsgArea);
     56 : Result := IntToStr(FileArea);
     57 : Result := DefaultProtocol;
     58 : Result := IntToStr(FileGroup);
     59 : Result := IntToStr(LastDOBCheck);
     60 : Result := Sexy[Sex];
     61 : Result := IntToStr(MsgGroup);
     62 : Result := YesNoAsk[Attribute3 and 1]; // Scan selected only
     63 : if (CRC32(PChar(Password2),Length(Password2),-1) = PasswordCRC) then
              Result := Password2
           else
              Result := 'Unavailable';
  end;
end;

end.
