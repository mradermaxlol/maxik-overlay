# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit gnome2-utils

DESCRIPTION="Flagship desktop of the Solus Project."
HOMEPAGE="https://github.com/solus-project/budgie-desktop"
SRC_URI="https://github.com/solus-project/budgie-desktop/releases/download/v${PV}/${PN}-${PV}.tar.xz"
LICENSE="GPL-2"
SLOT="10.2"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="mirror"
DEPEND="
	>=dev-libs/gobject-introspection-1.46.0
	>=x11-libs/gtk+-3.18.6
	>=dev-lang/vala-0.28.1
	>=sys-power/upower-0.99.2
	>=gnome-base/gnome-menus-3.13.3
	>=gnome-base/gnome-session-3.18.1.2
	>=gnome-base/gnome-control-center-3.18.2
	>=gnome-base/gnome-settings-daemon-3.18.2
	gnome-extra/polkit-gnome
	>=dev-util/desktop-file-utils-0.22
	media-sound/pulseaudio
	>=net-wireless/gnome-bluetooth-3.18.2
	>=gnome-base/gnome-desktop-3.18.2
	>=sys-auth/polkit-0.105
	>=x11-libs/wxGTK-3.0.2.0"
RDEPEND="${DEPEND}
	x11-wm/mutter"

S="${WORKDIR}/${PN}-${PV}"

src_prepare() {
	eapply_user # Add support for user patches
}

src_configure() {
	econf --prefix=/usr
}

src_compile() {
	emake || die "Compilation failed!"
}

src_install() {
	emake DESTDIR=${D} install || die "'make install' failed!"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
