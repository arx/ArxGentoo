# Copyright 2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils cmake-utils

DESCRIPTION="A tool to unpack installers created by Inno Setup"
HOMEPAGE="http://innoextract.constexpr.org/"
SRC_URI="
	mirror://github/dscharrer/InnoExtract/${P}.tar.gz
	mirror://sourceforge/innoextract/${P}.tar.gz
"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="
	~alpha
	amd64
	~amd64-fbsd
	~arm
	~hppa
	~ia64
	~mips
	~ppc
	~ppc64
	~s390
	~sh
	~sparc
	~sparc-fbsd
	x86
	~x86-fbsd
"
IUSE="debug +lzma"

MY_DEPEND="
	>=dev-libs/boost-1.37
	lzma? ( app-arch/xz-utils )
"

RDEPEND="${MY_DEPEND}"

DEPEND="${MY_DEPEND}"

DOCS=( README.md CHANGELOG )

src_configure() {

	local mycmakeargs=(
		$(cmake-utils_use lzma USE_LZMA)
	)

	use debug && CMAKE_BUILD_TYPE=Debug

	cmake-utils_src_configure
}
