# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGIT_REPO_URI="git://github.com/dscharrer/innoextract.git"

inherit cmake-utils git-r3

DESCRIPTION="A tool to unpack installers created by Inno Setup"
HOMEPAGE="http://constexpr.org/innoextract/"
SRC_URI=""

LICENSE="ZLIB"
SLOT="0"
KEYWORDS=""
IUSE="debug +iconv +lzma"

RDEPEND="
	dev-libs/boost:=
	iconv? ( virtual/libiconv )
	lzma? ( app-arch/xz-utils )"
DEPEND="${RDEPEND}"

DOCS=( README.md CHANGELOG )

src_configure() {
	local mycmakeargs=(
		-DDEBUG=$(usex debug)
		-DSET_OPTIMIZATION_FLAGS=OFF
		-DSTRICT_USE=ON
		-DUSE_LZMA=$(usex lzma)
		-DWITH_CONV=$(usex iconv iconv builtin)
	)

	cmake-utils_src_configure
}
