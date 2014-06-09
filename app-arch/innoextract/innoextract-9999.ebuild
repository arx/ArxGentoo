# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
EGIT_REPO_URI="git://github.com/dscharrer/innoextract.git"

inherit eutils toolchain-funcs cmake-utils git-2

DESCRIPTION="A tool to unpack installers created by Inno Setup"
HOMEPAGE="http://constexpr.org/innoextract/"
SRC_URI=""

LICENSE="ZLIB"
SLOT="0"
KEYWORDS=""
IUSE="c++0x debug doc +iconv +lzma static"

RDEPEND="
	!static? (
		dev-libs/boost:=
		iconv? ( virtual/libiconv )
		lzma? ( app-arch/xz-utils )
	)"
DEPEND="${RDEPEND}
	doc? ( >=app-doc/doxygen-1.8.3.1 )
	static? (
		app-arch/bzip2[static-libs]
		dev-libs/boost[static-libs]
		sys-libs/zlib[static-libs]
		iconv? ( virtual/libiconv )
		lzma? ( app-arch/xz-utils[static-libs] )
	)"

DOCS=( README.md CHANGELOG )

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		# not sure about minimum clang req
		if use c++0x && [[ $(tc-getCXX) == *g++ && $(tc-getCXX) != *clang++ ]] ; then
			if [[ $(gcc-major-version) == 4 && $(gcc-minor-version) -lt 7 || $(gcc-major-version) -lt 4 ]] ; then
				eerror "You need at least sys-devel/gcc-4.7.0 for C++0x capabilities"
				die "You need at least sys-devel/gcc-4.7.0 for C++0x capabilities"
			fi
		fi
	fi
}

src_configure() {
	local mycmakeargs=(
		$(usex iconv -DWITH_CONV=iconv -DWITH_CONV=builtin)
		$(cmake-utils_use_use lzma LZMA)
		$(cmake-utils_use_use static STATIC_LIBS)
		$(cmake-utils_use_use c++0x CXX11)
		$(cmake-utils_use debug DEBUG)
		-DSET_OPTIMIZATION_FLAGS=OFF
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
