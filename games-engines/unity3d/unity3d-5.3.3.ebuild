# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

BUILDTAG=20160223
PV_F=${PV}f1 # Workaround for that ugly f-revision
IUSE="ffmpeg nodejs java gzip android"
DESCRIPTION="The world's most popular development platform for creating 2D and 3D multiplatform games and interactive experiences."
HOMEPAGE="https://unity3d.com/"
SRC_URI="http://download.unity3d.com/download_unity/linux/unity-editor-installer-${PV_F}+${BUILDTAG}.sh -> ${PN}.sh"

LICENSE="custom"
SLOT="5"
KEYWORDS="-* ~amd64 amd64" # Package is x86_64-only

RDEPEND="ffmpeg? ( media-video/ffmpeg )
	nodejs? ( net-libs/nodejs )
	java? ( virtual/jdk virtual/jre )
	android? ( dev-util/android-studio )
	gzip? ( app-arch/gzip )
	dev-util/desktop-file-utils
	x11-misc/xdg-utils
	sys-devel/gcc[multilib]
	virtual/opengl
	virtual/glu
	dev-libs/nss
	media-libs/libpng
	x11-libs/libXtst
	dev-libs/libpqxx
	dev-util/monodevelop
	net-libs/nodejs[npm]"
DEPEND="${RDEPEND}
	sys-apps/fakeroot"

S="${WORKDIR}/unity-editor-${PV_F}"

src_unpack() {
	yes | fakeroot sh "${DISTDIR}/${PN}.sh" > /dev/null || die "Failed unpacking archive!"
	rm "${DISTDIR}/${PN}.sh"
	cp "${FILESDIR}/EULA" "${S}/"
	cp "${FILESDIR}/unity-editor" "${S}/"
	cp "${FILESDIR}/monodevelop-unity" "${S}/"
	cp "${FILESDIR}/unity-monodevelop.png" "${S}/"
}

src_prepare() {
	sed -i "/^Exec=/c\Exec=/usr/bin/unity-editor" "${S}/unity-editor.desktop"
	sed -i "/^Exec=/c\Exec=/usr/bin/monodevelop-unity" "${S}/unity-monodevelop.desktop"
	ln -s /usr/bin/python2 ${S}/Editor/python # Fix WebGL building
	# chown root "${S}/Editor/chrome-sandbox"
	chmod 4755 "${S}/Editor/chrome-sandbox"
}

src_compile() {
	true; # Workaround for some portage issues
}

src_install() {
	# local EXTRDIR="${S}"
	# mkdir -p "${D}/opt/"
	# mv ${extraction_dir} ${D}/opt/Unity
	# install -Dm644 -t "${D}/usr/share/applications" "${D}/unity-editor.desktop" \
		# "${D}/opt/Unity/unity-monodevelop.desktop"
	# install -Dm644 -t "${D}/usr/share/icons/hicolor/256x256/apps" "${D}/opt/Unity/unity-editor-icon.png"
	# install -Dm644 -t "${D}/usr/share/icons/hicolor/48x48/apps" "${D}/unity-monodevelop.png"
	# install -Dm755 -t "${D}/usr/bin" "${D}/unity-editor"
	# install -Dm755 -t "${D}/usr/bin" "${D}/monodevelop-unity"
	# install -Dm644 "${D}/EULA" "${D}/usr/share/licenses/${D}/EULA"
	insopts "-Dm644 -t"
	insinto "/usr/share/applications"
	doins "${S}/unity-editor.desktop"
	doins "${S}/unity-monodevelop.desktop"

	insinto "/usr/share/icons/hicolor/256x256/apps"
	doins "${D}/unity-editor-icon.png"
	insinto "/usr/share/icons/hicolor/48x48/apps"
	doins "${FILESDIR}/unity-monodevelop.png"
	
	insopts "-Dm755 -t"
	into "/usr/bin"
	dobin "${FILESDIR}/unity-editor"
	dobin "${FILESDIR}/monodevelop-unity"

	insopts "-Dm644"
	insinto "/usr/share/licenses/${PN}"
	doins "${FILESDIR}/EULA"
}
