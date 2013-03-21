# Builds Git for Android.

PACKAGE = git

$(PACKAGE)_NAME         := Git
$(PACKAGE)_VERSION      := 1.8.2
$(PACKAGE)_REQUIREMENTS := autoconf
$(PACKAGE)_DEPENDENCIES := openssl curl
$(PACKAGE)_PATH         := http://git-core.googlecode.com/files
$(PACKAGE)_MD5          := 210834d73c857931c3da34a65eb3e597

define configure-$(PACKAGE)
	autoconf; \
	./configure --prefix=$(INSTALL_DIR) \
		    --host=$(HOST) \
		    --without-tcltk \
		    --with-openssl=$(INSTALL_DIR)\
		    --with-curl=$(INSTALL_DIR)\
		    ac_cv_fread_reads_directories=no \
		    ac_cv_snprintf_returns_bogus=no
endef

define build-$(PACKAGE)
	make NO_NSEC=1 ; make
endef