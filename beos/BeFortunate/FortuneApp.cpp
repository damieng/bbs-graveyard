/*

BeFortunate - a simple GUI program to display fortune cookies in BeOS r4
	by Damien Guard, Envy Technologies
	This program is public domain, feel free to modify.

	Notes: I think the random number calculation will never reach the top
		   but I have no documentation on how to use these functions.
		   A proper GUI screen would probably have been better to format text.
		   As would a config setting so that the fortune cookies are
		   sequential as opposed to random.


*/
#include <Alert.h>
#include <File.h>
#include <string.h>
#include <stdlib.h>
#include "FortuneApp.h"
#define FortuneFile "/boot/beos/etc/fortunes/default"

FortuneApp::FortuneApp() : BApplication("application/x-vnd.Envy-BeFortunate") {
    char Fortune[512];
    int start, end, pos;
    off_t max;
    bigtime_t myTime;
    size_t FortuneSize;

    // Attempt to read the Be-supplied fortune file
    BFile *myFile = new BFile(FortuneFile, B_READ_ONLY);
    if (myFile->IsReadable()) {
        // Choose a random position in the file
        myFile->GetSize(&max);
        myTime=system_time();
        srandom(myTime);
        int rnd=rand()*max/RAND_MAX;
        myFile->Seek(rnd, SEEK_SET);
        FortuneSize = myFile->Read((void *)Fortune, sizeof(Fortune));
        // Find the first fortune from this position
        for (start=0; ((start<FortuneSize) && (Fortune[start]!='%')); start++);
        start++;
        start++;
        // Find the end
        for (end=start; ((end<FortuneSize) && (Fortune[end]!='%')); end++);
        end--;
        Fortune[end] = '\0';
        // Remove CR/LF's "intelligently"
        for (pos=start; pos<end; pos++)
            if ((Fortune[pos]<32) && (Fortune[pos+1]>32)) Fortune[pos]=' ';
    };

    // Check file and reading went okay
    if ((!myFile->IsReadable()) || (FortuneSize==0)) {
        strcpy(Fortune, "I cannot read or find ");
        strcat(Fortune, FortuneFile);
        start=0;
    };
    delete(myFile);

    // Show the fortune (or error message)
    BAlert *myAlert = new BAlert("BeFortunate", Fortune+start, "OK",
                                 NULL, NULL, B_WIDTH_AS_USUAL, B_IDEA_ALERT);
    myAlert->SetShortcut(0, B_ESCAPE);
    myAlert->Go();
};

FortuneApp::~FortuneApp() {
};

int main() {
    FortuneApp *myApp = new FortuneApp();
//	myApp->Run();  No need to run - did everything in the constructor
    delete myApp;
};