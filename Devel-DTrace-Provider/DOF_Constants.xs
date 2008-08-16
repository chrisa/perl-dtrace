#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <sys/dtrace.h>

#include "DOF_Constants_c.inc"

MODULE = Devel::DTrace::DOF::Constants		PACKAGE = Devel::DTrace::DOF::Constants

PROTOTYPES: DISABLE

INCLUDE: DOF_Constants_xs.inc

SV *
DOF_DOFHDR_SIZE()
	CODE:
	RETVAL = newSViv((IV)sizeof(dof_hdr_t));
	OUTPUT:
	RETVAL

SV *
DOF_SECHDR_SIZE()
	CODE:
	RETVAL = newSViv((IV)sizeof(dof_sec_t));
	OUTPUT:
	RETVAL

SV *
DOF_PROBE_SIZE()
	CODE:
	RETVAL = newSViv((IV)sizeof(dof_probe_t));
	OUTPUT:
	RETVAL

SV *
DOF_PRARGS_SIZE()
	CODE:
	RETVAL = newSViv((IV)sizeof(uint8_t));
	OUTPUT:
	RETVAL

SV *
DOF_PROFFS_SIZE()
	CODE:
	RETVAL = newSViv((IV)sizeof(uint32_t));
	OUTPUT:
	RETVAL

SV *
DOF_PRENOFFS_SIZE()
	CODE:
	RETVAL = newSViv((IV)sizeof(uint32_t));
	OUTPUT:
	RETVAL

SV *
DOF_PROVIDER_SIZE()
	CODE:
	RETVAL = newSViv((IV)sizeof(dof_provider_t));
	OUTPUT:
	RETVAL
