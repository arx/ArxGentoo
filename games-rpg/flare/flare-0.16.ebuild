# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils games cmake-utils versionator

MY_PV="v$(delete_version_separator 1 $(replace_version_separator 2 '_'))"
MY_P="${PN}_linux_${MY_PV}"
MY_S="${PN}_${MY_PV}"

DESCRIPTION="Free/Libre Action Roleplaying Engine"
HOMEPAGE="http://clintbellanger.net/rpg/"
SRC_URI="
	mirror://github/clintbellanger/${PN}/${MY_P}.zip
	mirror://github/arx/ArxGentoo/${MY_P}.zip
"

# Code is GPL, assets are CC-BY-SA
LICENSE="GPL-3 CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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

S="${WORKDIR}/${MY_S}"

src_configure() {
	local mycmakeargs=(
		"-DBINDIR=games/bin"
	)
	cmake-utils_src_configure || die
}

src_install() {
	cmake-utils_src_install
	prepgamesdirs
}
