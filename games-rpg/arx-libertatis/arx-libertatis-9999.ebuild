# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
EGIT_REPO_URI="git://github.com/arx/ArxLibertatis.git"
ARX_DATA_REPO_URI="git://github.com/arx/ArxLibertatisData.git"

CMAKE_WARN_UNUSED_CLI=yes
inherit eutils cmake-utils git-r3 gnome2-utils

DESCRIPTION="Cross-platform port of Arx Fatalis, a first-person role-playing game"
HOMEPAGE="http://arx-libertatis.org/"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="blender +c++0x debug +unity-build +crash-reporter static tools +sdl2"

COMMON_DEPEND="
	!sdl2? ( media-libs/libsdl[X,video,opengl] )
	sdl2? ( media-libs/libsdl2[X,video,opengl] )
	media-libs/openal
	virtual/opengl
	crash-reporter? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		net-misc/curl[ssl]
	)
	!static? (
		media-libs/freetype
		media-libs/glew
		sys-libs/zlib
	)"
RDEPEND="${COMMON_DEPEND}
	crash-reporter? ( sys-devel/gdb )
	blender? ( media-gfx/blender:= )"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
	>=media-libs/glm-0.9.5.0
	virtual/pkgconfig
	static? (
		|| ( media-libs/libpng[static-libs] media-libs/freetype[-png] )
		|| ( app-arch/bzip2[static-libs] media-libs/freetype[-bzip2] )
		media-libs/freetype[static-libs]
		media-libs/glew[static-libs]
		sys-libs/zlib[static-libs]
	)"

DOCS=( README.md AUTHORS CHANGELOG )

ARX_DATA_DIR="${WORKDIR}/${PN}-data"

src_unpack() {
	git-r3_src_unpack
	git-r3_fetch "${ARX_DATA_REPO_URI}"
	git-r3_checkout "${ARX_DATA_REPO_URI}" "${ARX_DATA_DIR}"
}

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	# editor does not build
	local mycmakeargs=(
		-DDATA_FILES="${ARX_DATA_DIR}"
		$(cmake-utils_use_build crash-reporter CRASHREPORTER)
		$(cmake-utils_use_build tools TOOLS)
		$(cmake-utils_use debug DEBUG)
		-DRUNTIME_DATADIR=""
		-DINSTALL_SCRIPTS=ON
		$(cmake-utils_use blender INSTALL_BLENDER_PLUGIN)
		-DSET_OPTIMIZATION_FLAGS=OFF
		-DSTRICT_USE=ON
		$(cmake-utils_use unity-build UNITY_BUILD)
		$(cmake-utils_use_use c++0x CXX11)
		-DUSE_NATIVE_FS=ON
		-DUSE_OPENAL=ON
		-DUSE_OPENGL=ON
		$(usex crash-reporter "-DWITH_QT=4" "")
		$(cmake-utils_use_use static STATIC_LIBS)
		$(usex sdl2 -DWITH_SDL=2 -DWITH_SDL=1)
	)

	if use blender ; then
		local blender_version="$(best_version media-gfx/blender)"
		blender_version="${blender_version#media-gfx/blender-}"
		blender_version="${blender_version/-*/}"
		local blender_api="${blender_version/[a-z]*/}"
		mycmakeargs+=(
			-DINSTALL_BLENDER_PLUGINDIR="/usr/share/blender/${blender_api}/scripts/addons/arx"
		)
	fi

	cmake-utils_src_configure
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	elog "optional dependencies:"
	elog "  games-rpg/arx-fatalis-data (from CD or GOG)"
	elog "  games-rpg/arx-fatalis-demo (free demo)"
	elog
	elog "This package only installs the game binary."
	elog "You need the demo or full game data. Also see:"
	elog "http://wiki.arx-libertatis.org/Getting_the_game_data"
	elog
	elog "If you have already installed the game or use the STEAM version,"
	elog "run \`arx-install-data\`"

	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
