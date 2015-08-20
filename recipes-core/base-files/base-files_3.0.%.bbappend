FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://display-settings.sh;name=displaysettings"

VOLATILE_LOG_DIR = ""

do_install_append () {
	echo `pwd`
	install -d ${D}/etc/profile.d
	install -m 0750 display-settings.sh ${D}/etc/profile.d
}

