
EAPI="2"
EGIT_REPO_URI="git://github.com/dscharrer/InnoExtract.git"

inherit eutils cmake-utils git-2

DESCRIPTION="A tool to extract installers created by Inno Setup"
HOMEPAGE="http://innoextract.constexpr.org/"
SRC_URI=""

LICENSE="ZLIB"
SLOT="0"
KEYWORDS=""
IUSE="+debug +lzma"

RDEPEND=">=dev-libs/boost-1.37
	lzma? ( app-arch/xz-utils )"

DEPEND="${RDEPEND}"

src_configure() {
	
	local mycmakeargs
	mycmakeargs+=(
		$(cmake-utils_use lzma USE_LZMA)
		-DMAN_DIR=share/man
	)
	
	if use debug ; then
		CMAKE_BUILD_TYPE=Debug
	fi
	
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dodoc README.md CHANGELOG
}
