
EAPI="2"
EGIT_REPO_URI="git://github.com/arx/ArxLibertatis.git"

inherit eutils games cmake-utils git-2

DESCRIPTION="Cross-platform port of Arx Fatalis, a first-person role-playing game"
HOMEPAGE="http://arx-libertatis.org/"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="+debug +unity-build +crash-reporter tools"

ARX_DEPEND="\
	media-libs/libsdl[opengl]
	media-libs/devil[jpeg]
	media-libs/openal
	media-libs/freetype
	sys-libs/zlib
	>=dev-libs/boost-1.39
	media-libs/glew
	virtual/opengl
	crash-reporter? ( x11-libs/qt-core[ssl] x11-libs/qt-gui )"

RDEPEND="${ARX_DEPEND}
	crash-reporter? ( sys-devel/gdb )"

DEPEND="${ARX_DEPEND}"

src_configure() {
	
	local mycmakeargs
	mycmakeargs+=(
		$(cmake-utils_use unity-build UNITY_BUILD)
		$(cmake-utils_use tools BUILD_TOOLS)
		$(cmake-utils_use crash-reporter BUILD_CRASHREPORTER)
		"-DGAMESBINDIR=${GAMES_BINDIR}"
		"-DCMAKE_INSTALL_DATAROOTDIR=${GAMES_DATADIR_BASE}"
	)
	
	if use debug ; then
		CMAKE_BUILD_TYPE=Debug
	fi
	
	cmake-utils_src_configure || die
}

src_install() {
	cmake-utils_src_install
	dodoc README.md AUTHORS CHANGELOG ARX_PUBLIC_LICENSE.txt
	prepgamesdirs
}

pkg_postinst() {
	
	elog "This package only installs the game binary."
	elog "You will also need the demo or full game data."
	elog "See http://wiki.arx-libertatis.org/Getting_the_game_data for more information."
	
	games_pkg_postinst
}
