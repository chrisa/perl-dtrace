#include <dtrace.h>

typedef struct dtc_context {
  dtrace_hdl_t *hdl;
} dtc_context_t;

typedef struct dtc_probedesc {
  const dtrace_probedesc_t *probe;
} dtc_probedesc_t;
