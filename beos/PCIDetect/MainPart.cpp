/*
  PCIDetect
  ---------
  Copyright (C)1998-1999 Envy Technologies, All Rights Reserved.

  Author:	Damien Guard <damien@envytech.co.uk>
  Created:	10/Apr/98
  Modification log:
  	30/Apr/98	Rewrote to use PCI vendor & device list from internet
  			Changed output format
  			Improved Class, Subclass and API descriptions/lookup
  02/May/98	Tidied up device descriptions and removed device type info
  			This means to get the name we can now use the short manufacturers name
  			followed by the chip desc followed by the subclass, gives very good
  			results and saves lots of space.
  			Changed output format.
  03/May/98	Completely updated and overhauled vendor list using info from
  			www.pcisig.com.  Started adding new 'website' feature - disabled
  			until I've checked them all.
  			Correctly checks either header type 0 or 1 for IRQ.
  04/May/98	Re-enabled all commented out non-PCISIG vendors.
  			Removed Early card non-VGA type to avoid mis-naming.
  			Report why the IRQ not available for odd header types.
  			Correct hex-output to either 4 or 2 characters fixed.
  			Fixed problem where guessing not knowing next card would leave it untouched!
  			Split out vendors and devices tables.  Reworked web site addressing.
  17/Jun/98 Added a couple of hundred devices in (mainly 3D cards + new devs).
  			Fixed problem where device scan using vendor upper limit.
  			Speed-up so that once past the vendor, stops looking for device.
  			Tested & compiled under R3.1.
  			Changed Device to Chip and stopped appending dupe info used in Name.
  12/Jul/98 Added latest batch of vendor ID's from www.pcisig.com
  08/Mar/99 Has it been so long?  Attempt to modify for R4...
  07/May/99 Rewrite for v0.5
*/

// Standard C Includes
#include <malloc.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <alloc.h>

// BeOS Includes
#include <drivers/PCI.h>
#include <drivers/module.h>
#include <drivers/config_manager.h>

// My Includes
#include "pci_devices.c"
#include "pci_types.c"
#include "pci_vendors.c"

// Config wrapper includes
#include "config_driver.h"
#include "cm_wrapper.c"

// Prototypes
static void dump_devices_for_bus(bus_type bus, void (*f)(struct device_info *));
static void dump_pci_info(struct device_info *info);

// Globals
int vmax, dmax, cmax, smax, amax;
bool Summary;
int pciidx;

// Main
int main(int argc, char *argv[])
{
  status_t error;
  if ((error = init_cm_wrapper()) < 0) {
	printf("Error: Initialisation of configuration manager failed (%s)\n", strerror(error));
	return error;
  };

  printf("\033[0;4;1mEnvy PCIDetect v0.50 for \033[34mB\033[31me\033[0;4;1mOS R4+\n\n\033[0m");
  vmax = sizeof(PciVenTable) / sizeof(PCI_VENTABLE);
  dmax = sizeof(PciDevTable) / sizeof(PCI_DEVTABLE);
  cmax = sizeof(PciClassTable) / sizeof(PCI_CLASSTABLE);
  smax = sizeof(PciSubclassTable) / sizeof(PCI_SUBCLASSTABLE);
  amax = sizeof(PciApiTable) / sizeof(PCI_APITABLE);
  bool Database=false;

  if (argc > 1)
  	 for (int aidx=1;aidx<argc;aidx++) {
  	 	if (!strcmp(argv[aidx],"--summary")) Summary=1;
  		if (!strcmp(argv[aidx],"--help")) Database=1;
  	   };

  if (Database) {
  	printf("Database:\t%5d Vendors\n\t\t%5d Devices\n\t\t%5d Classes\n\t\t%5d Subclasses\n\t\t%5d Types\n", vmax, dmax, cmax, smax, amax);
  	printf("\nCompiled:\t08-June-1999\nCopyright:\t(c)1998-1999 Envy Technologies (www.envytech.co.uk)\nLicence:\tThis program is FREEWARE!");
	printf("\nSupport:\tdamien@envytech.co.uk\nUsage:   \t%s [--summary] | [--help]\n\n",argv[0]+2);
  	exit(0);
  };
  	dump_devices_for_bus(B_PCI_BUS, dump_pci_info);
  	uninit_cm_wrapper();
  	return 0;
};

// Loop through the devices on the BUS
static void dump_devices_for_bus(bus_type bus, void (*f)(struct device_info *))
{
	uint64 cookie;
	struct device_info dummy, *info;

	cookie = 0;
	pciidx = 0;
	while (get_next_device_info(bus, &cookie, &dummy, sizeof(dummy)) == B_OK) {
		info = (struct device_info *)malloc(dummy.size);
		if (!info) {
			printf("Error: Out of memory\n");
			break;
		};
		if (get_device_info_for(cookie, info, dummy.size) != B_OK) {
			printf("Error: Could not get device info\n");
			break;
		};
		dump_pci_info(info);
		free(info);
		printf("\n");
   };
};

static void dump_pci_info(struct device_info *info)
{
  char VendorName[255], DeviceName[255], ClassName[255], SubclassName[255];
  char ApiName[255], GuessName[255], WebAddr[255];

  struct pci_info *PCI = (struct pci_info *) ((uchar *)info + info->bus_dependent_info_offset);
  int vfdx, dfdx, cfdx, sfdx, afdx;

  dfdx = -1;
  vfdx = -1;
  cfdx = -1;
  sfdx = -1;
  afdx = -1;

  // Class check---------------------------------------------------
  for (int cidx=0;cidx<cmax;cidx++)
        if (PCI->class_base == PciClassTable[cidx].Class)
           {
            cfdx=cidx;
            break;
           };
    if (cfdx == -1)
       strcpy(ClassName, "Unknown");
    else
       strcpy(ClassName, PciClassTable[cfdx].ClassName);

    // Subclass check------------------------------------------------
    if (cfdx != -1)
    	for (int sidx=0;sidx<smax;sidx++)
    		if ((PCI->class_base == PciSubclassTable[sidx].Class) &
    			(PCI->class_sub == PciSubclassTable[sidx].Subclass))
    			{
    			 sfdx=sidx;
    			 break;
    			};
    if (sfdx == -1)
    	strcpy(SubclassName, "Unknown");
    else
    	strcpy(SubclassName, PciSubclassTable[sfdx].SubclassName);

	// Api check-----------------------------------------------------
	if ((cfdx != -1) & (sfdx != -1))
		for (int aidx=0;aidx<amax;aidx++)
			if ((PCI->class_base == PciApiTable[aidx].Class) &
				(PCI->class_sub == PciApiTable[aidx].Subclass) &
				(PCI->class_api == PciApiTable[aidx].Api))
				{
				 afdx=aidx;
				 break;
				};
	if (afdx == -1)
		strcpy(ApiName, "Unknown");
	else
		strcpy(ApiName, PciApiTable[afdx].ApiName);

    // Vendor check--------------------------------------------------
    for (int vidx=0;vidx<vmax;vidx++)
        if (PCI->vendor_id == PciVenTable[vidx].VenId)
           {
            vfdx=vidx;
            break;
           };
    if (vfdx == -1)
       strcpy(VendorName, "Unknown");
    else
       strcpy(VendorName, PciVenTable[vfdx].VenFull);

    // Device check--------------------------------------------------
    if (vfdx != -1)
       for (int didx=0;didx<dmax;didx++)
       	   {
       		if ((PCI->vendor_id < PciDevTable[didx].VenId)) break;
       		if ((PCI->vendor_id == PciDevTable[didx].VenId) &
         	   (PCI->device_id == PciDevTable[didx].DevId))
         	  {
         	    dfdx=didx;
         	    break;
         	   }
         	};
    if (dfdx == -1)
       strcpy(DeviceName, "Unknown");
    else
       strcpy(DeviceName, PciDevTable[dfdx].Chip);

	// Guess the name-----------------------------------------------
    if (vfdx != -1)
    	if (dfdx != -1)
    		{
    		 sprintf(GuessName, "%s %s ", PciVenTable[vfdx].VenShort, PciDevTable[dfdx].ChipDesc);
    		 if (sfdx != -1)
    		 	 strcat(GuessName, PciSubclassTable[sfdx].SubclassName);
    		}
    	else
    		sprintf(GuessName, "Unknown %s device", PciVenTable[vfdx].VenShort);
    else
    	strcpy(GuessName, "Unknown device");

    if (Summary==false) {
    printf("\033[4mIndex %d, Bus %d, Device %d\n\033[0m", pciidx++, PCI->bus, PCI->device);
    printf("Card  :\t%s\n", GuessName);
    printf("Vendor:\t%s [0x%04x]\n", VendorName, PCI->vendor_id);
    WebAddr[0]=0;
    if ((vfdx != -1) & (PciVenTable[vfdx].Web != NULL))
    	if (PciVenTable[vfdx].Web[0] == '*')
    	   {
            sprintf(WebAddr, "www.%s.com", PciVenTable[vfdx].VenShort);
    	   } else
    	    strcpy(WebAddr, PciVenTable[vfdx].Web);
	if (WebAddr[0]!=0) printf("WWW   :\t%s\n", WebAddr);
    printf("Chip  :\t%s [0x%04x]\n", DeviceName, PCI->device_id);
    printf("Class :\t%s [0x%02x]\n", ClassName, PCI->class_base);
    printf("Sub   :\t%s [0x%02x]\n", SubclassName, PCI->class_sub);
    if (PCI->class_api != 0) printf("Type  :\t%s [0x%02x]\n", ApiName, PCI->class_api);
    switch (PCI->header_type) {
    	case 0: printf("IRQ   :\t%d\n", PCI->u.h0.interrupt_line); break;
    	case 1: printf("IRQ   :\t%d\n", PCI->u.h1.interrupt_line); break;
    	default: printf("IRQ   : Not available (Header is %d)\n", PCI->header_type);
    };
   } else
   printf("%i-%i/%i: %s", pciidx++, PCI->bus, PCI->device, GuessName);
};
