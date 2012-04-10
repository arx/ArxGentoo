# Copyright 2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
EGIT_REPO_URI="git://github.com/dscharrer/InnoExtract.git"

inherit eutils cmake-utils git-2

DESCRIPTION="A tool to unpack installers created by Inno Setup"
HOMEPAGE="http://innoextract.constexpr.org/"
SRC_URI=""

LICENSE="ZLIB"
SLOT="0"
KEYWORDS=""
IUSE="+debug +lzma"

MY_DEPEND="
	>=dev-libs/boost-1.37
	lzma? ( app-arch/xz-utils )
"

RDEPEND="${MY_DEPEND}"

DEPEND="${MY_DEPEND}"

DOCS=( README.md CHANGELOG )

src_configure() {

	local mycmakeargs
	mycmakeargs+=(
		$(cmake-utils_use lzma USE_LZMA)
	)

	if use debug ; then
		CMAKE_BUILD_TYPE=Debug
	fi

	cmake-utils_src_configure
}
