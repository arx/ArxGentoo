# ArxGentoo - Arx Libertatis gentoo overlay

Please only use the `issues` tab here for problems with the ebuilds.

Bugs in the software itself should go to the upstream bug trackers:

* app-arch/innoextract: [innoextract.constexpr.org/issues](https://innoextract.constexpr.org/issues)
* games-rpg/arx-libertatis: [bugs.arx-libertatis.org](https://bugs.arx-libertatis.org/)

This is a gentoo overlay that can be used with eselect-repository to install [Arx Libertatis](https://arx-libertatis.org/) and other software under [Gentoo Linux](https://gentoo.org/).

Refer to the [Wiki](https://wiki.arx-libertatis.org/) on how to install Arx Libertatis [under other Linux distributions or Windows](https://wiki.arx-libertatis.org/Download_and_installation).

## Installing

You will need [eselect-repository](https://github.com/projg2/eselect-repository/) with **git** support, so install that first if you don't have it already:

    emerge --noreplace app-eselect/eselect-repository

Next, to add this overlay run:

    eselect repository enable arx-libertatis

You can then install the packages using emerge.

## Packages

* `app-arch/innoextract`: [A tool to unpack installers created by Inno Setup](https://constexpr.org/innoextract/)
* `games-rpg/arx-fatalis-data`: [Arx Fatalis data](https://web.archive.org/web/20180201053030/https://www.arkane-studios.com/uk/arx.php)
* `games-rpg/arx-libertatis`: [Cross-platform port of Arx Fatalis, a first-person role-playing game](https://arx-libertatis.org/)

## Contact

IRC: \#arxfatalis on irc.freenode.net

Website: [arx-libertatis.org](https://arx-libertatis.org/)

Repository maintainer: [Daniel Scharrer](https://constexpr.org/)
