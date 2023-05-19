# Copyright 2020-2023 Daniel Scharrer
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit check-reqs

DESCRIPTION="Arx Fatalis data files"
HOMEPAGE="https://web.archive.org/web/20180201053030/https://www.arkane-studios.com/uk/arx.php"
SRC_URI="setup_arx_fatalis_1.21_(21994).exe"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+gog"
REQUIRED_USE="gog"
RESTRICT="binchecks mirror fetch"

RDEPEND="games-rpg/arx-libertatis"
DEPEND="${RDEPEND}
	app-arch/innoextract[lzma]"

CHECKREQS_DISK_BUILD="621M"
CHECKREQS_DISK_USR="617M"

S="${WORKDIR}"

pkg_nofetch() {
	einfo ""
	einfo "Please put setup_arx_fatalis_1.21_(21994).exe into your DISTDIR directory."
	einfo ""
	einfo "If your GOG.com Arx Fatalis installer is named setup_arx_fatalis.exe rename it."
	einfo ""
	einfo "For CD versions and older GOG installers named setup_arx_fatalis.exe or"
	einfo "setup_arx_fatalis_2.0.0.7.exe please use version 1.21 of this ebuild."
	einfo ""
	einfo "For version 1.22 installers use the appropriate version of thsi ebuild."
}

src_unpack() {
	arx-install-data --no-patch --batch --data-dir="${S}" --source="${DISTDIR}/${A}"
}

src_install() {
	insinto /usr/share/arx
	doins -r *
}
