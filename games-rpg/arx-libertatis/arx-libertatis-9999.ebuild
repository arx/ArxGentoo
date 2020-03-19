# Copyright 2020 Daniel Scharrer
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGIT_REPO_URI="https://github.com/arx/ArxLibertatis.git"
ARX_DATA_REPO_URI="https://github.com/arx/ArxLibertatisData.git"

CMAKE_WARN_UNUSED_CLI=yes
inherit cmake-utils git-r3 gnome2-utils

DESCRIPTION="Cross-platform port of Arx Fatalis, a first-person role-playing game"
HOMEPAGE="https://arx-libertatis.org/"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="blender +crash-reporter custom-optimization debug +sdl2 static tools +unity-build"

COMMON_DEPEND="
	!sdl2? ( media-libs/libsdl[X,video,opengl] )
	sdl2? ( media-libs/libsdl2[X,video,opengl] )
	media-libs/openal
	virtual/opengl
	media-libs/libepoxy
	crash-reporter? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		net-misc/curl[ssl]
	)
	!static? (
		media-libs/freetype
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
		|| ( media-libs/freetype[-png] media-libs/libpng[static-libs] )
		|| ( media-libs/freetype[-bzip2] app-arch/bzip2[static-libs] )
		media-libs/freetype[static-libs]
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
		-DBUILD_TOOLS=$(usex tools)
		-DDEBUG=$(usex debug)
		-DRUNTIME_DATADIR=""
		-DINSTALL_BLENDER_PLUGIN=$(usex blender)
		-DSET_OPTIMIZATION_FLAGS=$(usex custom-optimization 0 1)
		-DSTRICT_USE=ON
		-DUNITY_BUILD=$(usex unity-build)
		-DWITH_OPENGL=epoxy
		-DBUILD_CRASHREPORTER=$(usex crash-reporter)
		$(usex crash-reporter -DWITH_QT=5 "")
		-DWITH_SDL=$(usex sdl2 2 1)
		-DUSE_STATIC_LIBS=$(usex static)
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

pkg_postinst() {
	elog "optional dependencies:"
	elog "  games-rpg/arx-fatalis-data (from CD or GOG)"
	elog "  games-rpg/arx-fatalis-demo (free demo)"
	elog
	elog "This package only installs the game binary."
	elog "You need the demo or full game data. Also see:"
	elog "http://wiki.arx-libertatis.org/Getting_the_game_data"
	elog
	elog "If you have already installed the game or use the Steam version,"
	elog "run \`arx-install-data\`"

	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
