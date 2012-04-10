# Copyright 2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils games cmake-utils versionator

MY_PV="v$(delete_version_separator 1 $(replace_version_separator 2 '_'))"
MY_P="${PN}_linux_${MY_PV}"

DESCRIPTION="Free/Libre Action Roleplaying Engine"
HOMEPAGE="http://clintbellanger.net/rpg/"
SRC_URI="mirror://github/clintbellanger/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-3 CC-BY-SA-3.0-Unported"
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
IUSE=""

MY_DEPEND="
	media-libs/libsdl[X,joystick]
	|| (
		media-libs/libsdl[alsa]
		media-libs/libsdl[nas]
		media-libs/libsdl[oss]
		media-libs/libsdl[pulseaudio]
	)
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-ttf
"

RDEPEND="${MY_DEPEND}"

DEPEND="${MY_DEPEND}"

DOCS=( README )

S="${WORKDIR}/${MY_P}"

src_configure() {

	local mycmakeargs
	mycmakeargs+=(
		"-DBINDIR=games/bin"
	)

	cmake-utils_src_configure || die
}

src_install() {
	cmake-utils_src_install
	prepgamesdirs
}