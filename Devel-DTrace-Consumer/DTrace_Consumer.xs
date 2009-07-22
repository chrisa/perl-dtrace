#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

/* Allow us to call XS routines, here, the boot_* functions
   we need to boot the other packages */

static void
call_xs (pTHX_ void (*subaddr) (pTHX_ CV *), CV * cv, SV ** mark)
{
	dSP;
	PUSHMARK (mark);
	(*subaddr) (aTHX_ cv);
	PUTBACK;	/* forget return values */
}

#define DEVEL_DTRACE_CONSUMER_CALL_BOOT(name)	\
	{					\
		extern XS(name);		\
		call_xs (aTHX_ name, cv, mark);	\
	}

MODULE = Devel::DTrace::Consumer		PACKAGE = Devel::DTrace::Consumer

PROTOTYPES: DISABLE

BOOT:
  DEVEL_DTRACE_CONSUMER_CALL_BOOT(boot_Devel__DTrace__Context);
  DEVEL_DTRACE_CONSUMER_CALL_BOOT(boot_Devel__DTrace__ProbeDesc);
