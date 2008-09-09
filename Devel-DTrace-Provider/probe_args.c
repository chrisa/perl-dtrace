#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

void *
argval(SV *arg)
{
  void *val;

  switch (SvTYPE(arg)) {
  case SVt_PVIV:
    if (SvPOK(arg))
      val = (void *)SvPV(arg, SvCUR(arg));
    else
      val = (void *)SvIV(arg);
    break;
  case SVt_PV:
    val = (void *)SvPV(arg, SvCUR(arg));
    break;
  case SVt_IV:
    val = (void *)SvIV(arg);	   
    break;
  case SVt_PVNV:
    if (SvPOK(arg))
      val = (void *)SvPV(arg, SvCUR(arg));
    else if (SvIOK(arg) && SvIsUV(arg))
      val = (void *)SvUV(arg);
    else
      val = (void *)SvIV(arg);
    break;
  }
  return val;
}
