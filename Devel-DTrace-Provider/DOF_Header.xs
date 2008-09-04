#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <sys/dtrace.h>

static uint8_t
dof_version(uint8_t header_version)
{
  uint8_t dof_version;
  /* DOF versioning: Apple always needs version 3, but Solaris can use
     1 or 2 depending on whether is-enabled probes are needed. */
#ifdef __APPLE__
  dof_version = DOF_VERSION_3;
#else
  switch(header_version) {
  case 1:
    dof_version = DOF_VERSION_1;
    break;
  case 2:
    dof_version = DOF_VERSION_2;
    break;
  default:
    dof_version = DOF_VERSION;
  }
#endif
  return dof_version;
} 

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

	CODE:
	if (SvROK(self) && SvTYPE(SvRV(self)) == SVt_PVHV) {
	  data = (HV *)SvRV(self);	
	  
	  memset(&hdr, 0, sizeof(hdr));
	  
	  hdr.dofh_ident[DOF_ID_MAG0] = DOF_MAG_MAG0;
	  hdr.dofh_ident[DOF_ID_MAG1] = DOF_MAG_MAG1;
	  hdr.dofh_ident[DOF_ID_MAG2] = DOF_MAG_MAG2;
	  hdr.dofh_ident[DOF_ID_MAG3] = DOF_MAG_MAG3;
	  
	  hdr.dofh_ident[DOF_ID_MODEL]    = DOF_MODEL_NATIVE;
	  hdr.dofh_ident[DOF_ID_ENCODING] = DOF_ENCODE_NATIVE;
	  hdr.dofh_ident[DOF_ID_DIFVERS]  = DIF_VERSION;
	  hdr.dofh_ident[DOF_ID_DIFIREG]  = DIF_DIR_NREGS;
	  hdr.dofh_ident[DOF_ID_DIFTREG]  = DIF_DTR_NREGS;

	  val = hv_fetch(data, "_dof_version", 12, 0);
	  if (val && *val && SvIOK(*val))
	    hdr.dofh_ident[DOF_ID_VERSION] = dof_version((uint8_t)SvIV(*val));
	  else
	    hdr.dofh_ident[DOF_ID_VERSION] = dof_version(2); /* default 2, will be 3 on OSX */
	  
	  hdr.dofh_hdrsize = sizeof(dof_hdr_t);
	  hdr.dofh_secsize = sizeof(dof_sec_t);
	  
	  val = hv_fetch(data, "_secnum", 7, 0);
	  if (val && *val && SvIOK(*val)) {
	    secnum = (uint32_t)SvIV(*val);
	    hdr.dofh_secnum = secnum;
	  }
	  else
	    Perl_croak(aTHX_ "No 'secnum' in DOF::Header generate");

	  val = hv_fetch(data, "_loadsz", 7, 0);
	  if (val && *val && SvIOK(*val))
	    hdr.dofh_loadsz = (uint64_t)SvIV(*val);
	  else
	    Perl_croak(aTHX_ "No 'loadsz' in DOF::Header generate");
	  
	  val = hv_fetch(data, "_filesz", 7, 0);
	  if (val && *val && SvIOK(*val))
	    hdr.dofh_filesz = (uint64_t)SvIV(*val);
	  else
	    Perl_croak(aTHX_ "No 'filesz' in DOF::Header generate");
	  	  
	  hdrlen = (sizeof(dof_hdr_t) + secnum * sizeof(dof_sec_t));
	  (void)hv_store(data, "_hdrlen", 7, newSViv((IV)hdrlen), 0);
	  hdr.dofh_secoff = sizeof(dof_hdr_t);

	  RETVAL = newSVpvn((const char *)&hdr, sizeof(hdr));
	}
        else
	  Perl_croak(aTHX_ "self is not a hashref in DOF::Header generate");

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
	  if (val && *val && SvIOK(*val))
	    secnum = (uint64_t)SvIV(*val);
	  else
	    Perl_croak(aTHX_ "No 'secnum' in DOF::Header hdrlen");

	  hdrlen = (sizeof(dof_hdr_t) + secnum * sizeof(dof_sec_t));
	  RETVAL = newSViv((IV)hdrlen);
	} 
	else
	  Perl_croak(aTHX_ "self is not a hashref in DOF::Header hdrlen");

	OUTPUT:
	RETVAL
