PCIDetect

Information
Version:	0.43	21-March-1999
Author:	Damien Guard
Contact:	damien@envytech.co.uk
Copyright:	(c) 1998-1999 Envy Technologies.  All rights reserved.
Website:	http://www.envytech.co.uk
Get from;	ftp://ftp.envytech.co.uk/download/be
Licence:	This software is FREEWARE.
Platforms:	Intel (PPC/BeBox will be after R4.1)


What is it?
This is a terminal shell program to display the current list of PCI devices in your machine.  For each card it will show:

	Card's bus, device and function number.	
	Card		Name of the card in question
	Branded	Displays the card's manufacturer.  This is only displayed if the
			chip vendor is not the same as the card vendor. (Not always available)
	Vendor	Chip vendors name followed by their PCI code in square brackets
			Some vendors may also show a web site in brackets if one is known
			Companies that have been brought out show parent company after slash symbol
	Chip		Consists of chip id and then the device id in brackets
	Class		General type of device this is (all current PCI defined codes supported)
	Sub		Sub-type of device class this is (all current PCI defined codes supported)
	Type		This is only displayed if the PCI type code is not 0 as most devices do not use it
	IRQ		Interrupt Request Line currently assigned to this card (Not always available)


Whats new?
0.43	Added SoundBlaster PCI 128 seperate identification.
	Added SigmaDesigns Hollywood Plus
	Added some more web sites and assorted devices.
	Cleaned up the documentation.

0.42	Fixed "unknown bus" problem.
	Fixed problem with sub-vendor/branded descriptions & websites.
	Added SoundBlaster PCI.
	Added experimental --advanced switch to show more info.
	Make a better guess at unknown card names.
	Added some Zoran video capture devices & web site.

0.41	Rewritten the way sub-vendors are handled so it also shows subvendors name
	and web site.
	Added Brooktree/Hauppauge WinTV cards.
	Added SoundBlaster Live!
	Fixed repeated unknown message.
	Added a few odd web sites & devices (ViaTech, AuraVision...)
	Fixed Intel BX board (null) problem
	Internal code tidyup
	Split subsystem info up into device,vendor and correctly show & detect

0.40	Rewritten PCI access for R4 using Victor@Be's config manager wrapper code
	Added over 100 new PCI vendors from www.pcisig.org
	Changed commands-lines to --help and --summary
	Added more cards from ATI (Rage128), NVidia (TNT), 3DFX (Voodoo),
	Matrox (G100, G200), Diamond (FirePort) + some more from Win98.
	Added subsystem identification used to further identify variants of a card.
	Added 300+ new URL's to the vendors list.
	Note to send me a copy of the output if a device is not known.

Usage
The device ID's originally came from http://www.halcyon.com/scripts/jboemler/pci/pcicode.  Since then I've extensively enhanced it with codes from many Windows 98 device drivers, ATI and S3 developer documentation, Ralf Browns PCICFG.DAT, the XFree86's probe and other assorted sources.

The Vendors table has been extensively updated and contains all the latest members from www.pcisig.org and many contain the URL for that vendor's web site.  There are still ommissions but I must have searched for and found about 400-500 (not quite half) of the sites so far.  Some are indeed a little obscure.  I have also "adjusted" the company names to how the company refers to itself on the web page.

The program builds the device names using bits of the manufacturer name, card name and card type to get a nice name that usually works very well.

If this program shows:
	An "unknown" device
	A device with a strange or duplicate name (e.g. Intel ISA ISA Bus)

Then please send a copy of the output to me at damien@envytech.co.uk - I've only got a limited list of hardware to play with (one machine and 3 PCI graphics cards).  You can get a text version of the output by:

On Intel systems:			pcidetect-x86 > AnyOldFileNameHere 
On PPC/BeBox systems:	pcidetect-ppc > AnyOldFileNameHere

Then attaching the file to your message.  If you have an "unknown" please send a note listing what hareware IS in your machine so that I can try to fathom out what it is and add it to the next release. 

There are three commands-line arguments, these are:

	--help		Show program and database information
	--summary	Quick card-list of all PCI devices
	--advanced	Show additional "advanced" PCI information

Example

This is what comes out of my machine today:

Envy PCIDetect v0.43 for BeOS R4+

Warning: This is beta software and information shown may be incorrect.

Bus 0, Device 0, Function 0
Card   : Intel 430TX(MTXC) System Controller CPU Host Bridge
Vendor : Intel Corporation (www.Intel.com) [0x8086]
Chip   : 82430TX [0x7100]
Class  : Bridge [0x06]
Sub    : CPU Host Bridge [0x00]
IRQ    : None

Bus 0, Device 7, Function 0
Card   : Intel (PIIX4) PCI to ISA Bridge
Vendor : Intel Corporation (www.Intel.com) [0x8086]
Chip   : 82371AB/EB [0x7110]
Class  : Bridge [0x06]
Sub    : ISA Bridge [0x01]
IRQ    : N/A

Bus 0, Device 7, Function 1
Card   : Intel (PIIX4) Ultra DMA Bus Master IDE Controller
Vendor : Intel Corporation (www.Intel.com) [0x8086]
Chip   : 82371AB [0x7111]
Class  : Storage [0x01]
Sub    : IDE Controller [0x01]
Type   : Bus Mastering [0x80]
IRQ    : None

Bus 0, Device 7, Function 2
Card   : Intel (PIIX4) USB (Universal Serial Bus)
Vendor : Intel Corporation (www.Intel.com) [0x8086]
Chip   : 82371AB [0x7112]
Class  : Serial bus [0x0c]
Sub    : USB (Universal Serial Bus) [0x03]
IRQ    : 11

Bus 0, Device 7, Function 3
Card   : Intel (PIIX4) Power Management Bridge
Vendor : Intel Corporation (www.Intel.com) [0x8086]
Chip   : 82371AB/EB [0x7113]
Class  : Bridge [0x06]
Sub    : Bridge [0x80]
IRQ    : None

Bus 0, Device 9, Function 0
Card   : Matrox Millennium II Graphics Card
Vendor : Matrox Graphics Inc. (www.Matrox.com) [0x102b]
Chip   : MGA-2164W [0x051b] (Subsystem 0x1100,0x102b)
Class  : Display [0x03]
Sub    : Graphics Card [0x00]
IRQ    : 10

Bus 0, Device 10, Function 0
Card   : Adaptec AHA-2940AU Ultra SCSI Controller
Vendor : Adaptec Inc. (www.Adaptec.com) [0x9004]
Chip   : AIC-7861 [0x6178]
Class  : Storage [0x01]
Sub    : SCSI Controller [0x00]
IRQ    : 9

Bus 0, Device 12, Function 0
Card   : 3Com 3C905 Fast Etherlink XL 10/100bTX Ethernet LAN Adapter
Vendor : 3Com Corporation (www.3Com.com) [0x10b7]
Chip   : 3C905-TX [0x9050]
Class  : Network [0x02]
Sub    : Ethernet LAN Adapter [0x00]
IRQ    : 11  

Future plans
1.	Full GUI version with pretty icons etc.
2.	A different more-useful project I've started with some cool features.

Credits & Thanks
PCIDetect code by Damien Guard.
Configuration Manager wrapper by Victor Tsou/Be.
Original PCI device and vendor list by Jim Boemler (jboemler@halcyon.com) and associates, Ralf Brown PCICFG.DAT and associates and the XFree86 probe source code.
PCI Vendors & Devices database *extensive* modifications by Damien Guard.

Thanks to the guys on BeDevTalk - their help is always invaluable.
Additional thanks to those who provided output from unknown devices with clues to what it was - there are too many to individually mention but I've (sometimes a little quickly) replied to all of them.  You know who you are!

Enjoy!

[)amien
Damien Guard
Envy Technologies