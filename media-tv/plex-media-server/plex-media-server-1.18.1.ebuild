# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit eutils user rpm
MAGIC1="1973"
MAGIC2="0f4abfbcc"
# URI="https://downloads.plex.tv/plex-media-server"
URI="https://downloads.plex.tv/plex-media-server-new"
DESCRIPTION="Plex Media Server is an organizer for your media and provides streaming over the web and to devices"
HOMEPAGE="http://plex.tv/"
KEYWORDS="~amd64"

SRC_URI="${URI}/${PV}.${MAGIC1}-${MAGIC2}/redhat/plexmediaserver-${PV}.${MAGIC1}-${MAGIC2}.x86_64.rpm"

SLOT="0"
LICENSE="PMS-License"
IUSE=""
RDEPEND="net-dns/avahi
         app-arch/rpm
	 dev-db/soci
	 dev-util/patchelf"

DEPEND="${RDEPEND}"

QA_PRESTRIPPED="usr/lib/plexmediaserver/*.*"

pkg_setup() {
	enewgroup plex
	enewuser plex -1 /bin/bash /var/lib/plexmediaserver "plex" --system
        S="${WORKDIR}"/usr/lib/plexmediaserver
}


src_unpack () {
        rpm_src_unpack ${A}
}

src_prepare() {
	default
	# scanelf: rpath_security_checks(): Security problem with relative DT_RPATH '.'
	for file in "${S}"/Resources/Python/lib/python2.7/{site-packages/lxml/etree.so,site-packages/lxml/objectify.so,site-packages/simplejson/_speedups.so,lib-dynload/_bisect.so}
	do
	  patchelf --set-rpath '$ORIGIN' $file || die
	done
}

src_install() {
        cd ${S}
	dodir /etc/plex || die
	keepdir /var/log/pms || die
	dodir /usr/lib/plexmediaserver || die
	fperms 0755 /usr/lib/plexmediaserver || die
	cp -R "${S}/" "${D}"/usr/lib/ || die "Install failed!"
        dobin "${FILESDIR}"/start_pms || die
	newinitd "${FILESDIR}"/plex-media-server_initd plex-media-server || die
        insinto /etc/plex || die
        doins "${FILESDIR}"/plexmediaserver.conf || die
	keepdir /var/lib/plexmediaserver
	chown plex:plex "${D}"var/lib/plexmediaserver || die
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
