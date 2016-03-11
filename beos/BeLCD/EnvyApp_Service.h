#include <Application.h>
#include <SerialPort.h>

class EnvyApp: public BApplication 
{
	public:
		EnvyApp(void);
		~EnvyApp(void);
	private:
		UpdateLoop(void);
		bool Quitting;
		int cfgUpdateMS;
		char cfgSerialPort[256];
		int cfgSerialBPS;
		bigtime_t *prevTicks;
		int *currentPositions;
		char cpu[64];
		int cpuCount;
};