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

SV *
dof_generate_prargs(self)
	SV *self

	INIT:
	HV *data;
	SV **val;
	AV *prargs;
	SV **prarg;
	uint8_t arg;
	int i;

        CODE:
	if (SvROK(self) && SvTYPE(SvRV(self)) == SVt_PVHV) {
	  data = (HV *)SvRV(self);
	  
	  val = hv_fetch(data, "_data", 5, 0);
	  if (val && *val && (SvTYPE(SvRV(*val)) == SVt_PVAV)) {
	    prargs = (AV *)SvRV(*val);

	    RETVAL = newSVpvn("", 0);

	    for (i = 0; i <= av_len(prargs); i++) {
	      prarg = av_fetch(prargs, i, 0);
	      if (prarg && SvIOK(*prarg)) {
	      	arg = (uint8_t)SvIV(*prarg);
	        sv_catpvn(RETVAL, (char *)&arg, 1);
              }
            }
	  }
        }
	OUTPUT:
	RETVAL
	
SV *
dof_generate_proffs(self)
	SV *self

	INIT:
	HV *data;
	SV **val;
	AV *proffs;
	SV **proff;
	uint32_t off;
	int i;

        CODE:
	if (SvROK(self) && SvTYPE(SvRV(self)) == SVt_PVHV) {
	  data = (HV *)SvRV(self);
	  
	  val = hv_fetch(data, "_data", 5, 0);
	  if (val && *val && (SvTYPE(SvRV(*val)) == SVt_PVAV)) {
	    proffs = (AV *)SvRV(*val);

	    RETVAL = newSVpvn("", 0);

	    for (i = 0; i <= av_len(proffs); i++) {
	      proff = av_fetch(proffs, i, 0);
	      if (proff && SvIOK(*proff)) {
	      	off = (uint32_t)SvIV(*proff);
	        sv_catpvn(RETVAL, (char *)&off, 4);
              }
            }
	  }
        }
	OUTPUT:
	RETVAL

SV *
dof_generate_prenoffs(self)
	SV *self

	INIT:
	HV *data;
	SV **val;
	AV *prenoffs;
	SV **prenoff;
	uint32_t enoff;
	int i;

        CODE:
	if (SvROK(self) && SvTYPE(SvRV(self)) == SVt_PVHV) {
	  data = (HV *)SvRV(self);
	  
	  val = hv_fetch(data, "_data", 5, 0);
	  if (val && *val && (SvTYPE(SvRV(*val)) == SVt_PVAV)) {
	    prenoffs = (AV *)SvRV(*val);

	    RETVAL = newSVpvn("", 0);

	    for (i = 0; i <= av_len(prenoffs); i++) {
	      prenoff = av_fetch(prenoffs, i, 0);
	      if (prenoff && SvIOK(*prenoff)) {
	      	enoff = (uint32_t)SvIV(*prenoff);
	        sv_catpvn(RETVAL, (char *)&enoff, 4);
              }
            }
	  }
        }
	OUTPUT:
	RETVAL
	
SV *
dof_generate_provider(self)
	SV *self

	INIT: 
	HV *data;
	HV *provider;
	SV **val;
	dof_provider_t p;
	HV *attrs;
        dof_attr_t attr;
	uint8_t n, d, c;

        CODE:
	if (SvROK(self) && SvTYPE(SvRV(self)) == SVt_PVHV) {
	  data = (HV *)SvRV(self);
	  val = hv_fetch(data, "_data", 5, 0);

	  if (val && *val && (SvTYPE(SvRV(*val)) == SVt_PVHV)) {
	    provider = (HV *)SvRV(*val);

	    fprintf(stderr, "got provider\n");

	    memset(&p, 0, sizeof(p));
	  
	    val = hv_fetch(provider, "strtab", 6, 0);
	    if (val && *val) {
	      fprintf(stderr, "setting strtab\n");
	      p.dofpv_strtab = (dof_secidx_t)SvIV(*val);
	    }

	    val = hv_fetch(provider, "probes", 6, 0);
	    if (val && *val)
	      p.dofpv_probes = (dof_secidx_t)SvIV(*val);
	  
	    val = hv_fetch(provider, "prargs", 6, 0);
	    if (val && *val)
	      p.dofpv_prargs = (dof_secidx_t)SvIV(*val);
	  
	    val = hv_fetch(provider, "proffs", 6, 0);
	    if (val && *val)
	      p.dofpv_proffs = (dof_secidx_t)SvIV(*val);
	  
	    val = hv_fetch(provider, "name", 4, 0);
	    if (val && *val)
	      p.dofpv_name = (dof_stridx_t)SvIV(*val);
	  
	    val = hv_fetch(provider, "prenoffs", 8, 0);
	    if (val && *val)
	      p.dofpv_prenoffs = (dof_secidx_t)SvIV(*val);
	    
	    fprintf(stderr, "%d %d %d %d %d %d",
		    p.dofpv_strtab,
		    p.dofpv_probes,
		    p.dofpv_prargs,
		    p.dofpv_proffs,
		    p.dofpv_name,
		    p.dofpv_prenoffs);

	    val = hv_fetch(provider, "provattr", 8, 0);
	    if (val && *val && SvTYPE(SvRV(*val)) == SVt_PVHV) {
	      attrs = (HV *)SvRV(*val);
	      val = hv_fetch(attrs, "name", 4, 0);
	      if (val && *val && SvIOK(*val))
		n = SvIV(*val);
	      val = hv_fetch(attrs, "data", 4, 0);
	      if (val && *val && SvIOK(*val))
		d = SvIV(*val);
	      val = hv_fetch(attrs, "class", 5, 0);
	      if (val && *val && SvIOK(*val))
		c = SvIV(*val);
	      p.dofpv_provattr = DOF_ATTR(n, d, c);
	    }

	    val = hv_fetch(provider, "modattr", 7, 0);
	    if (val && *val && SvTYPE(SvRV(*val)) == SVt_PVHV) {
	      attrs = (HV *)SvRV(*val);
	      val = hv_fetch(attrs, "name", 4, 0);
	      if (val && *val && SvIOK(*val))
		n = SvIV(*val);
	      val = hv_fetch(attrs, "data", 4, 0);
	      if (val && *val && SvIOK(*val))
		d = SvIV(*val);
	      val = hv_fetch(attrs, "class", 5, 0);
	      if (val && *val && SvIOK(*val))
		c = SvIV(*val);
	      p.dofpv_modattr = DOF_ATTR(n, d, c);
	    }

	    val = hv_fetch(provider, "funcattr", 8, 0);
	    if (val && *val && SvTYPE(SvRV(*val)) == SVt_PVHV) {
	      attrs = (HV *)SvRV(*val);
	      val = hv_fetch(attrs, "name", 4, 0);
	      if (val && *val && SvIOK(*val))
		n = SvIV(*val);
	      val = hv_fetch(attrs, "data", 4, 0);
	      if (val && *val && SvIOK(*val))
		d = SvIV(*val);
	      val = hv_fetch(attrs, "class", 5, 0);
	      if (val && *val && SvIOK(*val))
		c = SvIV(*val);
	      p.dofpv_funcattr = DOF_ATTR(n, d, c);
	    }

	    val = hv_fetch(provider, "nameattr", 8, 0);
	    if (val && *val && SvTYPE(SvRV(*val)) == SVt_PVHV) {
	      attrs = (HV *)SvRV(*val);
	      val = hv_fetch(attrs, "name", 4, 0);
	      if (val && *val && SvIOK(*val))
		n = SvIV(*val);
	      val = hv_fetch(attrs, "data", 4, 0);
	      if (val && *val && SvIOK(*val))
		d = SvIV(*val);
	      val = hv_fetch(attrs, "class", 5, 0);
	      if (val && *val && SvIOK(*val))
		c = SvIV(*val);
	      p.dofpv_nameattr = DOF_ATTR(n, d, c);
	    }

	    val = hv_fetch(provider, "argsattr", 8, 0);
	    if (val && *val && SvTYPE(SvRV(*val)) == SVt_PVHV) {
	      attrs = (HV *)SvRV(*val);
	      val = hv_fetch(attrs, "name", 4, 0);
	      if (val && *val && SvIOK(*val))
		n = SvIV(*val);
	      val = hv_fetch(attrs, "data", 4, 0);
	      if (val && *val && SvIOK(*val))
		d = SvIV(*val);
	      val = hv_fetch(attrs, "class", 5, 0);
	      if (val && *val && SvIOK(*val))
		c = SvIV(*val);
	      p.dofpv_argsattr = DOF_ATTR(n, d, c);
	    }

	    RETVAL = newSVpvn((const char *)&p, sizeof(p));
	  }
	}
        OUTPUT:
	RETVAL

SV *
dof_generate_strtab(self)
	SV *self;
	
	INIT:
	int i;
	SV **val;
	AV *strings;
	SV **string;
	HV *data;

        CODE:
	if (SvROK(self) && SvTYPE(SvRV(self)) == SVt_PVHV) {
	  data = (HV *)SvRV(self);
	  
	  val = hv_fetch(data, "_data", 5, 0);
	  if (val && *val && (SvTYPE(SvRV(*val)) == SVt_PVAV)) {
	    strings = (AV *)SvRV(*val);

	    RETVAL = newSVpvn("", 0);
	    
	    for (i = 0; i <= av_len(strings); i++) {
	      string = av_fetch(strings, i, 0);
	      if (string && SvPOK(*string)) {
		sv_catsv(RETVAL, *string);
		sv_catpvn(RETVAL, "", 1);
	      }
	    }
	  }
	}
	else {
	  RETVAL = &PL_sv_undef;
	}
        OUTPUT:
        RETVAL
	  
