#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <sys/dtrace.h>

MODULE = Devel::DTrace::DOF::Section		PACKAGE = Devel::DTrace::DOF::Section

PROTOTYPES: DISABLE

SV *
header(self)
	SV *self

	INIT: 
	HV *data;
	SV **val;
	dof_sec_t hdr;
	uint32_t type;
	uint64_t offset;
	uint64_t size;
	uint32_t entsize;

        CODE:
	if (SvROK(self) && SvTYPE(SvRV(self)) == SVt_PVHV) {
	  data = (HV *)SvRV(self);
	  memset(&hdr, 0, sizeof(hdr));

	  val = hv_fetch(data, "_flags", 6, 0);
	  if (val && *val)
	    hdr.dofs_flags = SvIV(*val);

	  val = hv_fetch(data, "_section_type", 13, 0);
	  if (val && *val)
	    hdr.dofs_type = SvIV(*val);

	  val = hv_fetch(data, "_offset", 7, 0);
	  if (val && *val)
	    hdr.dofs_offset = SvIV(*val);
	  
	  val = hv_fetch(data, "_size", 5, 0);
	  if (val && *val)
	    hdr.dofs_size = SvIV(*val);
				    
	  val = hv_fetch(data, "_entsize", 8, 0);
	  if (val && *val)
	    hdr.dofs_entsize = SvIV(*val);
	  
	  val = hv_fetch(data, "_align", 6, 0);
	  if (val && *val)
	    hdr.dofs_align = SvIV(*val);

	  RETVAL = newSVpvn((const char *)&hdr, sizeof(hdr));
	}
	else {
	  RETVAL = &PL_sv_undef;
	}
	OUTPUT:
	RETVAL
