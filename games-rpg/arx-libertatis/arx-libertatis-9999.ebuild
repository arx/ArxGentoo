
EAPI="2"
EGIT_REPO_URI="git://github.com/arx/ArxLibertatis.git"

inherit eutils games cmake-utils git-2

DESCRIPTION="Cross-platform port of Arx Fatails"
HOMEPAGE="http://arx-libertatis.org/"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="+debug +unity-build tools"

RDEPEND="<media-libs/libsdl-1.3[opengl]
	media-libs/devil[jpeg]
	media-libs/openal
	media-libs/freetype
	sys-libs/zlib
	dev-libs/boost
	media-libs/glew
	virtual/opengl"

DEPEND="${RDEPEND}"

src_configure() {
	
	local mycmakeargs
	mycmakeargs+=(
		$(cmake-utils_use unity-build UNITY_BUILD)
		$(cmake-utils_use tools BUILD_TOOLS)
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
