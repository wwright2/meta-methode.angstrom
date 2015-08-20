
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

PREFERRED_VERSION = "3.2"
SRCPV = "3.2"

#https://git.ti.com/ti-linux-kernel/ti-linux-kernel/commit/c19838d1a8408cfa1b156946fea03bfc96cd380c
 
#SRC_URI = "git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git;protocol=git;nocheckout=1;name=machine"
#http://10.35.0.19/dcim/dcim-controller-gen3.git
SRC_URI = "http://10.35.0.153/dcim3-pkgs/linux-dcim-3.2.x.tar.gz;protocol=http;nocheckout=1;name=machine"
SRC_URI[machine.md5sum] = "ccc4daa679a3a23d1d282a64b8750cda"

SRC_URI += "file://am335x-pm-firmware.bin;name=pmfirmwareelf"
SRC_URI[pmfirmwareelf.md5sum] = "380b1cc986d87456658ac88fef849003"
SRC_URI += "file://am335x-pm-firmware.elf;name=pmfirmwareelf"
SRC_URI[pmfirmwareelf.md5sum] = "acf9865a4c6c8bc5bbba2472ca5a5d9c"
SRC_URI += "file://defconfig;name=defconfig"
SRC_URI[defconfig.md5sum] = "00d9c8a136be73cafc2e8480af0085e6"
SRC_URI += "file://dcim_defconfig;name=dcimconfig"


CMDLINE = "console=ttyO0,115200 rootwait root=/dev/mmcblk0p2 ip=dhcp"
KERNEL_IMAGETYPE = "uImage"



# Allow a layer to easily add to the list of patches or completely override them
KERNEL_PATCHES = "${PATCHES}"

# Add a set of patches that enabled features, fixed bugs or disabled buggy features
# that weren't part of the official PSP release
PATCHES = "file://0001-musb-update-PIO-mode-help-information-in-Kconfig.patch \
               file://0001-mach-omap2-pm33xx-Disable-VT-switch.patch"

# Add Cryptography support early driver patches while working to get the driver
# upstream.
PATCHES += "file://0001-am33x-Add-memory-addresses-for-crypto-modules.patch \
                file://0002-am33x-Add-crypto-device-and-resource-structures.patch \
                file://0003-am33x-Add-crypto-device-and-resource-structure-for-T.patch \
                file://0004-am33x-Add-crypto-drivers-to-Kconfig-and-Makefiles.patch \
                file://0005-am33x-Create-header-file-for-OMAP4-crypto-modules.patch \
                file://0006-am33x-Create-driver-for-TRNG-crypto-module.patch \
                file://0007-am33x-Create-driver-for-AES-crypto-module.patch \
                file://0008-am33x-Create-driver-for-SHA-MD5-crypto-module.patch \
                file://0002-AM335x-OCF-Driver-for-Linux-3.patch \
                file://0001-am335x-Add-crypto-driver-settings-to-defconfig.patch \
                file://0001-am335x-Add-pm_runtime-API-to-crypto-driver.patch \
                file://0002-am335x-Add-suspend-resume-routines-to-crypto-driver.patch \
                file://0001-ARM-AM33xx-hwmod-Convert-SHA0-crypto-device-data-to-.patch \
                file://0002-crypto-omap4-sham-Use-finer-grained-PM-management.patch \
                file://0003-crypto-omap4-sham-Add-suspend-resume-PM-support.patch \
                file://0004-crypto-omap4-sham-Don-t-use-hardcoded-base-address.patch \
                file://0005-ARM-AM33xx-hwmod-Convert-AES0-crypto-device-data-to-.patch \
                file://0006-crypto-omap4-aes-User-finer-grained-PM-management.patch \
                file://0007-crypto-omap4-aes-Add-suspend-resume-PM-support.patch \
                file://0008-crypto-omap4-aes-Don-t-use-hardcoded-base-address.patch \
                file://0009-ARM-AM33xx-hwmod-Convert-RNG-device-data-to-hwmod.patch \
                file://0010-hwrng-omap4-rng-Convert-to-use-pm_runtime-API.patch \
                file://0001-omap4-rng-Remove-check-for-GP-only-device-type-in-RN.patch \
               "

# Add SmartReflex support early driver patches while working to get the driver
# upstream.
PATCHES += "file://0001-am33xx-Add-SmartReflex-support.patch \
            file://0002-am33xx-Enable-CONFIG_AM33XX_SMARTREFLEX.patch \
            file://0002-Smartreflex-limited-to-ES-1.0.patch \
            file://0001-Smartreflex-support-for-ES-2.x-and-suspend-resume.patch \
           "

# Add a patch to the omap-serial driver to allow suspend/resume during
# Bluetooth traffic
PATCHES += "file://0001-omap-serial-add-delay-before-suspending.patch"

# Add patch to allow wireless to work properly on EVM-SK 1.2.
PATCHES += "file://0001-am3358-sk-modified-WLAN-enable-and-irq-to-match-boar.patch"

# Add CPU utilization patch for WLAN
PATCHES += "file://0001-am335xevm-using-edge-triggered-interrupts-for-WLAN.patch"

# Add patch to enable pullup on WLAN enable
PATCHES += "file://0001-am335x-enable-pullup-on-the-WLAN-enable-pin-fo.patch"

# Update SPI flash layout. Increase space allocated for u-boot
PATCHES += "file://0001-ARM-OMAP2-AM335x-Update-SPI-flash-layout.patch"




S = "${WORKDIR}/linux"
PACKAGES =+ "firmware firmware-dbg"
FILES_firmware = "${binddir}/* \
				 ${libexecdir}"
FILES_firmware-dbg = "FILES_${PN}-dbg \
				${KERNEL_SRC_PATH}/firmware/.debug/*"

do_myconfigure () {
	echo `pwd`
	rm ${S}/.config.old
	cp ../am335x-pm-firmware.* ${S}/firmware
	cp ../dcim_defconfig ${S}/
	cp ../dcim_defconfig ${S}/arch/arm/configs/dcim_defconfig
}
do_precompile () {
	cp ../dcim_defconfig ${S}/.config
}

addtask precompile after do_configure before do_compile
addtask myconfigure after do_unpack before do_configure


