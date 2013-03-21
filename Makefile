#=========================================
# Cross-Compile Build Scripts for Android
#=========================================

# Settings that determine how things will be built.
HOST := arm-linux-androideabi

# Settings that determine where things will go.
BUILD_DIR   := $(CURDIR)/build
CACHE_DIR   := $(CURDIR)/cache
INSTALL_DIR := $(CURDIR)/install
SRC_DIR     := $(CURDIR)/src
VAR_DIR     := $(CURDIR)/var

# Color-changing utility variables.
RED    = `echo -n "\033[1;31m"`
YELLOW = `echo -n "\033[1;33m"`
GREEN  = `echo -n "\033[1;32m"`
RESET  = `echo -n "\033[0m"`

# Create a list of all packages that are available.
PACKAGES = $(shell ls '$(SRC_DIR)' | grep -P '^\w+\.mk$$' | sed 's:\.mk$$::')

# Include all of the makefiles.
include $(patsubst %,$(SRC_DIR)/%.mk,$(PACKAGES))

# Rule to make all packages.
.PHONY: all
all: $(PACKAGES)
	@echo "$(GREEN)All packages built$(RESET)"

# Rule to clean all targets.
.PHONY: clean
clean: $(addprefix clean-,$(PACKAGES))
	@echo "$(GREEN)All packages cleaned$(RESET)"

# Rule to purge all targets and directories.
.PHONY: purge
purge: $(addprefix purge-,$(PACKAGES))
	@rm -rf '$(BUILD_DIR)' '$(CACHE_DIR)' '$(INSTALL_DIR)' '$(VAR_DIR)'
	@echo "$(GREEN)All packages purged$(RESET)"

# Creates appropriate rules for the specified package that download, configure, build, etc.
define package-rules

# Concatenate the name and version.
$(eval $(1)_ARCHIVE := $(1)-$($(1)_VERSION))
$(eval $(1)_FILE    := $(CACHE_DIR)/$($(1)_ARCHIVE).tar.gz)
$(eval $(1)_URL     := $($(1)_PATH)/$($(1)_ARCHIVE).tar.gz)

# Rule for downloading the package.
$($(1)_FILE):
	@echo "$(YELLOW)Downloading '$($(1)_URL)'...$(RESET)"
	@mkdir -p '$(CACHE_DIR)'
	@wget -q -P '$(CACHE_DIR)' '$($(1)_URL)' && echo "$($(1)_MD5)  $($(1)_FILE)" | md5sum -c

# Rule for extracting the archive contents.
$(VAR_DIR)/$(1)-extracted: $($(1)_FILE)
	@echo "$(YELLOW)Extracting '$($(1)_FILE)'...$(RESET)"
	@mkdir -p '$(BUILD_DIR)'
	@cd '$(BUILD_DIR)' ; tar -xf '$($(1)_FILE)'
	@mkdir -p '$(VAR_DIR)'
	@touch '$(VAR_DIR)/$(1)-extracted'

# Rule for configuring the package.
$(VAR_DIR)/$(1)-configured: $(VAR_DIR)/$(1)-extracted
	@echo "$(YELLOW)Configuring $($(1)_NAME)...$(RESET)"
	@cd '$(BUILD_DIR)/$($(1)_ARCHIVE)' ; $(call configure-$(1))
	@touch '$(VAR_DIR)/$(1)-configured'

# Rule for building the package.
$(VAR_DIR)/$(1)-built: $(VAR_DIR)/$(1)-configured
	@echo "$(YELLOW)Building $($(1)_NAME)...$(RESET)"
	@cd '$(BUILD_DIR)/$($(1)_ARCHIVE)' ; $(call build-$(1))
	@touch '$(VAR_DIR)/$(1)-built'

# Executes all dependencies.
.PHONY: $(1)
$(1): $($(1)_DEPENDENCIES) $(VAR_DIR)/$(1)-built
	@echo "$(GREEN)$($(1)_NAME) is built$(RESET)"

# Cleans the package build files.
.PHONY: clean-$(1)
clean-$(1):
	@echo "$(YELLOW)Cleaning $($(1)_NAME)...$(RESET)"
	@cd '$(BUILD_DIR)/$($(1)_ARCHIVE)' ; test -f Makefile && make clean

# Destroys all files downloaded and created by the package.
.PHONY: purge-$(1)
purge-$(1):
	@echo "$(RED)Purging $($(1)_NAME)...$(RESET)"
	@rm -f '$(VAR_DIR)/$(1)-built' \
	       '$(VAR_DIR)/$(1)-configured' \
	       '$(VAR_DIR)/$(1)-extracted'
	@rm -rf '$(BUILD_DIR)/$($(1)_ARCHIVE)'
	@rm -f '$($(1)_FILE)'

endef

# Instantiate rules for all of the packages.
$(foreach PACKAGE,$(PACKAGES),$(eval $(call package-rules,$(PACKAGE))))
