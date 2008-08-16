#define PERL_constant_NOTFOUND	1
#define PERL_constant_NOTDEF	2
#define PERL_constant_ISIV	3
#define PERL_constant_ISNO	4
#define PERL_constant_ISNV	5
#define PERL_constant_ISPV	6
#define PERL_constant_ISPVN	7
#define PERL_constant_ISSV	8
#define PERL_constant_ISUNDEF	9
#define PERL_constant_ISUV	10
#define PERL_constant_ISYES	11

#ifndef NVTYPE
typedef double NV; /* 5.6 and later define NVTYPE, and typedef NV to it.  */
#endif
#ifndef aTHX_
#define aTHX_ /* 5.6 or later define this for threading support.  */
#endif
#ifndef pTHX_
#define pTHX_ /* 5.6 or later define this for threading support.  */
#endif
static int
constant_11 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     DOF_ID_MAG0 DOF_ID_MAG1 DOF_ID_MAG2 DOF_ID_MAG3 DOF_ID_SIZE DOF_VERSION */
  /* Offset 10 gives the best switch position.  */
  switch (name[10]) {
  case '0':
    if (memEQ(name, "DOF_ID_MAG", 10)) {
    /*                         0      */
#ifdef DOF_ID_MAG0
      *iv_return = DOF_ID_MAG0;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '1':
    if (memEQ(name, "DOF_ID_MAG", 10)) {
    /*                         1      */
#ifdef DOF_ID_MAG1
      *iv_return = DOF_ID_MAG1;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '2':
    if (memEQ(name, "DOF_ID_MAG", 10)) {
    /*                         2      */
#ifdef DOF_ID_MAG2
      *iv_return = DOF_ID_MAG2;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '3':
    if (memEQ(name, "DOF_ID_MAG", 10)) {
    /*                         3      */
#ifdef DOF_ID_MAG3
      *iv_return = DOF_ID_MAG3;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'E':
    if (memEQ(name, "DOF_ID_SIZ", 10)) {
    /*                         E      */
#ifdef DOF_ID_SIZE
      *iv_return = DOF_ID_SIZE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'N':
    if (memEQ(name, "DOF_VERSIO", 10)) {
    /*                         N      */
#ifdef DOF_VERSION
      *iv_return = DOF_VERSION;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_12 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     DOF_FL_VALID DOF_ID_MODEL DOF_MAG_MAG0 DOF_MAG_MAG1 DOF_MAG_MAG2
     DOF_MAG_MAG3 DOF_SECT_DIF */
  /* Offset 11 gives the best switch position.  */
  switch (name[11]) {
  case '0':
    if (memEQ(name, "DOF_MAG_MAG", 11)) {
    /*                          0      */
#ifdef DOF_MAG_MAG0
      *iv_return = DOF_MAG_MAG0;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '1':
    if (memEQ(name, "DOF_MAG_MAG", 11)) {
    /*                          1      */
#ifdef DOF_MAG_MAG1
      *iv_return = DOF_MAG_MAG1;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '2':
    if (memEQ(name, "DOF_MAG_MAG", 11)) {
    /*                          2      */
#ifdef DOF_MAG_MAG2
      *iv_return = DOF_MAG_MAG2;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '3':
    if (memEQ(name, "DOF_MAG_MAG", 11)) {
    /*                          3      */
#ifdef DOF_MAG_MAG3
      *iv_return = DOF_MAG_MAG3;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'D':
    if (memEQ(name, "DOF_FL_VALI", 11)) {
    /*                          D      */
#ifdef DOF_FL_VALID
      *iv_return = DOF_FL_VALID;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'F':
    if (memEQ(name, "DOF_SECT_DI", 11)) {
    /*                          F      */
#ifdef DOF_SECT_DIF
      *iv_return = DOF_SECT_DIF;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'L':
    if (memEQ(name, "DOF_ID_MODE", 11)) {
    /*                          L      */
#ifdef DOF_ID_MODEL
      *iv_return = DOF_ID_MODEL;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_13 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     DOF_RELO_NONE DOF_RELO_SETX DOF_SECF_LOAD DOF_SECT_NONE DOF_VERSION_1
     DOF_VERSION_2 DOF_VERSION_3 */
  /* Offset 12 gives the best switch position.  */
  switch (name[12]) {
  case '1':
    if (memEQ(name, "DOF_VERSION_", 12)) {
    /*                           1      */
#ifdef DOF_VERSION_1
      *iv_return = DOF_VERSION_1;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '2':
    if (memEQ(name, "DOF_VERSION_", 12)) {
    /*                           2      */
#ifdef DOF_VERSION_2
      *iv_return = DOF_VERSION_2;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '3':
    if (memEQ(name, "DOF_VERSION_", 12)) {
    /*                           3      */
#ifdef DOF_VERSION_3
      *iv_return = DOF_VERSION_3;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'D':
    if (memEQ(name, "DOF_SECF_LOA", 12)) {
    /*                           D      */
#ifdef DOF_SECF_LOAD
      *iv_return = DOF_SECF_LOAD;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'E':
    if (memEQ(name, "DOF_RELO_NON", 12)) {
    /*                           E      */
#ifdef DOF_RELO_NONE
      *iv_return = DOF_RELO_NONE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "DOF_SECT_NON", 12)) {
    /*                           E      */
#ifdef DOF_SECT_NONE
      *iv_return = DOF_SECT_NONE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'X':
    if (memEQ(name, "DOF_RELO_SET", 12)) {
    /*                           X      */
#ifdef DOF_RELO_SETX
      *iv_return = DOF_RELO_SETX;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_14 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     DOF_ENCODE_LSB DOF_ENCODE_MSB DOF_ID_DIFIREG DOF_ID_DIFTREG DOF_ID_DIFVERS
     DOF_ID_VERSION DOF_MAG_STRLEN DOF_MODEL_LP64 DOF_MODEL_NONE DOF_SECT_XLTAB
     */
  /* Offset 11 gives the best switch position.  */
  switch (name[11]) {
  case 'E':
    if (memEQ(name, "DOF_ID_DIFVERS", 14)) {
    /*                          ^         */
#ifdef DOF_ID_DIFVERS
      *iv_return = DOF_ID_DIFVERS;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'I':
    if (memEQ(name, "DOF_ID_VERSION", 14)) {
    /*                          ^         */
#ifdef DOF_ID_VERSION
      *iv_return = DOF_ID_VERSION;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'L':
    if (memEQ(name, "DOF_ENCODE_LSB", 14)) {
    /*                          ^         */
#ifdef DOF_ENCODE_LSB
      *iv_return = DOF_ENCODE_LSB;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "DOF_MAG_STRLEN", 14)) {
    /*                          ^         */
#ifdef DOF_MAG_STRLEN
      *iv_return = DOF_MAG_STRLEN;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'M':
    if (memEQ(name, "DOF_ENCODE_MSB", 14)) {
    /*                          ^         */
#ifdef DOF_ENCODE_MSB
      *iv_return = DOF_ENCODE_MSB;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'O':
    if (memEQ(name, "DOF_MODEL_NONE", 14)) {
    /*                          ^         */
#ifdef DOF_MODEL_NONE
      *iv_return = DOF_MODEL_NONE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'P':
    if (memEQ(name, "DOF_MODEL_LP64", 14)) {
    /*                          ^         */
#ifdef DOF_MODEL_LP64
      *iv_return = DOF_MODEL_LP64;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'R':
    if (memEQ(name, "DOF_ID_DIFIREG", 14)) {
    /*                          ^         */
#ifdef DOF_ID_DIFIREG
      *iv_return = DOF_ID_DIFIREG;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "DOF_ID_DIFTREG", 14)) {
    /*                          ^         */
#ifdef DOF_ID_DIFTREG
      *iv_return = DOF_ID_DIFTREG;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'T':
    if (memEQ(name, "DOF_SECT_XLTAB", 14)) {
    /*                          ^         */
#ifdef DOF_SECT_XLTAB
      *iv_return = DOF_SECT_XLTAB;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_15 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     DOF_ENCODE_NONE DOF_ID_ENCODING DOF_MODEL_ILP32 DOF_SECIDX_NONE
     DOF_SECT_INTTAB DOF_SECT_PRARGS DOF_SECT_PROBES DOF_SECT_PROFFS
     DOF_SECT_RELTAB DOF_SECT_SOURCE DOF_SECT_STRTAB DOF_SECT_TYPTAB
     DOF_SECT_VARTAB DOF_STRIDX_NONE */
  /* Offset 9 gives the best switch position.  */
  switch (name[9]) {
  case 'C':
    if (memEQ(name, "DOF_ID_ENCODING", 15)) {
    /*                        ^            */
#ifdef DOF_ID_ENCODING
      *iv_return = DOF_ID_ENCODING;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'E':
    if (memEQ(name, "DOF_ENCODE_NONE", 15)) {
    /*                        ^            */
#ifdef DOF_ENCODE_NONE
      *iv_return = DOF_ENCODE_NONE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'I':
    if (memEQ(name, "DOF_SECT_INTTAB", 15)) {
    /*                        ^            */
#ifdef DOF_SECT_INTTAB
      *iv_return = DOF_SECT_INTTAB;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'P':
    if (memEQ(name, "DOF_SECT_PRARGS", 15)) {
    /*                        ^            */
#ifdef DOF_SECT_PRARGS
      *iv_return = DOF_SECT_PRARGS;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "DOF_SECT_PROBES", 15)) {
    /*                        ^            */
#ifdef DOF_SECT_PROBES
      *iv_return = DOF_SECT_PROBES;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "DOF_SECT_PROFFS", 15)) {
    /*                        ^            */
#ifdef DOF_SECT_PROFFS
      *iv_return = DOF_SECT_PROFFS;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'R':
    if (memEQ(name, "DOF_SECT_RELTAB", 15)) {
    /*                        ^            */
#ifdef DOF_SECT_RELTAB
      *iv_return = DOF_SECT_RELTAB;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'S':
    if (memEQ(name, "DOF_SECT_SOURCE", 15)) {
    /*                        ^            */
#ifdef DOF_SECT_SOURCE
      *iv_return = DOF_SECT_SOURCE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "DOF_SECT_STRTAB", 15)) {
    /*                        ^            */
#ifdef DOF_SECT_STRTAB
      *iv_return = DOF_SECT_STRTAB;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'T':
    if (memEQ(name, "DOF_SECT_TYPTAB", 15)) {
    /*                        ^            */
#ifdef DOF_SECT_TYPTAB
      *iv_return = DOF_SECT_TYPTAB;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'V':
    if (memEQ(name, "DOF_SECT_VARTAB", 15)) {
    /*                        ^            */
#ifdef DOF_SECT_VARTAB
      *iv_return = DOF_SECT_VARTAB;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'X':
    if (memEQ(name, "DOF_SECIDX_NONE", 15)) {
    /*                        ^            */
#ifdef DOF_SECIDX_NONE
      *iv_return = DOF_SECIDX_NONE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "DOF_STRIDX_NONE", 15)) {
    /*                        ^            */
#ifdef DOF_STRIDX_NONE
      *iv_return = DOF_STRIDX_NONE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '_':
    if (memEQ(name, "DOF_MODEL_ILP32", 15)) {
    /*                        ^            */
#ifdef DOF_MODEL_ILP32
      *iv_return = DOF_MODEL_ILP32;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_16 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     DOF_MODEL_NATIVE DOF_SECT_ACTDESC DOF_SECT_DIFOHDR DOF_SECT_ECBDESC
     DOF_SECT_KRELHDR DOF_SECT_OPTDESC DOF_SECT_URELHDR DOF_SECT_UTSNAME */
  /* Offset 9 gives the best switch position.  */
  switch (name[9]) {
  case 'A':
    if (memEQ(name, "DOF_SECT_ACTDESC", 16)) {
    /*                        ^             */
#ifdef DOF_SECT_ACTDESC
      *iv_return = DOF_SECT_ACTDESC;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'D':
    if (memEQ(name, "DOF_SECT_DIFOHDR", 16)) {
    /*                        ^             */
#ifdef DOF_SECT_DIFOHDR
      *iv_return = DOF_SECT_DIFOHDR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'E':
    if (memEQ(name, "DOF_SECT_ECBDESC", 16)) {
    /*                        ^             */
#ifdef DOF_SECT_ECBDESC
      *iv_return = DOF_SECT_ECBDESC;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'K':
    if (memEQ(name, "DOF_SECT_KRELHDR", 16)) {
    /*                        ^             */
#ifdef DOF_SECT_KRELHDR
      *iv_return = DOF_SECT_KRELHDR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'O':
    if (memEQ(name, "DOF_SECT_OPTDESC", 16)) {
    /*                        ^             */
#ifdef DOF_SECT_OPTDESC
      *iv_return = DOF_SECT_OPTDESC;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'U':
    if (memEQ(name, "DOF_SECT_URELHDR", 16)) {
    /*                        ^             */
#ifdef DOF_SECT_URELHDR
      *iv_return = DOF_SECT_URELHDR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "DOF_SECT_UTSNAME", 16)) {
    /*                        ^             */
#ifdef DOF_SECT_UTSNAME
      *iv_return = DOF_SECT_UTSNAME;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '_':
    if (memEQ(name, "DOF_MODEL_NATIVE", 16)) {
    /*                        ^             */
#ifdef DOF_MODEL_NATIVE
      *iv_return = DOF_MODEL_NATIVE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_17 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     DOF_ENCODE_NATIVE DOF_SECT_COMMENTS DOF_SECT_PRENOFFS DOF_SECT_PREXPORT
     DOF_SECT_PROVIDER DOF_SECT_XLEXPORT DOF_SECT_XLIMPORT */
  /* Offset 12 gives the best switch position.  */
  switch (name[12]) {
  case 'A':
    if (memEQ(name, "DOF_ENCODE_NATIVE", 17)) {
    /*                           ^           */
#ifdef DOF_ENCODE_NATIVE
      *iv_return = DOF_ENCODE_NATIVE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'M':
    if (memEQ(name, "DOF_SECT_COMMENTS", 17)) {
    /*                           ^           */
#ifdef DOF_SECT_COMMENTS
      *iv_return = DOF_SECT_COMMENTS;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "DOF_SECT_XLIMPORT", 17)) {
    /*                           ^           */
#ifdef DOF_SECT_XLIMPORT
      *iv_return = DOF_SECT_XLIMPORT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'N':
    if (memEQ(name, "DOF_SECT_PRENOFFS", 17)) {
    /*                           ^           */
#ifdef DOF_SECT_PRENOFFS
      *iv_return = DOF_SECT_PRENOFFS;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'V':
    if (memEQ(name, "DOF_SECT_PROVIDER", 17)) {
    /*                           ^           */
#ifdef DOF_SECT_PROVIDER
      *iv_return = DOF_SECT_PROVIDER;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'X':
    if (memEQ(name, "DOF_SECT_PREXPORT", 17)) {
    /*                           ^           */
#ifdef DOF_SECT_PREXPORT
      *iv_return = DOF_SECT_PREXPORT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    if (memEQ(name, "DOF_SECT_XLEXPORT", 17)) {
    /*                           ^           */
#ifdef DOF_SECT_XLEXPORT
      *iv_return = DOF_SECT_XLEXPORT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant (pTHX_ const char *name, STRLEN len, IV *iv_return) {
  /* Initially switch on the length of the name.  */
  /* When generated this function returned values for the list of names given
     in this section of perl code.  Rather than manually editing these functions
     to add or remove constants, which would result in this comment and section
     of code becoming inaccurate, we recommend that you edit this section of
     code, and use it to regenerate a new set of constant functions which you
     then use to replace the originals.

     Regenerate these constant functions by feeding this entire source file to
     perl -x

#!perl -w
use ExtUtils::Constant qw (constant_types C_constant XS_constant);

my $types = {map {($_, 1)} qw(IV)};
my @names = (qw(DOF_ENCODE_LSB DOF_ENCODE_MSB DOF_ENCODE_NATIVE DOF_ENCODE_NONE
	       DOF_FL_VALID DOF_ID_DIFIREG DOF_ID_DIFTREG DOF_ID_DIFVERS
	       DOF_ID_ENCODING DOF_ID_MAG0 DOF_ID_MAG1 DOF_ID_MAG2 DOF_ID_MAG3
	       DOF_ID_MODEL DOF_ID_PAD DOF_ID_SIZE DOF_ID_VERSION DOF_MAG_MAG0
	       DOF_MAG_MAG1 DOF_MAG_MAG2 DOF_MAG_MAG3 DOF_MAG_STRLEN
	       DOF_MODEL_ILP32 DOF_MODEL_LP64 DOF_MODEL_NATIVE DOF_MODEL_NONE
	       DOF_RELO_NONE DOF_RELO_SETX DOF_SECF_LOAD DOF_SECIDX_NONE
	       DOF_SECT_ACTDESC DOF_SECT_COMMENTS DOF_SECT_DIF DOF_SECT_DIFOHDR
	       DOF_SECT_ECBDESC DOF_SECT_INTTAB DOF_SECT_KRELHDR DOF_SECT_NONE
	       DOF_SECT_OPTDESC DOF_SECT_PRARGS DOF_SECT_PRENOFFS
	       DOF_SECT_PREXPORT DOF_SECT_PROBEDESC DOF_SECT_PROBES
	       DOF_SECT_PROFFS DOF_SECT_PROVIDER DOF_SECT_RELTAB
	       DOF_SECT_SOURCE DOF_SECT_STRTAB DOF_SECT_TYPTAB DOF_SECT_URELHDR
	       DOF_SECT_UTSNAME DOF_SECT_VARTAB DOF_SECT_XLEXPORT
	       DOF_SECT_XLIMPORT DOF_SECT_XLMEMBERS DOF_SECT_XLTAB
	       DOF_STRIDX_NONE DOF_VERSION DOF_VERSION_1 DOF_VERSION_2
	       DOF_VERSION_3 DTRACE_STABILITY_EVOLVING
	       DTRACE_STABILITY_PRIVATE));

print constant_types(); # macro defs
foreach (C_constant ("Dtrace", 'constant', 'IV', $types, undef, 3, @names) ) {
    print $_, "\n"; # C constant subs
}
print "#### XS Section:\n";
print XS_constant ("Dtrace", $types);
__END__
   */

  switch (len) {
  case 10:
    if (memEQ(name, "DOF_ID_PAD", 10)) {
#ifdef DOF_ID_PAD
      *iv_return = DOF_ID_PAD;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 11:
    return constant_11 (aTHX_ name, iv_return);
    break;
  case 12:
    return constant_12 (aTHX_ name, iv_return);
    break;
  case 13:
    return constant_13 (aTHX_ name, iv_return);
    break;
  case 14:
    return constant_14 (aTHX_ name, iv_return);
    break;
  case 15:
    return constant_15 (aTHX_ name, iv_return);
    break;
  case 16:
    return constant_16 (aTHX_ name, iv_return);
    break;
  case 17:
    return constant_17 (aTHX_ name, iv_return);
    break;
  case 18:
    /* Names all of length 18.  */
    /* DOF_SECT_PROBEDESC DOF_SECT_XLMEMBERS */
    /* Offset 16 gives the best switch position.  */
    switch (name[16]) {
    case 'R':
      if (memEQ(name, "DOF_SECT_XLMEMBERS", 18)) {
      /*                               ^        */
#ifdef DOF_SECT_XLMEMBERS
        *iv_return = DOF_SECT_XLMEMBERS;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    case 'S':
      if (memEQ(name, "DOF_SECT_PROBEDESC", 18)) {
      /*                               ^        */
#ifdef DOF_SECT_PROBEDESC
        *iv_return = DOF_SECT_PROBEDESC;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    }
    break;
  case 24:
    if (memEQ(name, "DTRACE_STABILITY_PRIVATE", 24)) {
#ifdef DTRACE_STABILITY_PRIVATE
      *iv_return = DTRACE_STABILITY_PRIVATE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 25:
    if (memEQ(name, "DTRACE_STABILITY_EVOLVING", 25)) {
#ifdef DTRACE_STABILITY_EVOLVING
      *iv_return = DTRACE_STABILITY_EVOLVING;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

