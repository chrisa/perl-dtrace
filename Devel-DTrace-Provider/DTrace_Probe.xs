#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

/* Struct wrapping a probe, a handcrafted function created to be a
   probe trigger point, and its corresponding is_enabled tracepoint.

   This is actually a pointer to the is_enabled function (the probe
   function is after) so it's declared to take no args, and return
   int. */
typedef struct dtrace_probe {
  int (*func)();
} dtrace_probe_t;


#define FUNC_SIZE 128 /* 32 bytes of is_enabled, plus then good for 16
			 arguments: 16 + 7 * argc */
#define IS_ENABLED_FUNC_LEN 32
	
#define OP_PUSHL_EBP      0x55
#define OP_MOVL_ESP_EBP_U 0x89
#define OP_MOVL_ESP_EBP_L 0xe5
#define OP_SUBL_N_ESP_U   0x83
#define OP_SUBL_N_ESP_L   0xec
#define OP_PUSHL_N_EBP_U  0xff
#define OP_PUSHL_N_EBP_L  0x75
#define OP_NOP            0x90
#define OP_ADDL_ESP_U     0x83
#define OP_ADDL_ESP_L     0xc4
#define OP_LEAVE  	  0xc9
#define OP_RET    	  0xc3
#define OP_MOVL_EAX_U     0x8b
#define OP_MOVL_EAX_L     0x45
#define OP_MOVL_ESP       0x89

#include <stdlib.h>
#include <sys/mman.h>

typedef dtrace_probe_t *Devel__DTrace__Probe;

MODULE = Devel::DTrace::Probe		PACKAGE = Devel::DTrace::Probe

PROTOTYPES: ENABLE

Devel::DTrace::Probe
new(package, argc)
	char *package
	int argc
	
	INIT:
  	uint8_t *ip;
  	int i;

	/* First initialise the is_enabled tracepoint */
        uint8_t insns[FUNC_SIZE] = {
	  0x55, 0x89, 0xe5, 0x83, 0xec, 0x08,
	  0x33, 0xc0,
	  0x90, 0x90, 0x90,
	  0xc9, 0xc3
	};

	CODE:
	RETVAL = malloc(sizeof(dtrace_probe_t));

  /* Set up probe function */
  ip = insns + IS_ENABLED_FUNC_LEN;

  *ip++ = OP_PUSHL_EBP;
  *ip++ = OP_MOVL_ESP_EBP_U;
  *ip++ = OP_MOVL_ESP_EBP_L;
  *ip++ = OP_SUBL_N_ESP_U;
  *ip++ = OP_SUBL_N_ESP_L;

  switch(argc) {
  case 0:
  case 1:
  case 2:
  case 3:
  case 4:
  case 5:
  case 6:
    *ip++ = 0x18;
    break;
  case 7:
  case 8:
    *ip++ = 0x28;
    break;
  }

  /* args */
  for (i = (4*argc - 4); i >= 0; i -= 4) {
    /* mov 0xN(%ebp),%eax */
    *ip++ = OP_MOVL_EAX_U;
    *ip++ = OP_MOVL_EAX_L;
    *ip++ = i + 8; 
    /* mov %eax,N(%esp) */
    *ip++ = OP_MOVL_ESP;
    if (i > 0) {
      *ip++ = 0x44;
      *ip++ = 0x24;
      *ip++ = i;
    }
    else {
      *ip++ = 0x04;
      *ip++ = 0x24;
    }
  }
  
  /* tracepoint */
  *ip++ = 0x90;
  *ip++ = 0x0f;
  *ip++ = 0x1f;
  *ip++ = 0x40;
  *ip++ = 0x00;

  /* ret */
  *ip++ = OP_LEAVE;
  *ip++ = OP_RET;

  /* allocate memory on a page boundary, for mprotect */
  RETVAL->func = (void *)valloc(FUNC_SIZE);
  (void)mprotect((void *)RETVAL->func, FUNC_SIZE, PROT_READ | PROT_WRITE | PROT_EXEC);
  memcpy(RETVAL->func, insns, FUNC_SIZE);

	OUTPUT:
	RETVAL

void
DESTROY(self)
	Devel::DTrace::Probe self
	CODE:
	free(self->func);
    	free(self);
	
SV *
addr(self)
	Devel::DTrace::Probe self
	CODE:
	RETVAL = newSViv((IV)self->func);
	OUTPUT:
	RETVAL

SV *
is_enabled(self)
	Devel::DTrace::Probe self
	CODE:
	RETVAL = newSViv((IV)(int)(*self->func)());
	OUTPUT:
	RETVAL

void
fire(self, ...)
	Devel::DTrace::Probe self
	PREINIT:
	int i;
	void *argv[8]; // probe argc max for now.
  	void (*func)();
	STRLEN n_a;
	CODE:
	/* munge Ruby values to either char *s or ints. */
  	for (i = 0; i < items; i++) {
	  switch (SvTYPE(ST(i))) {
	    case SVt_PV:
	      argv[i] = (void *)SvPV(ST(i), SvCUR(ST(i)));
	      break;
	    case SVt_IV:
	      argv[i] = (void *)SvIV(ST(i));
	      break;
    	  }
	}
  
        func = (void (*)())(self->func + IS_ENABLED_FUNC_LEN);

  switch (items) {
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
  
SV *
probe_offset(self, file_addr, argc)
	Devel::DTrace::Probe self
	int file_addr
	int argc
	PREINIT:
	int offset;
	CODE:
	switch (argc) {
	  case 0:
      	    offset = 40; /* 32 + 6 + 2 */
            break;
          case 1:
            offset = 46; /* 32 + 6 + 6 + 2 */
            break;
          default:
            offset = 46 + ((argc-1) * 7); /* 32 + 6 + 6 + 7 per subsequent arg + 2 */
            break;
          }
	RETVAL = newSViv((IV)((int)self->func - file_addr + offset));
	OUTPUT:
	RETVAL

SV *
is_enabled_offset(self, file_addr)
	Devel::DTrace::Probe self
	int file_addr
	CODE:
	RETVAL = newSViv((IV)((int)self->func - file_addr + 8));
	OUTPUT:
	RETVAL
