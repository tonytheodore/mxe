# This file is part of MXE.
# See index.html for further information.

PKG             := gtk2
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 8091fc47f8ea7f05af3400e683662068b1ef4d7b
$(PKG)_SUBDIR   := gtk+-$($(PKG)_VERSION)
$(PKG)_FILE     := gtk+-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/gtk+/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gettext libpng jpeg tiff jasper glib atk pango cairo gdk-pixbuf

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://git.gnome.org/browse/gtk+/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n 's,.*<a[^>]*>\([0-9]*\.[0-9]*[02468]\.[^<]*\)<.*,\1,p' | \
    grep -v '^2\.9' | \
    grep '^2\.' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        $(LINK_STYLE) \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-explicit-deps \
        --disable-glibtest \
        --disable-modules \
        --disable-cups \
        --disable-test-print-backend \
        --disable-gtk-doc \
        --disable-man \
        --with-included-immodules \
        --without-x
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-gtk2.exe' \
        `'$(TARGET)-pkg-config' gtk+-2.0 --cflags --libs`
endef

$(PKG)_BUILD_i686-static-mingw32    = $($(PKG)_BUILD)
$(PKG)_BUILD_x86_64-static-mingw32  =
$(PKG)_BUILD_i686-dynamic-mingw32   = $($(PKG)_BUILD)
$(PKG)_BUILD_x86_64-dynamic-mingw32 = $($(PKG)_BUILD)
