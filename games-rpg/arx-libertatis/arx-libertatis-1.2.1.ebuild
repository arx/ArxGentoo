# Copyright 2020-2021 Daniel Scharrer
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_WARN_UNUSED_CLI=yes
inherit cmake gnome2-utils

DESCRIPTION="Cross-platform port of Arx Fatalis, a first-person role-playing game"
HOMEPAGE="https://arx-libertatis.org/"
SRC_URI="https://arx-libertatis.org/files/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="blender crash-reporter custom-optimization debug +sdl2 static test tools +unity-build wayland +X"

REQUIRED_USE="wayland? ( sdl2 )"

RESTRICT="!test? ( test )"

COMMON_DEPEND="
	!sdl2? ( media-libs/libsdl[X?,video,opengl] )
	sdl2? ( media-libs/libsdl2[X?,wayland?,video,opengl] )
	media-libs/openal
	virtual/opengl
	media-libs/libepoxy[X?]
	wayland? ( media-libs/libepoxy[egl] )
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
	static? (
		|| ( media-libs/freetype[-png] media-libs/libpng[static-libs] )
		|| ( media-libs/freetype[-bzip2] app-arch/bzip2[static-libs] )
		media-libs/freetype[static-libs]
		sys-libs/zlib[static-libs]
	)
	test? ( dev-util/cppunit )"
BDEPEND="
	virtual/pkgconfig"

DOCS=( README.md AUTHORS CHANGELOG )

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	# editor does not build
	local mycmakeargs=(
		-DBUILD_TOOLS=$(usex tools)
		-DBUILD_TESTS=$(usex test)
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
		-DUSE_X11=$(usex X)
		-DUSE_WAYLAND=$(usex wayland)
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

	cmake_src_configure
}

pkg_postinst() {
	elog "optional dependencies:"
	elog "  games-rpg/arx-fatalis-data (from CD or GOG)"
	elog "  games-rpg/arx-fatalis-demo (free demo)"
	elog
	elog "This package only installs the game binary."
	elog "You need the demo or full game data. Also see:"
	elog "https://wiki.arx-libertatis.org/Getting_the_game_data"
	elog
	elog "If you have already installed the game or use the Steam version,"
	elog "run \`arx-install-data\`"

	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
