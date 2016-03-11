(*
**  lastcall.inc
**
**  Structures for LASTCALL.FD
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

TYPE
  STATREC = RECORD
    inbound,                                              {Inbound mail calls}
    outbound,                                            {Outbound mail calls}
    humans,                                              {Inbound BBS callers}
    filesin,                                                  {Received files}
    filesout,                                                     {Sent files}
    goodsess,                                                  {Good sessions}
    badsess,                                                 {Failed sessions}
    requests  :WORD;                                   {Inbound file requests}
    date,                                               {UNIX-style timestamp}
    bytesin,                                                  {Received bytes}
    bytesout  :LONGINT;                                           {Sent bytes}
  END;{STATREC}

  LASTCALL = RECORD
    system_name :STRING[30];                            {Remote system's name}
    location    :STRING[40];                        {Remote system's location}
    zone,                                            {Remote system's address}
    net,
    node,
    point       :WORD;
    time        :LONGINT;                               {UNIX-style timestamp}
  END;{LASTCALL}

(*
**  The LASTCALL.FD file contains four records, two STATREC and two
**  LASTCALL. Today's activity is moved to yesterday's activity as soon
**  as FD runs its 'past-midnight' internal event.
*)
  ACTIVITY = RECORD
    LastIn,                                           {Last inbound mail call}
    LastOut  :LASTCALL;                              {Last outbound mail call}
    TodayAct,                                               {Today's activity}
    YesterdayAct
            :STATREC;                                   {Yesterday's activity}
  END;{ACTIVITY}

(* end of file "lastcall.inc" *)
