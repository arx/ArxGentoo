# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
EGIT_REPO_URI="git://github.com/arx/ArxLibertatis.git"

inherit eutils cmake-utils git-2 gnome2-utils games

DESCRIPTION="Cross-platform port of Arx Fatalis, a first-person role-playing game"
HOMEPAGE="http://arx-libertatis.org/"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="debug unity-build +crash-reporter tools"

COMMON_DEPEND=">=dev-libs/boost-1.39
	media-libs/freetype
	media-libs/glew
	media-libs/libsdl:0[opengl]
	media-libs/openal
	sys-libs/zlib
	virtual/opengl
	x11-libs/libX11
	crash-reporter? (
		dev-qt/qtcore:4[ssl]
		dev-qt/qtgui:4
		)"
RDEPEND="${COMMON_DEPEND}
	crash-reporter? ( sys-devel/gdb )"
DEPEND="${COMMON_DEPEND}"

DOCS=( README.md AUTHORS CHANGELOG )

src_configure() {
	use debug && CMAKE_BUILD_TYPE=Debug

	# editor does not build
	local mycmakeargs=(
		$(cmake-utils_use unity-build UNITY_BUILD)
		$(cmake-utils_use_build tools TOOLS)
		$(cmake-utils_use_build crash-reporter CRASHREPORTER)
		-DCMAKE_INSTALL_PREFIX="${GAMES_PREFIX}"
		-DGAMESBINDIR="${GAMES_BINDIR}"
		-DCMAKE_INSTALL_DATAROOTDIR="${GAMES_DATADIR_BASE}"
		-DICONDIR=/usr/share/icons/hicolor/128x128/apps
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	elog "optional dependencies:"
	elog "  games-rpg/arx-fatalis-data (from CD, GOG, or existing install, e.g. Steam)"
	elog "  games-rpg/arx-fatalis-demo (free demo)"
	elog
	elog "This package only installs the game binary."
	elog "You need the demo or full game data. Also see:"
	elog "http://wiki.arx-libertatis.org/Getting_the_game_data"
	elog
	elog "You can use the arx-install-data script to install the game data."

	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
