# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := python3
$(PKG)_WEBSITE  := https://www.python.org
$(PKG)_DESCR    := Python3
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.8.0
$(PKG)_CHECKSUM := fc00204447b553c2dd7495929411f567cc480be00c49b11a14aee7ea18750981
$(PKG)_SUBDIR   := cpython-$($(PKG)_VERSION)
$(PKG)_FILE     := v$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/python/cpython/archive/$($(PKG)_FILE)
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_GH_CONF  := python/cpython/tags, v
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS     := cc bzip2 expat libffi openssl sqlite readline



define $(PKG)_UPDATE
	$(WGET) -q -O- 'https://github.com/python/cpython/releases' | \
	egrep  "^\s+v[0-9]+.[0-9]+.[0-9]+$"| \
	sort -r -g | \
	head -n 1 | \
	$(SED) -e 's/.*v//'
endef


define $(PKG)_BUILD

	# Windows 7 0x0601
	# Windows 8.1 0x0602
	cd '$(1)' && \
		autoconf && \
		CFLAGS=-D_WIN32_WINNT=0x0602 ./configure \
    	$(MXE_CONFIGURE_OPTS) \
		--enable-shared \
		--with-system-expat \
		--with-system-ffi \
		--without-ensurepip

    CC='$(TARGET)-gcc' WINDRES='$(TARGET)-windres' $(MAKE) -C '$(1)' -j '$(JOBS)'
    CC='$(TARGET)-gcc' WINDRES='$(TARGET)-windres' $(MAKE) -C '$(1)' -j '$(JOBS)' install

endef
