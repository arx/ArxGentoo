# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

CDROM_OPTIONAL="yes"
inherit eutils cdrom games

DESCRIPTION="Arx Fatalis data"
HOMEPAGE="http://www.arkane-studios.com/uk/arx.php"
SRC_URI="
	gog? ( setup_arx_fatalis.exe )
	cdinstall? ( http://download.zenimax.com/arxfatalis/patches/1.21/ArxFatalis_1.21_MULTILANG.exe )
"

LICENSE="
	gog? ( ArxFatalis-EULA-GOG.com )
	cdinstall? ( ArxFatalis-EULA-JoWooD )
"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cdinstall gog"
RESTRICT="mirror gog? ( fetch )"

RDEPEND=""

DEPEND="
	gog? ( app-arch/innoextract )
	cdinstall? ( app-arch/cabextract app-arch/innoextract )
"

MY_DATADIR="${GAMES_DATADIR}/arx"

pkg_nofetch() {
	einfo "Please download ${A} from you GOG.com account after buying Arx Fatalis"
	einfo "and put it into ${DISTDIR}."
}

src_unpack() {
	local todo=1
	if [ $todo = 1 ] && use gog ; then
		"${FILESDIR}/install-gog" --no-progress "${DISTDIR}/${A}" "${S}" || die "unpack failed"
		todo=0
	fi
	if [ $todo = 1 ] && use cdinstall ; then
		cdrom_get_cds "bin/Arx.ttf"
		"${FILESDIR}/install-cd" --no-progress "${CDROM_ROOT}" "${DISTDIR}/${A}" "${S}" \
			|| die "unpack failed"
		todo=0
	fi
	if [ $todo = 1 ] ; then
		if [ "${ARX_FATALIS_DIR}" != "" ]
			then local _srcdir="${ARX_FATALIS_DIR}"
			else if [ -f "${MY_DATADIR}/data.pak" ]
				then local _srcdir="${MY_DATADIR}"
				else
					eerror "You need either set ARX_FATALIS_DIR to point to an existing Arx Fatalis"
					eerror "installation or use the gog or cdinstall use flags:"
					eerror "  export ARX_FATALIS_DIR=/path/to/arx"
					eerror "This is only needed for the first install - after that the game data will"
					eerror "be copied from existing installs unless specified otherwise."
					die "Could not find game data."
			fi
		fi
		"${FILESDIR}/install-copy" "${_srcdir}" "${S}" || die "unpack failed"
	fi
}

src_install() {

	insinto "${MY_DATADIR}"
	doins -r * || die "doins failed"

	prepgamesdirs
}

pkg_postinst() {

	if use cdinstall || use gog ; then
		elog Now that the Arx Fatalis data has been installed you can remove the cdinstall
		elog and gog use flags. This package will try to use existing installed data if
		elog no use flags are set and ARX_FATALIS_DIR is not defined.
	fi

	games_pkg_postinst
}
