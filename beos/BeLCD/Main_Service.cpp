#include "EnvyApp_Service.h"

int main(void)
{
	EnvyApp *myapp = new EnvyApp();
	myapp->Run();
	delete myapp;	
	return(B_NO_ERROR);	
}