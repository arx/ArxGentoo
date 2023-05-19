# Copyright 2020-2023 Daniel Scharrer
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CDROM_OPTIONAL="yes"
inherit cdrom check-reqs

DESCRIPTION="Arx Fatalis data files"
HOMEPAGE="https://web.archive.org/web/20180201053030/https://www.arkane-studios.com/uk/arx.php"
SRC_URI="cdinstall? ( https://cdn.bethsoft.com/arxfatalis/patches/1.21/ArxFatalis_1.21_MULTILANG.exe )
	gog? ( setup_arx_fatalis_2.0.0.7.exe )"

LICENSE="cdinstall? ( all-rights-reserved ) gog? ( GOG-EULA )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gog"
REQUIRED_USE="|| ( !cdinstall !gog )"
RESTRICT="binchecks mirror gog? ( fetch )"

RDEPEND="games-rpg/arx-libertatis"
DEPEND="${RDEPEND}
	gog? ( app-arch/innoextract[lzma] )
	cdinstall? (
		|| ( app-arch/cabextract app-arch/libarchive app-arch/p7zip )
		app-arch/innoextract[lzma]
	)"

CHECKREQS_DISK_BUILD="621M"
CHECKREQS_DISK_USR="617M"

S="${WORKDIR}"

pkg_nofetch() {
	einfo ""
	einfo "Please put setup_arx_fatalis_2.0.0.7.exe into your DISTDIR directory."
	einfo ""
	einfo "If your GOG.com Arx Fatalis installer is named setup_arx_fatalis.exe rename it."
	einfo ""
	einfo "For setup_arx_fatalis_1.21_(21994).exe use version 1.21.21994 of this ebuild."
	einfo ""
	einfo "For version 1.22 installers use the appropriate version of thsi ebuild."
}

src_unpack() {
	local arx_install_data_options=( --no-patch --batch --data-dir="${S}" )
	if use gog ; then
		arx_install_data_options+=( --source="${DISTDIR}/${A}" )
	elif use cdinstall ; then
		cdrom_get_cds "bin/Arx.ttf"
		arx_install_data_options+=( --source="${CDROM_ROOT}" --patch="${DISTDIR}/${A}" )
	elif [ -z "${ARX_FATALIS_SRC}" ] ; then
		eerror "You need set ARX_FATALIS_SRC to point to an existing Arx Fatalis install:"
		eerror "  export ARX_FATALIS_SRC=/path/to/arx"
		eerror ""
		eerror "Alternatively, use the gog USE flag for older GOG.com 1.21 installers"
		eerror "or the cdinstall USE flag for installing from a CD."
		eerror ""
		eerror "Use version 1.21.21994 or 1.22 of this ebuild for wewer GOG.com installers."
		die "Could not find game data."
	else
		arx_install_data_options+=( --source="${ARX_FATALIS_SRC}" )
	fi
	arx-install-data "${arx_install_data_options[@]}"
}

src_install() {
	insinto /usr/share/arx
	doins -r *
}
