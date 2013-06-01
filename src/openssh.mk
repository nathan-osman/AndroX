# Builds OpenSSH for Android.

PACKAGE = openssh

$(PACKAGE)_NAME         := OpenSSH
$(PACKAGE)_VERSION      := 6.2p1
#$(PACKAGE)_REQUIREMENTS := autoconf
$(PACKAGE)_DEPENDENCIES := openssl ldns
$(PACKAGE)_PATH         := http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable
$(PACKAGE)_MD5          := 7b2d9dd75b5cf267ea1737ec75500316

# I have submitted a total of three patches to the OpenSSH portability team to
# allow OpenSSH to compile for Android.
#
# https://bugzilla.mindrot.org/show_bug.cgi?id=2085
# https://bugzilla.mindrot.org/show_bug.cgi?id=2086
# https://bugzilla.mindrot.org/show_bug.cgi?id=2087
# https://bugzilla.mindrot.org/show_bug.cgi?id=2111
# https://bugzilla.mindrot.org/show_bug.cgi?id=2112
# https://bugzilla.mindrot.org/show_bug.cgi?id=2113
#
# Each of these is set for inclusion (in some form) in the next release.

define configure-$(PACKAGE)
	patch -p0 <'$(SRC_DIR)/patch/$(PACKAGE)-upstream.patch'; \
	patch -p0 <'$(SRC_DIR)/patch/$(PACKAGE)-fix-config-defs.patch'; \
	patch -p0 <'$(SRC_DIR)/patch/$(PACKAGE)-disable-utmp-and-wtmp.patch'; \
	patch -p0 <'$(SRC_DIR)/patch/$(PACKAGE)-use-openssl-crypt.patch'; \
	patch -p0 <'$(SRC_DIR)/patch/$(PACKAGE)-replace-iwrite-with-iwusr.patch'; \
	autoconf; \
	./configure --prefix='$(INSTALL_DIR)' \
		    --host=$(HOST) \
		    --with-ldns='$(INSTALL_DIR)' \
		    --with-ssl-dir='$(INSTALL_DIR)' \
		    ac_cv_header_sys_un_h=yes
endef

define build-$(PACKAGE)
	make install
endef