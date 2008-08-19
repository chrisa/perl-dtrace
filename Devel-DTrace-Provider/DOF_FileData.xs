#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

/* Struct to contain ::DOF::FileData allocated memory */
typedef struct dof_file {
  char *dof;
  uint32_t len;
  uint32_t offset;
} dof_file_t;

typedef dof_file_t *Devel__DTrace__DOF__FileData;

#include <errno.h>
#include <string.h>
#include <fcntl.h>
#include <sys/dtrace.h>

#ifdef __APPLE__
static const char *helper = "/dev/dtracehelper";

int _loaddof(int fd, dof_helper_t *dh)
{
  int ret;
  uint8_t buffer[sizeof(dof_ioctl_data_t) + sizeof(dof_helper_t)];
  dof_ioctl_data_t* ioctlData = (dof_ioctl_data_t*)buffer;
  user_addr_t val;

  ioctlData->dofiod_count = 1LL;
  memcpy(&ioctlData->dofiod_helpers[0], dh, sizeof(dof_helper_t));

  val = (user_addr_t)(unsigned long)ioctlData;
  ret = ioctl(fd, DTRACEHIOC_ADDDOF, &val);
  
  return ret;
}

#else /* Solaris */

/* ignore Sol10 GA ... */
static const char *helper = "/dev/dtrace/helper";

int _loaddof(int fd, dof_helper_t *dh)
{
  return ioctl(fd, DTRACEHIOC_ADDDOF, dh);
}

#endif

MODULE = Devel::DTrace::DOF::FileData		PACKAGE = Devel::DTrace::DOF::FileData

PROTOTYPES: ENABLE

VERSIONCHECK: DISABLE  

Devel::DTrace::DOF::FileData
new(package)
        char *package
	CODE:
	RETVAL = (dof_file_t *)malloc(sizeof(dof_file_t));
	RETVAL->dof = NULL;
	RETVAL->len = 0;
	RETVAL->offset = 0;
	OUTPUT:
	RETVAL
	
void
DESTROY(file)
	Devel::DTrace::DOF::FileData file
	CODE:
	free(file->dof);
	free(file);

void
allocate(self, size)
	Devel::DTrace::DOF::FileData self
	SV *size
	CODE:
	self->len = SvIV(size);
	self->dof = (char *)malloc(sizeof(char) * self->len);
	if (self->dof == NULL)
	  Perl_croak(aTHX_ "Failed to allocate memory for DOF: %s", strerror(errno));

void
append(self, data)
	Devel::DTrace::DOF::FileData self
	SV *data
	CODE:
	memcpy((self->dof + self->offset), SvPV(data, SvCUR(data)), SvCUR(data));
	self->offset += SvCUR(data);

SV *
addr(self)
	Devel::DTrace::DOF::FileData self
	CODE:
	RETVAL = newSViv((IV)self->dof);
	OUTPUT:
	RETVAL

SV *
data(self)
	Devel::DTrace::DOF::FileData self
	CODE:
	RETVAL = newSVpvn(self->dof, self->offset);
	OUTPUT:
	RETVAL

void
loaddof(self, module_name)
	Devel::DTrace::DOF::FileData self
	char *module_name
	PREINIT:
  	dof_helper_t dh;
  	int fd;
  	int gen;
  	dof_file_t *file;
  	dof_hdr_t *dof;
	CODE:
	dof = (dof_hdr_t *)self->dof;
	
	if (dof->dofh_ident[DOF_ID_MAG0] != DOF_MAG_MAG0 ||
      	  dof->dofh_ident[DOF_ID_MAG1] != DOF_MAG_MAG1 ||
      	  dof->dofh_ident[DOF_ID_MAG2] != DOF_MAG_MAG2 ||
      	  dof->dofh_ident[DOF_ID_MAG3] != DOF_MAG_MAG3) {
	}

  	dh.dofhp_dof  = (uintptr_t)dof;
  	dh.dofhp_addr = (uintptr_t)dof;
  	(void) snprintf(dh.dofhp_mod, sizeof (dh.dofhp_mod), module_name);
  	fd = open(helper, O_RDWR);
    	gen = _loaddof(fd, &dh);
    	(void) close(fd);

