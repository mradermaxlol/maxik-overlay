# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils gnome2-utils vala versionator

MAJOR_V=$(get_version_component_range 1-2)

DESCRIPTION="Haguichi provides a graphical frontend for Hamachi on Linux."
HOMEPAGE="https://www.haguichi.net"
SRC_URI="https://launchpad.net/haguichi/${MAJOR_V}/${PV}/+download/${PN}-${PV}.tar.xz"
LICENSE="GPL-3+"
SLOT="1.3"
KEYWORDS="-* ~amd64 ~x86"
DEPEND="
	sys-devel/gettext
	>=dev-util/cmake-2.6
	>=dev-libs/vala-common-0.28
	$(vala_depend)
	>=dev-libs/glib-2.42
	>=x11-libs/gtk+-3.14
	>=x11-libs/libnotify-0.7.6"
RDEPEND="${DEPEND}
	net-misc/logmein-hamachi"

S="${WORKDIR}/${PN}-${PV}"

src_prepare() {
	vala_src_prepare

	# Find proper valac binary
	sed -i \
		-e "/find_program(VALA_EXECUTABLE/s/valac/$(basename ${VALAC})/" \
		cmake/FindVala.cmake || die

	# Do not update icon cache during installation, it breaks sandbox!
	sed -i \
		-e '/install (CODE "execute_process ( COMMAND ${GTK_UPDATE_ICON_CACHE}/d' \
		data/icons/hicolor/*/CMakeLists.txt || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DGSETTINGS_LOCALINSTALL=OFF
	)
	cmake-utils_src_configure
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
