# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils user rpm
MAGIC1="3433"
MAGIC2="03e4cfa35"
URI="https://downloads.plex.tv/plex-media-server"
DESCRIPTION="Plex Media Server is an organizer for your media and provides streaming over the web and to devices"
HOMEPAGE="http://plex.tv/"
KEYWORDS="~amd64"

SRC_URI="${URI}/${PV}.${MAGIC1}-${MAGIC2}/plexmediaserver-${PV}.${MAGIC1}-${MAGIC2}.x86_64.rpm"

SLOT="0"
LICENSE="PMS-License"
IUSE=""
RDEPEND="net-dns/avahi
         app-arch/rpm
	 dev-db/soci"

DEPEND="${RDEPEND}"

pkg_setup() {
	enewgroup plex
	enewuser plex -1 /bin/bash /var/lib/plexmediaserver "plex" --system
        S="${WORKDIR}"/usr/lib/plexmediaserver
}


src_unpack () {

        rpm_src_unpack ${A}
}


src_install() {

        cd ${S}
	dodir /etc/plex || die
	dodir /var/log/pms || die
	dodir /usr/lib/plexmediaserver || die
	fperms 0755 /usr/lib/plexmediaserver || die
	cp -R "${S}/" "${D}"/usr/lib/ || die "Install failed!"
        dobin "${FILESDIR}"/start_pms || die
	newinitd "${FILESDIR}"/plex-media-server_initd plex-media-server || die
        insinto /etc/plex || die
        doins "${FILESDIR}"/plexmediaserver.conf || die
	dodir /var/lib/plexmediaserver
	chown plex:plex "${D}"var/lib/plexmediaserver || die
	dodir /var/log/pms
	chown plex:plex "${D}"var/log/pms || die


}

pkg_postinst() {
	einfo ""
	elog "Plex Media Server is now fully installed. Please check the configuration file in /etc/plex if the defaults please your needs."
	elog "To start please call '/etc/init.d/plex-media-server start'. You can manage your library afterwards by navigating to http://<ip>:32400/web/"
	einfo ""
	ewarn "Please note, that the URL to the library management has changed from http://<ip>:32400/manage to http://<ip>:32400/web!"
	ewarn "If the new management interface forces you to log into myPlex and afterwards gives you an error that you need to be a plex-pass subscriber please delete the folder WebClient.bundle inside the Plug-Ins folder found in your library!"
}
