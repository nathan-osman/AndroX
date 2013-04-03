# Builds OpenSSH for Android.

PACKAGE = openssh

$(PACKAGE)_NAME         := OpenSSH
$(PACKAGE)_VERSION      := 6.2p1
#$(PACKAGE)_REQUIREMENTS := autoconf
$(PACKAGE)_DEPENDENCIES := openssl ldns
$(PACKAGE)_PATH         := http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable
$(PACKAGE)_MD5          := 7b2d9dd75b5cf267ea1737ec75500316

define configure-$(PACKAGE)
	patch -p0 <'$(SRC_DIR)/patch/$(PACKAGE).patch'; \
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