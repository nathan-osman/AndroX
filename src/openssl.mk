# Builds OpenSSL for Android.

PACKAGE = openssl

$(PACKAGE)_NAME    := OpenSSL
$(PACKAGE)_VERSION := 1.0.1e
$(PACKAGE)_PATH    := http://www.openssl.org/source
$(PACKAGE)_MD5     := 66bf6f10f060d561929de96f9dfe5b8c

define configure-$(PACKAGE)
	./Configure android --prefix='$(INSTALL_DIR)'
endef

define build-$(PACKAGE)
	make CC="$(HOST)-gcc" AR="$(HOST)-ar r" RANLIB="$(HOST)-ranlib"; \
	make install
endef