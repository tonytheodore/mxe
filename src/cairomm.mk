# This file is part of MXE.
# See index.html for further information.

PKG             := cairomm
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := f08bf8a331067f0d1e876523f07238fba6b26b99
$(PKG)_SUBDIR   := cairomm-$($(PKG)_VERSION)
$(PKG)_FILE     := cairomm-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://cairographics.org/releases/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc cairo libsigc++

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://cairographics.org/releases/?C=M;O=D' | \
    $(SED) -n 's,.*"cairomm-\([0-9][^"]*\)\.tar.*,\1,p' | \
    grep -v '^1\.8\.' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        $(LINK_STYLE) \
        --prefix='$(PREFIX)/$(TARGET)' \
        MAKE=$(MAKE)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef

$(PKG)_BUILD_i686-static-mingw32    = $($(PKG)_BUILD)
$(PKG)_BUILD_x86_64-static-mingw32  = $($(PKG)_BUILD)
$(PKG)_BUILD_i686-dynamic-mingw32   = $($(PKG)_BUILD)
$(PKG)_BUILD_x86_64-dynamic-mingw32 = $($(PKG)_BUILD)
