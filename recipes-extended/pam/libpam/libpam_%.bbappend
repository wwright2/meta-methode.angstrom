
DEPENDS = " db "
PR = "r1"
PV = "1.2.1"
SRCPV = "${PN}-${PV}"
LIC_FILES_CHKSUM = "file://COPYING;md5=7eb5c1bf854e8881005d673599ee74d3"
#SRC_URI = "http://www.linux-pam.org/library/Linux-PAM-${PV}.tar.gz;name=source"
SRC_URI = "file://Linux-PAM-${PV}.tar.gz;name=source"

SRC_URI[source.md5sum] = "2c3c363f45de03dac98cf846a1717a12"
SRC_URI[source.sha256sum] = "8e3f07fdbad5b1c030498fd6298e115e6f740d39d930390fc6937d14fa5c1b4a"

S = "${WORKDIR}/Linux-PAM-${PV}"
BBCLASSEXTEND = "native nativesdk"
EXTRA_OECONF = " --enable-db=no  --includedir=${STAGING_INCDIR}/pam \
	CFLAGS=-I${STAGING_INCDIR} \
	"

addtask pam_install after do_install
do_pam_install (){
	cd ${S}/libpam

	echo "cp -r include/security ${STAGING_INCDIR}"
	cp -r include/security ${STAGING_INCDIR}

	echo "cp -r include/pam*.h ${STAGING_INCDIR}/pam"
	mkdir -p ${STAGING_INCDIR}/pam
	cp -r include/security/pam*.h ${STAGING_INCDIR}/pam
}
