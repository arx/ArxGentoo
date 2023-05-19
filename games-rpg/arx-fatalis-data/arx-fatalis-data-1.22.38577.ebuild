# Copyright 2020-2023 Daniel Scharrer
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit check-reqs

DESCRIPTION="Arx Fatalis data files"
HOMEPAGE="https://web.archive.org/web/20180201053030/https://www.arkane-studios.com/uk/arx.php"
SRC_URI="gog? (
		!french? ( !german? ( !italian? ( !russian? ( !spanish? (
			setup_arx_fatalis_1.22_(38577).exe
			setup_arx_fatalis_1.22_(38577)-1.bin
		) ) ) ) )
		french? (
			setup_arx_fatalis_1.22_(french)_(38577).exe
			setup_arx_fatalis_1.22_(french)_(38577)-1.bin
		)
		german? (
			setup_arx_fatalis_1.22_(german)_(38577).exe
			setup_arx_fatalis_1.22_(german)_(38577)-1.bin
		)
		italian? (
			setup_arx_fatalis_1.22_(italian)_(38577).exe
			setup_arx_fatalis_1.22_(italian)_(38577)-1.bin
		)
		russian? (
			setup_arx_fatalis_1.22_(russian)_(38577).exe
			setup_arx_fatalis_1.22_(russian)_(38577)-1.bin
		)
		spanish? (
			setup_arx_fatalis_1.22_(spanish)_(38577).exe
			setup_arx_fatalis_1.22_(spanish)_(38577)-1.bin
		)
	)"

LICENSE="gog? ( GOG-EULA )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gog french german italian russian spanish"
REQUIRED_USE="
	french? ( gog !german !italian !russian !spanish )
	german? ( gog !french !italian !russian !spanish )
	italian? ( gog !french !german !russian !spanish )
	russian? ( gog !french !german !italian !spanish )
	spanish? ( gog !french !german !italian !russian )"
RESTRICT="binchecks mirror gog? ( fetch )"

RDEPEND="games-rpg/arx-libertatis"
DEPEND="${RDEPEND}
	gog? ( app-arch/innoextract[lzma] app-arch/libarchive )"
# TODO Remove app-arch/libarchive once arx-install-data is fixed

CHECKREQS_DISK_BUILD="621M"
CHECKREQS_DISK_USR="617M"

S="${WORKDIR}"

pkg_nofetch() {
	einfo ""
	einfo "Please download the OFFLINE BACKUP GAME INSTALLERS for Arx Fatalis from your"
	einfo "GOG.com account and place both the .exe and .bin into your DISTDIR directory."
	einfo ""
	einfo "Expected Filenames (use the corresponding USE flag for non-english):"
	einfo " english: setup_arx_fatalis_1.22_(38577){.exe,-1.bin}"
	einfo " french: setup_arx_fatalis_1.22_(french)_(38577){.exe,-1.bin}"
	einfo " german: setup_arx_fatalis_1.22_(german)_(38577){.exe,-1.bin}"
	einfo " italian: setup_arx_fatalis_1.22_(italian)_(38577){.exe,-1.bin}"
	einfo " russian: setup_arx_fatalis_1.22_(russian)_(38577){.exe,-1.bin}"
	einfo " spanish: setup_arx_fatalis_1.22_(spanish)_(38577){.exe,-1.bin}"
	einfo ""
	einfo "For CD versions and older GOG installers named setup_arx_fatalis.exe or"
	einfo "setup_arx_fatalis_2.0.0.7.exe or setup_arx_fatalis_1.21_(21994).exe"
	einfo "please use version 1.21 or 1.21.21994 of this ebuild."
}

src_unpack() {
	set -- ${A}
	local arx_install_data_options=( --no-patch --batch --data-dir="${S}" )
	if use gog ; then
		arx_install_data_options+=( --source="${DISTDIR}/${A%% *}" )
	elif [ -z "${ARX_FATALIS_SRC}" ] ; then
		eerror "You need set ARX_FATALIS_SRC to point to an existing Arx Fatalis install:"
		eerror "  export ARX_FATALIS_SRC=/path/to/arx"
		eerror ""
		eerror "Alternatively, use the gog USE flag for current GOG.com installers (version 1.22)."
		eerror ""
		eerror "Use version 1.21 of this ebuild for cdinstall or older GOG.com installers"
		eerror "named setup_arx_fatalis.exe or setup_arx_fatalis_2.0.0.7.exe or"
		eerror "setup_arx_fatalis_1.21_(21994).exe."
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
