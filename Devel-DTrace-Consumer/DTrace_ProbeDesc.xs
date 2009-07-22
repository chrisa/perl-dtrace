#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include "dtrace_consumer.h"

typedef dtc_probedesc_t *Devel__DTrace__ProbeDesc;

MODULE = Devel::DTrace::ProbeDesc        PACKAGE = Devel::DTrace::ProbeDesc

PROTOTYPES: ENABLE

VERSIONCHECK: DISABLE
