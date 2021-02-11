# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := python3
$(PKG)_WEBSITE  := https://www.python.org
$(PKG)_DESCR    := Python3
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.6.7
$(PKG)_CHECKSUM := 21f724e3b6f5b4fdb92753ee5e1272b45897b859dee440a82df9ffa60a8d7272
$(PKG)_SUBDIR   := cpython-$($(PKG)_VERSION)
$(PKG)_FILE     := v$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/python/cpython/archive/$($(PKG)_FILE)
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_GH_CONF  := python/cpython/tags, v
$(PKG)_DEPS     := python3cmakebuildsystem bzip2 expat libffi openssl sqlite readline ncurses


define $(PKG)_UPDATE
       $(WGET) -q -O- 'https://github.com/python/cpython/releases' | \
       egrep  "^\s+v[0-9]+.[0-9]+.[0-9]+$"| \
       sort -r -g | \
       head -n 1 | \
       $(SED) -e 's/.*v//'
endef

define $(PKG)_BUILD

    cd '$(BUILD_DIR)' && \
	$(TARGET)-cmake \
		-D SIZEOF_WCHAR_T=2 \
	    -D SRC_DIR:PATH='$(SOURCE_DIR)' \
	    -D PYTHON_VERSION=$($(PKG)_VERSION) \
		-D BUILD_LIBPYTHON_SHARED=ON \
		-D DOWNLOAD_SOURCES=OFF \
		$(PREFIX)/python-cmake-buildsystem

	$(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
	$(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' install

endef
