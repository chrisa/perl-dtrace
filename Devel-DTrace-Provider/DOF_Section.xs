#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <sys/dtrace.h>
#include <sys/utsname.h>

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

SV *
dof_generate_utsname(self)
	     SV *self
	     
	     INIT:
	     struct utsname u;

             CODE:
	     uname(&u);
	     RETVAL = newSVpvn((const char *)&u, sizeof(struct utsname));
             OUTPUT:
	     RETVAL

SV *
dof_generate_comments(self)
	     SV *self
	     
	     INIT:
	     HV *data;
	     SV **val;

             CODE:
	     if (SvROK(self) && SvTYPE(SvRV(self)) == SVt_PVHV) {
	       data = (HV *)SvRV(self);

	       val = hv_fetch(data, "_data", 5, 0);
	       if (val && *val && SvPOK(*val)) {
		 RETVAL = newSVsv(*val);
	         sv_catpvn(RETVAL, "", 1);
	       }
	       else {
		 RETVAL = &PL_sv_undef;
	       }
	     }
             else {
	       RETVAL = &PL_sv_undef; 
	     }

             OUTPUT:
             RETVAL

SV *
dof_generate_probes(self)
		  SV *self

		  INIT:
		  int i;
		  HV *data;
		  AV *probes;
		  SV **probe;
		  HV *probedata;
		  SV *probedof;
		  SV **val;
		  dof_probe_t p;

                  CODE:
		  if (SvROK(self) && SvTYPE(SvRV(self)) == SVt_PVHV) {
		    data = (HV *)SvRV(self);
		    
		    val = hv_fetch(data, "_data", 5, 0);
		    if (val && *val && (SvTYPE(SvRV(*val)) == SVt_PVAV)) {
		      probes = (AV *)SvRV(*val);

		      RETVAL = newSVpvn("", 0);

		      for (i = 0; i <= av_len(probes); i++) {
			probe = av_fetch(probes, i, 0);
			if (probe && *probe && SvTYPE(SvRV(*probe)) == SVt_PVHV) {
			  probedata = (HV *)SvRV(*probe);
			  
			  memset(&p, 0, sizeof(p));
			  
			  val = hv_fetch(data, "addr", 4, 0);
			  if (val && *val)
			    p.dofpr_addr = (uint64_t)SvIV(*val);

			  val = hv_fetch(data, "func", 4, 0);
			  if (val && *val)
			    p.dofpr_func = (dof_stridx_t)SvIV(*val);

			  val = hv_fetch(data, "name", 4, 0);
			  if (val && *val)
			    p.dofpr_name = (dof_stridx_t)SvIV(*val);

			  val = hv_fetch(data, "nragv", 5, 0);
			  if (val && *val)
			    p.dofpr_nargv = (dof_stridx_t)SvIV(*val);

			  val = hv_fetch(data, "xargv", 5, 0);
			  if (val && *val)
			    p.dofpr_xargv = (dof_stridx_t)SvIV(*val);

			  val = hv_fetch(data, "argidx", 6, 0);
			  if (val && *val)
			    p.dofpr_argidx = (uint32_t)SvIV(*val);

			  val = hv_fetch(data, "offidx", 6, 0);
			  if (val && *val)
			    p.dofpr_offidx = (uint32_t)SvIV(*val);
    
			  val = hv_fetch(data, "nargc", 5, 0);
			  if (val && *val)
			    p.dofpr_nargc = (uint8_t)SvIV(*val);

			  val = hv_fetch(data, "xargc", 5, 0);
			  if (val && *val)
			    p.dofpr_xargc = (uint8_t)SvIV(*val);

			  val = hv_fetch(data, "noffs", 5, 0);
			  if (val && *val)
			    p.dofpr_noffs = (uint16_t)SvIV(*val);

			  val = hv_fetch(data, "enoffidx", 8, 0);
			  if (val && *val)
			    p.dofpr_enoffidx = (uint32_t)SvIV(*val);

			  val = hv_fetch(data, "nenoffs", 7, 0);
			  if (val && *val)
			    p.dofpr_nenoffs = (uint16_t)SvIV(*val);

			  probedof = newSVpvn((const char *)&p, sizeof(p));
			  sv_catsv(RETVAL, probedof);
			}
		      }
		    }
		  }
                  OUTPUT:
                  RETVAL

