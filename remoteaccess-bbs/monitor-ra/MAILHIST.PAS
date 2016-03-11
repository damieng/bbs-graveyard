Unit MailHist;
(*
**  mailhist.inc
**
**  Structures for .HIS files
**
**  Copyright 1991-1993 Joaquim Homrighausen; All rights reserved.
**
**  Last revised: 93-06-21                         FrontDoor 2.11+
**
**  -------------------------------------------------------------------------
**  This information is not necessarily final and is subject to change at any
**  given time without further notice
**  -------------------------------------------------------------------------
*)

(*
**  The first record in the .HIS files is not a valid history entry. It
**  contains the date/time when the .HIS file was last packed or when
**  it was created if it has never been packed. So if you're reading the
**  .HIS files for any reason, skip the first record and you'll be at the
**  first valid record.
**
**  Note that the COST field will contain zero for inbound mail sessions as
**  well as any failed session negotiated using the script language.
*)

TYPE
  MAILHISTrecord = RECORD
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
    Task      :BYTE;                           {Task that added the entry (C)}
    timeonline:WORD;                                   {Seconds spent on-line}
    rcvd_bytes,                                         {Total received bytes}
    sent_bytes:LONGINT;                                     {Total sent bytes}
    cost      :WORD;                                         {Cost of session}
  END;{MAILHIST}

(* end of file "mailhist.inc" *)
