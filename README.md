# ArxGentoo - Arx Libertatis gentoo overlay

This is a gentoo overlay that can be used with layman to install [Arx Libertatis](https://github.com/arx/ArxLibertatis) under [Gentoo Linux](http://www.gentoo.org/).

Refer to the [Wiki](http://arx.parpg.net/) on how to install Arx Libertatis [under other linux distributions](http://arx.parpg.net/Downloading_and_Compiling_under_Linux) or [under windows](http://arx.parpg.net/Downloading_and_Compiling_under_Windows)

## Installing

You will need [layman](http://layman.sourceforge.net/) with **git** support, so install that first if you don't have it already:

    echo "app-portage/layman git" >> /etc/portage/package.use
    emerge -N app-portage/layman

Next, you need to add the **arx-libertatis** overlay that contains the arx ebuild.

    layman -f
    layman -a arx-libertatis

For now, there is only a live ebuild: this will compile and install the current ArxLibertatis git master. Like most gentoo live ebuilds, **games-rpg/arx-libertatis** needs to be unmasked before you can istall it:

    echo "games-rpg/arx-libertatis **" >> /etc/portage/package.keywords
    emerge games-rpg/arx-libertatis

This will install `/usr/games/bin/arx`. Remember that you need to be in the games group to run games under gentoo.
Updating

Overlays added using layman won't be updated by `emerge --fetch`, you need to run

    layman -S

As `games-rpg/arx-libertatis-9999` is a live ebuild, it won't be updated automatically (the version never changes), you need to manually re-emerge it.

Also see the [wiki page on installing Arx Libertatis under Linux](http://arx.parpg.net/Downloading_and_Compiling_under_Linux#Gentoo_Linux)

## Contact

IRC: \#arxfatalis on irc.freenode.net

Wiki: [http://arx.parpg.net/](http://arx.parpg.net/)

Reddit: [http://www.reddit.com/r/ArxFatalis/](http://www.reddit.com/r/ArxFatalis/)
