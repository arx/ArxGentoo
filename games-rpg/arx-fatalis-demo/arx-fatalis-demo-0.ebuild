
EAPI="2"

inherit eutils games

DESCRIPTION="Arx Fatalis demo"
HOMEPAGE="http://www.arkane-studios.com/uk/arx.php"
SRC_URI="arx_demo_english.zip"

LICENSE="ArxFatalisDemo"
SLOT="0"
KEYWORDS=""
IUSE=""
RESTRICT="fetch"

RDEPEND="\
	games-rpg/arx-libertatis"

DEPEND="\
	app-arch/cabextract
	|| ( app-arch/unzip app-arch/libarchive )"

_arx_fatalis_demo_datadir="${GAMES_DATADIR}/${PN}"

pkg_nofetch() {
	einfo "Please find and download ${SRC_URI} and put it into ${DISTDIR}."
	einfo "There is a list of possible download locations at"
	einfo "http://wiki.arx-libertatis.org/Getting_the_game_data#Demo"
}

src_unpack() {
	"${FILESDIR}/install-demo" "${DISTDIR}/${A}" "${S}" || die "unpack failed"
}

src_compile() {
	local desktop_file=`cat "${FILESDIR}/${PN}.desktop"`
	desktop_file="${desktop_file/arx-fatalis-demo-datadir/${_arx_fatalis_demo_datadir}}"
	echo "$desktop_file" >> "${S}/${PN}.desktop"
}

src_install() {
	
	insinto "${_arx_fatalis_demo_datadir}"
	doins -r *.pak misc || die "doins failed"
	
	insinto "/usr/share/applications"
	doins "${PN}.desktop" || die "doins failed"
	
	prepgamesdirs
}
