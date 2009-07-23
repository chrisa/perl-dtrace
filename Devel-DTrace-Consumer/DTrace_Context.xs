#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include "dtrace_consumer.h"

typedef dtc_context_t *Devel__DTrace__Context;

int _probe_iter(dtrace_hdl_t *hdl, const dtrace_probedesc_t *pdp, void *arg)
{
  SV *callback = (SV *)arg;

  dtc_probedesc_t pd;
  SV *probe = sv_newmortal();

  pd.probe = pdp;
  sv_setref_pv(probe, "Devel::DTrace::ProbeDesc", &pd);

  dSP;
  
  ENTER;
  SAVETMPS;
  
  PUSHMARK(SP);
  XPUSHs(probe);
  PUTBACK;
  
  call_sv(callback, G_DISCARD);

  FREETMPS;
  LEAVE;
}

MODULE = Devel::DTrace::Context        PACKAGE = Devel::DTrace::Context

PROTOTYPES: ENABLE

VERSIONCHECK: DISABLE

Devel::DTrace::Context
new(package)
  char *package;
PREINIT:
  dtrace_hdl_t *hdl;
  int err;
CODE:
{
  hdl = dtrace_open(DTRACE_VERSION, 0, &err);
  
  if (!hdl)
    Perl_croak(aTHX_ "Unable to open dtrace (not root / no permission?)");
  
  /*
   * Leopard's DTrace requires symbol resolution to be 
   * switched on explicitly 
   */ 
#ifdef __APPLE__
    (void) dtrace_setopt(hdl, "stacksymbols", "enabled");
#endif
    
    /* always request flowindent information */
    (void) dtrace_setopt(hdl, "flowindent", 0);

    RETVAL = (dtc_context_t *)malloc(sizeof(dtc_context_t));
    if (RETVAL == NULL)
      Perl_croak(aTHX_ "Failed to allocate memory for DTrace::Context: %s", strerror(errno));
    
    RETVAL->hdl = hdl;
}
OUTPUT:
RETVAL

int
_probes(self, callback)
Devel::DTrace::Context self;
SV *callback;
CODE:
{
  (void) dtrace_probe_iter(self->hdl, NULL, _probe_iter, (void *)callback);
}
OUTPUT:
RETVAL
  
