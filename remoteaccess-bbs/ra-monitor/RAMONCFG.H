typedef unsigned char Byte;
typedef char Path[81];

struct RAMONrecord {
    Path sRA_Nodes;
    unsigned int iRefresh;
    Byte iExitLevel;
    Byte iMouseMode;
    Byte iUserDoes;
    Byte iDateFmt;  //0-DDMMYY 1-MMDDYY
};