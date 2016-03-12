#include <alloc.h>
#include <stdio.h>

#include "EnvyApp_Service.h"
#include "MatrixOrbital.h"

BSerialPort myPort;

EnvyApp::EnvyApp():BApplication("application/x-vnd.Envy-BeLCD_Service") {
    // Fake config for now
    cfgUpdateMS=100000;
    strcpy(cfgSerialPort,"serial2");
    cfgSerialBPS=19200;
    Quitting=false;

    // Get preliminary system info
    system_info si;
    get_system_info(&si);
    cpuCount = si.cpu_count;
    switch (si.cpu_type) { // Build processor name
    case B_CPU_PPC_601:
        strcpy(cpu,"PowerPC 601");
        break;
    case B_CPU_PPC_603:
        strcpy(cpu,"PowerPC 603");
        break;
    case B_CPU_PPC_603e:
        strcpy(cpu,"PowerPC 603e");
        break;
    case B_CPU_PPC_604:
        strcpy(cpu,"PowerPC 604");
        break;
    case B_CPU_PPC_604e:
        strcpy(cpu,"PowerPC 604e");
        break;
    case B_CPU_INTEL_PENTIUM:
    case B_CPU_INTEL_PENTIUM75:
        strcpy(cpu,"Pentium");
        break;
    case B_CPU_INTEL_PENTIUM_486_OVERDRIVE:
    case B_CPU_INTEL_PENTIUM75_486_OVERDRIVE:
        strcpy(cpu,"PentiumOD");
        break;
    case B_CPU_INTEL_PENTIUM_PRO:
        strcpy(cpu,"PentiumPro");
        break;
    case B_CPU_INTEL_PENTIUM_II:
    case B_CPU_INTEL_PENTIUM_II_MODEL_5:
        strcpy(cpu,"Pentium II");
        break;
    case B_CPU_AMD_X86:
        strcpy(cpu,"AMD x86");
        break;
    case B_CPU_AMD_K5_MODEL0:
    case B_CPU_AMD_K5_MODEL1:
    case B_CPU_AMD_K5_MODEL2:
    case B_CPU_AMD_K5_MODEL3:
        strcpy(cpu,"AMD K5");
        break;
    case B_CPU_AMD_K6_MODEL6:
    case B_CPU_AMD_K6_MODEL7:
    case B_CPU_AMD_K6_MODEL8:
    case B_CPU_AMD_K6_MODEL9:
        strcpy,(cpu,"AMD K6");
        break;
    case B_CPU_CYRIX_X86:
        strcpy(cpu,"Cyrix x86");
        break;
    case B_CPU_CYRIX_GXm:
        strcpy(cpu,"Cyrix GX");
        break;
    case B_CPU_CYRIX_6x86MX:
        strcpy(cpu,"Cyrix 6x86MX");
        break;
    default:
        strcpy(cpu,"Processor");
    };

    // Create array for processor activity
    prevTicks = new bigtime_t [cpuCount];
    memset(prevTicks, 0, cpuCount * sizeof(bigtime_t));
    currentPositions = new int [cpuCount];
    memset(currentPositions, 0, cpuCount * sizeof(int));

    // Create connection
    myPort.Open(cfgSerialPort);
    myPort.SetDataRate(B_19200_BPS);
    myPort.SetDataBits(B_DATA_BITS_8);
    myPort.SetStopBits(B_STOP_BITS_1);
    myPort.SetParityMode(B_NO_PARITY);
    myPort.SetFlowControl(B_NOFLOW_CONTROL);
    myPort.ClearOutput();
    MOHome();
    MOSetLineWrapping(false);
    MOSetScrolling(false);
    MOClearDisplay();

    UpdateLoop();
}

EnvyApp::~EnvyApp(void) {
    free(prevTicks);
    free(currentPositions);
    myPort.Close();
}

EnvyApp::UpdateLoop() {
    char output[64];
    int CurDisplay=-1;
    int CurCount=0;
    int Heartbeat=false;

    bigtime_t lastUpdateTime = system_time();
    system_info si;
    get_system_info(&si);
    if (cpuCount > 2) cpuCount=2;

    // Intro screen
    /*	MOCreateCustom(0,"\x01F\x000\x000\x000\x000\x000\x000\x01F");
    	MOCreateCustom(1,"\x001\x001\x001\x001\x001\x001\x001\x001");
    	MOCreateCustom(2,"\x018\x004\x004\x002\x002\x004\x004\x018");
    	MOCreateCustom(3,"\x003\x004\x008\x008\x008\x010\x010\x010");
    	MOCreateCustom(4,"\x018\x004\x002\x002\x002\x001\x001\x001");
    	MOCreateCustom(5,"\x003\x004\x004\x008\x008\x004\x004\x003");
    	MOCreateCustom(6,"\x010\x010\x010\x008\x008\x008\x004\x003");
    	MOCreateCustom(7,"\x001\x001\x001\x002\x002\x002\x004\x018");
    	MOSetCursorPosition(1,1);
     	Serial.Write("\x001\x000\x002 \x003\x004\x005\x000",8);
    	MOSetCursorPosition(1,2);
     	Serial.Write("\x001\x000\x002\e\x006\x007 \x000\x002",9);
      	MOSetCursorPosition(1,3);
    	sprintf(output,"on %dx%s %d",si.cpu_count,cpu,si.cpu_clock_speed / 100000);
    	MOSendText(output);

    	snooze(8000000); */

    while (!Quitting) {
        if (CurCount==0) {
            CurDisplay++;
            if (CurDisplay > 0) CurDisplay=0;
            CurCount=25;
            MOClearDisplay();
            MOHome();
            switch (CurDisplay) {
            /*					case 0: // System screen
            						MOSendText("         Used   Free");
            						MOSetCursorPosition(0,2);
            						MOSendText("Memory");
            						MOSetCursorPosition(0,3);
            						MOSendText("Teams ");
            						MOSetCursorPosition(0,4);
            						MOSendText("Thread");
            						break; */
            case 0:
                sprintf(output,"%c%c CPU LOAD 00.0%% %c%c", 0xFF,0xFF,0xFF,0xFF);
                MOSendText(output);
                MOSetCursorPosition(1,2);
                MOSendText("1");
                MOSetCursorPosition(1,3);
                MOSendText("2");
                MOSetCursorPosition(1,4);
                MOSendText("Team");
                MOSetCursorPosition(11,4);
                MOSendText("Mem");
                MOInitHorizBar();
                break;
                /*					case 1: // CPU graph
                					    sprintf(output,"  %dx%s %d", si.cpu_count, cpu, si.cpu_clock_speed / 1000000);
                						MOSendText(output);
                						MOInitHorizBar();
                					    for(int i=0;i<cpuCount;i++) {
                							MOSetCursorPosition(1,i+2);
                							sprintf(output,"%d",i+1);
                							MOSendText(output);
                						};
                						break; */
            };
        };
        switch (CurDisplay) {
        /*				case 0: // System screen
        					get_system_info(&si);
        					MOSetCursorPosition(8,2);
        					sprintf(output, "%6d %6d", si.used_pages * B_PAGE_SIZE / 1024, (si.max_pages - si.used_pages) * B_PAGE_SIZE / 1024);
        					MOSendText(output);
        					MOSetCursorPosition(8,3);
        					sprintf(output, "%6d %6d", si.used_teams, si.max_teams-si.used_teams);
        					MOSendText(output);
        					MOSetCursorPosition(8,4);
        					sprintf(output, "%6d %6d", si.used_threads, si.max_threads-si.used_threads);
        					MOSendText(output);
        					break;  */
        case 0:
            bigtime_t now = system_time();
            double scaleFactor = (now - lastUpdateTime);
            lastUpdateTime = now;
            get_system_info(&si);
            float tNew=0;
            int iNew;
            for(int i=0; i<cpuCount; i++) {
                iNew = (si.cpu_infos[i].active_time - prevTicks[i]) * ((100 / 1.05) / scaleFactor);
                tNew=tNew+((si.cpu_infos[i].active_time - prevTicks[i]) * (100 / scaleFactor));
                prevTicks[i] = si.cpu_infos[i].active_time;
                if (iNew<0) iNew=0;
                if (iNew>95) iNew=95;
                if (iNew != currentPositions[i]) MOMakeHorizBar(2,i+2,0,iNew);
            };
            tNew=tNew/cpuCount;
            MOSetCursorPosition(13,1);
            if (tNew<99.95) sprintf(output,"%04.1f",tNew);
            else sprintf(output,"100 ");
            MOSendText(output);
            MOSetCursorPosition(6,4);
            sprintf(output,"%-4d",si.used_teams);
            MOSendText(output);
            MOSetCursorPosition(14,4);
            sprintf(output,"%6dk",(si.used_pages * B_PAGE_SIZE) / 1024);
            MOSendText(output);
        };
        //CurCount--;
        // Set heart character
        if (Heartbeat) MOCreateCustom(7,"\x01F\x015\x000\x000\x000\x011\x01B\x01F");
        else 		   MOCreateCustom(7,"\x01F\x015\x00A\x00E\x00E\x015\x01B\x01F");
        Heartbeat=!Heartbeat;
        MOSetCursorPosition(20,1);
        MOSendText("\x007");
//		MOSetCursorPosition(1,1);
//		if (Heartbeat) MOSendText("+");
//		else MOSendText("x");
        snooze(250000);
    }
}

#include "MatrixOrbital.cpp"