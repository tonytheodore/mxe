# This file is part of MXE.
# See index.html for further information.

PKG             := zlib
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 858818fe6d358ec682d54ac5e106a2dd62628e7f
$(PKG)_SUBDIR   := zlib-$($(PKG)_VERSION)
$(PKG)_FILE     := zlib-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://zlib.net/$($(PKG)_FILE)
$(PKG)_URL_2    := http://$(SOURCEFORGE_MIRROR)/project/libpng/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://zlib.net/' | \
    $(SED) -n 's,.*zlib-\([0-9][^>]*\)\.tar.*,\1,ip' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && CHOST='$(TARGET)' ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --static
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef

$(PKG)_BUILD_i686-static-mingw32    = $($(PKG)_BUILD)
$(PKG)_BUILD_x86_64-static-mingw32  = $($(PKG)_BUILD)

define $(PKG)_BUILD_i686-dynamic-mingw32
    cd '$(1)' && $(MAKE) install -f \
        win32/Makefile.gcc \
        SHARED_MODE=1 \
        PREFIX=$(TARGET)- \
        prefix='$(PREFIX)/$(TARGET)' \
        INCLUDE_PATH='$(PREFIX)/$(TARGET)/include' \
        LIBRARY_PATH='$(PREFIX)/$(TARGET)/lib' \
        BINARY_PATH='$(PREFIX)/$(TARGET)/bin'
endef

$(PKG)_BUILD_x86_64-dynamic-mingw32 = $($(PKG)_BUILD)
