#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <sys/dtrace.h>

MODULE = Devel::DTrace::DOF::Header		PACKAGE = Devel::DTrace::DOF::Header

VERSIONCHECK: DISABLE  

PROTOTYPES: DISABLE

SV *
generate(self)
        SV *self

	INIT:
	HV *data;
	SV **val;
  	dof_hdr_t hdr;
	uint32_t secnum;
  	uint64_t hdrlen;
  	uint8_t dof_version;

	CODE:
	if (SvROK(self) && SvTYPE(SvRV(self)) == SVt_PVHV) {
	  data = (HV *)SvRV(self);	
	  
	  /* XXX apple/solaris */
	  dof_version = DOF_VERSION_3;

	  memset(&hdr, 0, sizeof(hdr));
	  
	  hdr.dofh_ident[DOF_ID_MAG0] = DOF_MAG_MAG0;
	  hdr.dofh_ident[DOF_ID_MAG1] = DOF_MAG_MAG1;
	  hdr.dofh_ident[DOF_ID_MAG2] = DOF_MAG_MAG2;
	  hdr.dofh_ident[DOF_ID_MAG3] = DOF_MAG_MAG3;
	  
	  hdr.dofh_ident[DOF_ID_MODEL]    = DOF_MODEL_NATIVE;
	  hdr.dofh_ident[DOF_ID_ENCODING] = DOF_ENCODE_NATIVE;
	  hdr.dofh_ident[DOF_ID_VERSION]  = dof_version;
	  hdr.dofh_ident[DOF_ID_DIFVERS]  = DIF_VERSION;
	  hdr.dofh_ident[DOF_ID_DIFIREG]  = DIF_DIR_NREGS;
	  hdr.dofh_ident[DOF_ID_DIFTREG]  = DIF_DTR_NREGS;
	  
	  hdr.dofh_hdrsize = sizeof(dof_hdr_t);
	  hdr.dofh_secsize = sizeof(dof_sec_t);
	  
	  val = hv_fetch(data, "_secnum", 7, 0);
	  if (val && *val && SvIOK(*val)) {
	    secnum = (uint32_t)SvIV(*val);
	    hdr.dofh_secnum = secnum;
	  }

	  val = hv_fetch(data, "_loadsz", 7, 0);
	  if (val && *val && SvIOK(*val)) {
	    hdr.dofh_loadsz = (uint64_t)SvIV(*val);
	  }

	  val = hv_fetch(data, "_filesz", 7, 0);
	  if (val && *val && SvIOK(*val)) {
	    hdr.dofh_filesz = (uint64_t)SvIV(*val);
	  }
	  
	  hdrlen = (sizeof(dof_hdr_t) + secnum * sizeof(dof_sec_t));
	  (void)hv_store(data, "_hdrlen", 7, newSViv((IV)hdrlen), 0);
	  hdr.dofh_secoff = sizeof(dof_hdr_t);

	  RETVAL = newSVpvn((const char *)&hdr, sizeof(hdr));
	}
	OUTPUT:
	RETVAL

SV *
hdrlen(self)
	SV *self

	INIT:
  	uint64_t hdrlen;
  	uint32_t secnum;
	SV **val;
	HV *data;
	
	CODE:
	if (SvROK(self) && SvTYPE(SvRV(self)) == SVt_PVHV) {
	  data = (HV *)SvRV(self);	
	  val = hv_fetch(data, "_secnum", 7, 0);
	  if (val && *val && SvIOK(*val)) {
	    secnum = (uint64_t)SvIV(*val);
	  }
	  hdrlen = (sizeof(dof_hdr_t) + secnum * sizeof(dof_sec_t));
	  RETVAL = newSViv((IV)hdrlen);
	} 
	else {
	  RETVAL = &PL_sv_undef;
	}

	OUTPUT:
	RETVAL
