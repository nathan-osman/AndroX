# Builds iconv for Android.

PACKAGE = libiconv

$(PACKAGE)_NAME    := libiconv
$(PACKAGE)_VERSION := 1.14
$(PACKAGE)_PATH    := http://ftp.gnu.org/pub/gnu/libiconv
$(PACKAGE)_MD5     := e34509b1623cec449dfeb73d7ce9c6c6

define configure-$(PACKAGE)
	cp '$(SRC_DIR)/config/config.guess' build-aux; \
	cp '$(SRC_DIR)/config/config.sub' build-aux; \
	cp '$(SRC_DIR)/config/config.guess' libcharset/build-aux; \
	cp '$(SRC_DIR)/config/config.sub' libcharset/build-aux; \
	./configure --prefix='$(INSTALL_DIR)' \
	            --host=$(HOST) \
	            gl_cv_header_working_stdint_h=yes
endef

define build-$(PACKAGE)
	make install
endef