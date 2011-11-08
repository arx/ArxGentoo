
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
		$(cmake-utils_use debug ARX_DEBUG)
		$(cmake-utils_use unity-build ARX_USE_UNITYBUILD)
		$(cmake-utils_use tools ARX_BUILD_TOOLS)
	)
	
	cmake-utils_src_configure || die
}

src_install() {
	
	dogamesbin "${S}/bin/arx" || die
	
	if use tools; then
		mv "${S}/bin/unpak" "${S}/bin/arx-unpak" || die
		dogamesbin "${S}/bin/arx-unpak" || die
		mv "${S}/bin/savetool" "${S}/bin/arx-savetool" || die
		dogamesbin "${S}/bin/arx-savetool" || die
	fi
	
	prepgamesdirs
}

pkg_postinst() {
	elog "This package only installs the game binary."
	elog "You will also need the demo or full game data."
}
