unit locale;

interface

const
     StateToText  : array[0..7] of string = ('Browsing','Files','Mail','Door',
                                             'Sysop chat','Questionnaire',
                                             'Conferencing','New user');
     SexToText : array[0..2] of string = ('Unknown','Male','Female');
     DateToText : array[1..4] of string = ('DD-MM-YY','MM-DD-YY','YY-MM-DD',
                                           'DD-Mmm-YY');

     RemoteAccess = 'RemoteAccess';
     Ready = 'Ready';
     Offline = 'Offline';
     Node = 'Node';
     LogIn = 'Logging in';
     Local = 'Local';
     Unregistered = 'Unregistered';
     RefreshedAt = 'Refreshed at ';
     AllNodes = ' all active nodes?';
     SelectedNodes = ' selected nodes?';
     NotFound = ' not found';
     RegisterToday = 'Please register today!';
     Welcome = 'Welcome to Monitor/RA!  Would you like me to setup icons on your Program Manager or Start Menu?';
     FirstTime = 'As this is your first time using Monitor/RA, you should check the following settings and ensure they are correct.';
     CancelInstall = 'Installation of Monitor/RA cancelled.';
     NotThisSysop = ' not registered to this sysop';
     UnregWarn = 'Monitor/RA is unregistered!  Only 2 nodes will be available.';
     KeyNotEnvy = 'Keyfile is not an Envy Technologies key-file.';
     KeyTampered = 'Keyfile has been corrupted or tampered with.';
     RegOnly = 'Registered feature only.';
     Elapsed = '    (Elapsed: ';
     Outstand = ' outstanding ';
     OutSince = ' outstanding since ';
     No = 'No';
     UserLost = 'User not found (May be a new user)';

implementation

end.
 