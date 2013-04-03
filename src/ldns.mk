# Builds ldns for Android.

PACKAGE = ldns

$(PACKAGE)_NAME         := ldns
$(PACKAGE)_VERSION      := 1.6.16
$(PACKAGE)_DEPENDENCIES := openssl
$(PACKAGE)_PATH         := http://www.nlnetlabs.nl/downloads/ldns
$(PACKAGE)_MD5          := 9ab2b402127cf24dffefaacbb727cad7

define configure-$(PACKAGE)
    ./configure --prefix='$(INSTALL_DIR)' \
            --host=$(HOST) \
            --with-ssl='$(INSTALL_DIR)'
endef

define build-$(PACKAGE)
    make install
endef