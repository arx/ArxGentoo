# ArxGentoo - Arx Libertatis gentoo overlay

Please only use the `issues` tab here for problems with the ebuilds.

Bugs in the software itself should go to the upstream bug trackers:

* app-arch/innoextract: [innoextract.constexpr.org/issues](http://innoextract.constexpr.org/issues)
* games-rpg/arx-libertatis: [bugs.arx-libertatis.org](https://bugs.arx-libertatis.org/)

This is a gentoo overlay that can be used with layman to install [Arx Libertatis](http://arx-libertatis.org/) and other software under [Gentoo Linux](http://www.gentoo.org/).

Refer to the [Wiki](http://wiki.arx-libertatis.org/) on how to install Arx Libertatis [under other Linux distributions or Windows](http://wiki.arx-libertatis.org/Download_and_installation).

## Installing

You will need [layman](http://layman.sourceforge.net/) with **git** support, so install that first if you don't have it already:

    emerge app-portage/layman[git]

Next, to add this overlay run:

    layman -f -a arx-libertatis

You can then install the packages using emerge.

## Updating

Overlays added using layman won't be updated by `emerge --fetch`, you need to run

    layman -S

## Packages

* `app-arch/innoextract`: [A tool to unpack installers created by Inno Setup](http://constexpr.org/innoextract/)
* `games-rpg/arx-fatalis-data`: [Arx Fatalis data](http://www.arkane-studios.com/uk/arx.php)
* `games-rpg/arx-libertatis`: [Cross-platform port of Arx Fatalis, a first-person role-playing game](http://arx-libertatis.org/)

## Contact

IRC: \#arxfatalis on irc.freenode.net

Website: [http://arx-libertatis.org/](http://arx-libertatis.org/)

Repository maintainer: [Daniel Scharrer](http://constexpr.org/)
