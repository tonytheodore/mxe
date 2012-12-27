# This file is part of MXE.
# See index.html for further information.

PKG             := wt
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := d3870671a303d64878a1c9fe22765a643e515051
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/witty/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc boost openssl libharu graphicsmagick pango postgresql sqlite

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/witty/files/wt/' | \
    $(SED) -n 's,.*<a href="/projects/witty/files/wt/\([0-9][^>]*\)/.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # build wt libraries
    mkdir '$(1).build'
    cd '$(1).build' && cmake \
        -DCONFIGDIR='$(PREFIX)/$(TARGET)/etc/wt' \
        -DBUILD_EXAMPLES=OFF \
        -DBUILD_TESTS=OFF \
        -DSHARED_LIBS=OFF \
        -DBOOST_DYNAMIC=OFF \
        -DBOOST_PREFIX='$(PREFIX)/$(TARGET)' \
        -DBOOST_COMPILER=_win32 \
        -DSSL_PREFIX='$(PREFIX)/$(TARGET)' \
        -DOPENSSL_LIBS="`'$(TARGET)-pkg-config' --libs-only-l openssl`" \
        -DGM_PREFIX='$(PREFIX)/$(TARGET)' \
        -DGM_LIBS="`'$(TARGET)-pkg-config' --libs-only-l GraphicsMagick++`" \
        -DPANGO_FT2_LIBS="`'$(TARGET)-pkg-config' --libs-only-l pangoft2`" \
        -DWT_CMAKE_FINDER_INSTALL_DIR='/lib/wt' \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        '$(1)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)' install VERBOSE=1
endef

$(PKG)_BUILD_i686-static-mingw32    = $($(PKG)_BUILD)
$(PKG)_BUILD_x86_64-static-mingw32  =
$(PKG)_BUILD_i686-dynamic-mingw32   = $($(PKG)_BUILD)
$(PKG)_BUILD_x86_64-dynamic-mingw32 = $($(PKG)_BUILD)
