# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils wxwidgets

DESCRIPTION="The open source, cross platform, free C, C++ and Fortran IDE."
HOMEPAGE="http://www.codeblocks.org"
SRC_URI="mirror://sourceforge/codeblocks/${PN}_${PV}.tar.gz -> ${PN}-${PV}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
IUSE="contrib debug pch static-libs fresh-wxgtk fresh-wxgtk3"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~x86-fbsd"
DEPEND="
	virtual/pkgconfig
	app-arch/zip
	x11-libs/wxGTK:2.8[X]
	contrib? (
		app-text/hunspell
		dev-libs/boost:=
		dev-libs/libgamin
	)"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${PV}.release"

pkg_prepare() {
	use fresh-wxgtk && WX_GTK_VER="3.0" || WX_GTK_VER="2.8"
	use fresh-wxgtk3 && WX_GTK_VER="3.0-gtk3" || WX_GTK_VER="2.8"
}

src_configure() {
	econf \
		--with-wx-config="${WX_CONFIG}" \
		$(use_enable debug) \
		$(use_enable pch) \
		$(use_enable static-libs static) \
		$(use_with contrib contrib-plugins all)
}

src_install() {
	default
	prune_libtool_files
}
