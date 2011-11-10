
EAPI="2"
EGIT_REPO_URI="git://github.com/arx/ArxLibertatis.git"

inherit eutils games cmake-utils git-2

DESCRIPTION="Cross-platform port of Arx Fatails"
HOMEPAGE="http://arx.parpg.net/"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="+debug +unity-build +tools"

RDEPEND="<media-libs/libsdl-1.3[opengl]
	media-libs/devil[jpeg]
	media-libs/openal
	sys-libs/zlib
	dev-libs/boost
	media-libs/glew
	virtual/opengl
	virtual/glu"

DEPEND="${RDEPEND}"

src_configure() {
	
	local mycmakeargs
	mycmakeargs+=(
		$(cmake-utils_use unity-build ARX_USE_UNITYBUILD)
		$(cmake-utils_use tools ARX_BUILD_TOOLS)
		"-DCMAKE_INSTALL_PREFIX=${GAMES_PREFIX}"
	)
	
	if use debug ; then
		CMAKE_BUILD_TYPE=Debug
	fi
	
	cmake-utils_src_configure || die
}

src_install() {
	cmake-utils_src_install
	prepgamesdirs
}

pkg_postinst() {
	
	elog "This package only installs the game binary."
	elog "You will also need the demo or full game data."
	
	games_pkg_postinst
}
