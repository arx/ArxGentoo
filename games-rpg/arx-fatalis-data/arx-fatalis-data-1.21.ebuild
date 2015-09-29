# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

CDROM_OPTIONAL="yes"
inherit eutils cdrom check-reqs games

DESCRIPTION="Arx Fatalis data files"
HOMEPAGE="http://www.arkane-studios.com/uk/arx.php"
SRC_URI="cdinstall? ( http://download.zenimax.com/arxfatalis/patches/1.21/ArxFatalis_1.21_MULTILANG.exe )
	gog? ( setup_arx_fatalis.exe )"

LICENSE="cdinstall? ( ArxFatalis-EULA-JoWooD ) gog? ( GOG-EULA )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gog"
REQUIRED_USE="|| ( !cdinstall !gog )"
RESTRICT="binchecks mirror gog? ( fetch )"

RDEPEND="games-rpg/arx-libertatis"
DEPEND="gog? ( app-arch/innoextract )
	cdinstall? (
		|| ( app-arch/cabextract app-arch/libarchive app-arch/p7zip )
		app-arch/innoextract
	)"

CHECKREQS_DISK_BUILD="621M"
CHECKREQS_DISK_USR="617M"

S="${WORKDIR}"

MY_DATADIR="${GAMES_DATADIR}/arx"

pkg_nofetch() {
	einfo "Please download ${A} from your GOG.com account after buying Arx Fatalis"
	einfo "and put it into ${DISTDIR}."
}

src_unpack() {
	local arx_install_data_options=(--no-patch --batch --data-dir="${S}")
	if use gog ; then
		arx_install_data_options+=( --source="${DISTDIR}/${A}" )
	else if use cdinstall ; then
		cdrom_get_cds "bin/Arx.ttf"
		arx_install_data_options+=( --source="${CDROM_ROOT}" --patch="${DISTDIR}/${A}" )
	else if [ -z "${ARX_FATALIS_SRC}" ] ; then
		eerror "You need either set ARX_FATALIS_SRC to point to an existing Arx Fatalis"
		eerror "installation or use the gog or cdinstall use flags:"
		eerror "  export ARX_FATALIS_SRC=/path/to/arx"
		die "Could not find game data."
	else
		arx_install_data_options+=( --source="${ARX_FATALIS_SRC}" )
	fi ; fi ; fi
	# TODO The current arx-libertatis ebuild puts arx-install-data into GAMES_BINDIR
	#      which means we can't use it here.
	local arx_install_data="${FILESDIR}/arx-install-data"
	"${arx_install_data}" "${arx_install_data_options[@]}"
}

src_install() {

	insinto "${MY_DATADIR}"
	doins -r *

	prepgamesdirs
}
