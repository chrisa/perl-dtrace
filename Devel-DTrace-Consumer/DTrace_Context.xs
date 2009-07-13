#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include "dtrace_consumer.h"

typedef dtrace_context_t *Devel__DTrace__Context;

MODULE = Devel::DTrace::Context        PACKAGE = Devel::DTrace::Context

PROTOTYPES: ENABLE

VERSIONCHECK: DISABLE

Devel::DTrace::Context
new(package)
  char *package
  PREINIT:
  dtrace_hdl_t *hdl;
  int err;
  CODE:
  hdl = dtrace_open(DTRACE_VERSION, 0, &err);
  
  if (hdl) {
    /*
     * Leopard's DTrace requires symbol resolution to be 
     * switched on explicitly 
     */ 
#ifdef __APPLE__
    (void) dtrace_setopt(hdl, "stacksymbols", "enabled");
#endif

    /* always request flowindent information */
    (void) dtrace_setopt(hdl, "flowindent", 0);

    RETVAL = (dtrace_context_t *)malloc(sizeof(dtrace_context_t));
    if (RETVAL == NULL)
      Perl_croak(aTHX_ "Failed to allocate memory for DTrace::Context: %s", strerror(errno));

    RETVAL->hdl   = hdl;
  }
  else {
    Perl_croak(aTHX_ "Unable to open dtrace (not root / no permission?)");
  }

  OUTPUT:
  RETVAL
