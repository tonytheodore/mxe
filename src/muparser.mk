# This file is part of MXE.
# See index.html for further information.

PKG             := muparser
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 830383b1bcfa706be5a6ac8b7ba43f32f16a1497
$(PKG)_SUBDIR   := $(PKG)_v$(subst .,_,$($(PKG)_VERSION))
$(PKG)_FILE     := $(PKG)_v$(subst .,_,$($(PKG)_VERSION)).zip
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/Version $($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/muparser/files/muparser/' | \
    $(SED) -n 's,.*Version%20\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        $(LINK_STYLE) \
        --disable-samples \
        --disable-debug
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
