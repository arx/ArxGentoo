
EAPI="2"

inherit eutils cmake-utils

DESCRIPTION="A tool to extract installers created by Inno Setup"
HOMEPAGE="https://innoextract.constexpr.org/"
SRC_URI="github://dscharrer/InnoExtract/${P}.tar.gz
mirror://sourceforge/innoextract/${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="debug +lzma"

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
