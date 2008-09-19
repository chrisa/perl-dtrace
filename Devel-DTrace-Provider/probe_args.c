#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include "DTrace_Probe.h"

char **
XS_unpack_charPtrPtr (SV *arg)
{
  char **ret;
  AV *av;
  I32 i;
  
  if (!arg || !SvOK (arg) || !SvROK (arg) || (SvTYPE (SvRV (arg)) != SVt_PVAV)) {
    Perl_croak (aTHX_ "array reference expected");
  }
  
  av = (AV *)SvRV (arg);
  ret = (char **)malloc ((av_len(av) + 1) * sizeof(char *));
  
  for (i = 0; i <= av_len (av); i++) {
    SV **elem = av_fetch (av, i, 0);
    
    if (!elem || !*elem) {
      Perl_croak (aTHX_ "undefined element in arg types array?");
    }
    
    ret[i] = SvPV_nolen (*elem);
  }
  ret[av_len (av) + 1] = NULL;
  return ret;
}

void
init_types(char **args, dtrace_probe_t *probe)
{
  int i;

  probe->argc = 0;
  for (i = 0; args[i] != NULL; i++) {
    probe->argc++;
    if (strcmp("char *", args[i]) == 0)
      probe->types[i] = ARGTYPE_STRING;
    if (strcmp("int", args[i]) == 0)
      probe->types[i] = ARGTYPE_INTEGER;
  }
  free(args); // allocated by XS_unpack_charPtrPtr
}
  
void
call_func(void (*func)(), int argc, void **argv)
{
  switch (argc) {
  case 0:
    (void)(*func)();
    break;
  case 1:
    (void)(*func)(argv[0]);
    break;
  case 2:
    (void)(*func)(argv[0], argv[1]);
    break;
  case 3:
    (void)(*func)(argv[0], argv[1], argv[2]);
    break;
  case 4:
    (void)(*func)(argv[0], argv[1], argv[2], argv[3]);
    break;
  case 5:
    (void)(*func)(argv[0], argv[1], argv[2], argv[3], 
		  argv[4]);
    break;
  case 6:
    (void)(*func)(argv[0], argv[1], argv[2], argv[3],
		  argv[4], argv[5]);
    break;
  case 7:
    (void)(*func)(argv[0], argv[1], argv[2], argv[3],
		  argv[4], argv[5], argv[6]);
    break;
  case 8:
    (void)(*func)(argv[0], argv[1], argv[2], argv[3],
		  argv[4], argv[5], argv[6], argv[7]);
    break;
  }
}
