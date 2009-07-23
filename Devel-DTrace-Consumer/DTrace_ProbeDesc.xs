#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include "dtrace_consumer.h"

typedef dtc_probedesc_t *Devel__DTrace__ProbeDesc;

MODULE = Devel::DTrace::ProbeDesc        PACKAGE = Devel::DTrace::ProbeDesc

PROTOTYPES: ENABLE

VERSIONCHECK: DISABLE

SV *
provider(self)
Devel::DTrace::ProbeDesc self
  CODE:
  RETVAL = newSVpvn(self->probe->dtpd_provider, DTRACE_PROVNAMELEN);
  OUTPUT:
  RETVAL

SV *
module(self)
Devel::DTrace::ProbeDesc self
  CODE:
  RETVAL = newSVpvn(self->probe->dtpd_mod, DTRACE_MODNAMELEN);
  OUTPUT:
  RETVAL

SV *
function(self)
Devel::DTrace::ProbeDesc self
  CODE:
  RETVAL = newSVpvn(self->probe->dtpd_func, DTRACE_FUNCNAMELEN);
  OUTPUT:
  RETVAL

SV *
name(self)
Devel::DTrace::ProbeDesc self
  CODE:
  RETVAL = newSVpvn(self->probe->dtpd_name, DTRACE_NAMELEN);
  OUTPUT:
  RETVAL
