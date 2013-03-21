# Builds cURL for Android.

PACKAGE = curl

$(PACKAGE)_NAME         := cURL
$(PACKAGE)_VERSION      := 7.29.0
$(PACKAGE)_DEPENDENCIES := openssl
$(PACKAGE)_PATH         := http://curl.haxx.se/download
$(PACKAGE)_MD5          := 4f57d3b4a3963038bd5e04dbff385390

define configure-$(PACKAGE)
	./configure --prefix=$(INSTALL_DIR) --host=$(HOST) --with-ssl=$(INSTALL_DIR)
endef

define build-$(PACKAGE)
	make ; make install
endef