#include <stdlib.h>
#include <sys/mman.h>
#include <string.h>

/* Probe args type constants */
typedef uint8_t dtrace_argtype_t;
#define ARGTYPE_STRING  0
#define ARGTYPE_INTEGER 1

/* Struct wrapping a probe, a handcrafted function created to be a
   probe trigger point, and its corresponding is_enabled tracepoint.

   This is actually a pointer to the is_enabled function (the probe
   function is after) so it's declared to take no args, and return
   int. */
typedef struct dtrace_probe {
  int (*func)();
  uint8_t argc;
  dtrace_argtype_t types[8];
} dtrace_probe_t;

typedef dtrace_probe_t *Devel__DTrace__Probe;

/* Prototype for function to convert Perl array of strings to
   NULL-terminated char ** */
char **XS_unpack_charPtrPtr (SV *arg);
void init_types(char **args, dtrace_probe_t *probe);
void call_func(void (*func)(), int argc, void **argv);
