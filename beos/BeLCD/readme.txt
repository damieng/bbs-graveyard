BeLCD

Information
Version:	0.01	2-April-1999
Author:	Damien Guard
Contact:	damien@envytech.co.uk
Copyright:	(c) 1998-1999 Envy Technologies.  All rights reserved.
Website:	http://www.envytech.co.uk
Get from;	ftp://ftp.envytech.co.uk/download/be
Licence:	This software is PUBLIC DOMAIN.
Platforms:	Intel/PPC/BeBox - Source only


What is it?
This is a very quick and dirty program to utilise a Matrix Orbital LCD diplay to show system information.

This program was written back in R3.1 days and recompiled for R4 - it seems okay on my system but your mileage may vary.

I've only released this program as a few people have shown interest.  The restrictions are:

	o	Hard-coded serial and bps rate settings.  Could do with a seperate config program.
		This is currently set to serial2 and 19200.  Edit EnvyApp_Service.cpp to change.
	o	No PowerPC/BeBox project file - I don't have a PPC/BeBox - feel free to send me
		a working .proj file.
	o	Only supports the Matrix Orbital LCD 40x4 display.
	o	Source is a bit of a mess with lots of commented out code - it's all my own code so feel
		free to borrow what little may be of use.

What does it display?
It shows CPU activity for up to 2 CPU's as bars, shows a flashing heart-beat indicator, threads and memory usage.

Head over to www.matrixorbital.com to get one of these great displays.

Enjoy!

[)amien