#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"


MODULE = Devel::DTrace::Provider		PACKAGE = Devel::DTrace::Provider		

PROTOTYPES: DISABLE

BOOT: 
      boot_Devel__DTrace__DOF__Constants();
      boot_Devel__DTrace__DOF__Section();
