unit VtraCfg;

interface

{-- Main configuration record -------------------------------------------}
type  VTRACFGrecord = record
       MainUseEnvir   : Boolean;
       MainRAPath     : string[100];
       MainNodeTpl    : string[100];
       MonitorRefresh : Integer;
       MainExitLevel  : Integer;
       MonitorView    : Byte;
       MonitorStatus  : Boolean;
       MonitorTray    : Boolean;
       Left           : Integer;
       Top            : Integer;
       Width          : Integer;
       Height         : Integer;
       MailerPath     : string[100];
       MailerType     : Byte; {0=None,1=FrontDoor,2=InterMail,3=McMail}
       MailerMulti    : Boolean;
       AutoSizeCol    : Boolean;
       ShutdownLevel  : Integer;
       ReverseOrder   : Boolean;
       SaveOnExit     : Boolean;
       IgnoreOffline  : Boolean;
end;

{-- Registration key file record ----------------------------------------}
type  KEYFILErecord = record
      kID              : string[7]; {EnvyKey}
      kCR1             : Byte;
      kProduct         : string[50]; {Product name}
      kCR2             : Byte;
      kRegistered      : string[50]; {Registered to}
      kCR3             : Byte;
      kRegDate         : string[11]; {Date registered}
      kCR4             : Byte;
      kRegSite         : string[2]; {Registration site code}
      keof             : Byte;
      kRegisteredC     : LongInt; {Registered to CRC,seed 140774}
      kExpire          : LongInt; {Expiry date}
      kSerial          : LongInt; {Serial number}
      kSerialChk       : LongInt; {RegSite, with Serial as CRC}
      kProdSerial      : LongInt; {Product CRC, seed kRegisteredC}
      kBlockID         : LongInt; {Record CRC, seed 710881}
end;

{-- Mailer history ------------------------------------------------------}
type
  MAILHISTrecord = record { InterMail 2.29 + FrontDoor 2.12 }
    year,                                                        {1990 - xxxx}
    month,                                                            {1 - 12}
    day,                                                              {1 - 31}
    hour,                                                             {0 - 23}
    min,                                                              {0 - 59}
    sec,                                                              {0 - 59}
    zone,                                              {Remote system address}
    net,
    node,
    point     :WORD;
    SystemName:STRING[30];                                {Remote system name}
    City      :STRING[37];                            {Remote system location}
    Task      :BYTE; { Do not use in InterMail }
    timeonline:WORD; { "" }
    rcvd_bytes,                                         {Total received bytes}
    sent_bytes:LONGINT;                                     {Total sent bytes}
    cost      :WORD;                                         {Cost of session}
  end;

  MCMHISTrecord = record { McMail 1.00g3 }
    w_cps                : word;
    l_speed              : longint;
    l_inb,
    l_outb               : longint;
    s_session,
    s_node,
    s_name,
    s_system             : string[40];
    s_start              : string[5];
    w_mins               : word;
    l_cost               : longint;
    s_date               : string[11];
  end;

implementation

end.
