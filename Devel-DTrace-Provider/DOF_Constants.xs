#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <sys/dtrace.h>

#include "DOF_Constants_c.inc"

MODULE = Devel::DTrace::DOF::Constants		PACKAGE = Devel::DTrace::DOF::Constants

PROTOTYPES: DISABLE

INCLUDE: DOF_Constants_xs.inc
