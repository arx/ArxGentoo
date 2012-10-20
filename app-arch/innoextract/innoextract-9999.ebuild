# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
EGIT_REPO_URI="git://github.com/dscharrer/InnoExtract.git"

inherit cmake-utils git-2

DESCRIPTION="A tool to unpack installers created by Inno Setup"
HOMEPAGE="http://constexpr.org/innoextract/"
SRC_URI=""

LICENSE="ZLIB"
SLOT="0"
KEYWORDS=""
IUSE="debug doc +lzma"

RDEPEND=">=dev-libs/boost-1.37
	virtual/libiconv
	lzma? ( app-arch/xz-utils )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

DOCS=( README.md CHANGELOG )

src_configure() {
	use debug && CMAKE_BUILD_TYPE=Debug

	local mycmakeargs=(
		$(cmake-utils_use lzma USE_LZMA)
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	use doc && cmake-utils_src_compile doc
}

src_install() {
	cmake-utils_src_install
	use doc && dohtml -r "${CMAKE_BUILD_DIR}"/doc/html/*
}
