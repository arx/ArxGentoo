# Copyright 2020 Daniel Scharrer
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
EGIT_REPO_URI="https://github.com/dscharrer/innoextract.git"

inherit cmake git-r3

DESCRIPTION="A tool to unpack installers created by Inno Setup"
HOMEPAGE="https://constexpr.org/innoextract/"
SRC_URI=""

LICENSE="ZLIB"
SLOT="0"
KEYWORDS=""
IUSE="debug +iconv +lzma"

RDEPEND="
	dev-libs/boost:=[zlib,bzip2]
	iconv? ( virtual/libiconv )
	lzma? ( app-arch/xz-utils )"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DDEBUG=$(usex debug)
		-DSTRICT_USE=ON
		-DUSE_LZMA=$(usex lzma)
		-DWITH_CONV=$(usex iconv iconv builtin)
	)

	cmake_src_configure
}
