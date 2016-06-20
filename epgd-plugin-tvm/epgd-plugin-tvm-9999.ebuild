# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils git-2

DESCRIPTION="TV Spielfilm loader plugin for EPGd"
HOMEPAGE="https://github.com/3PO/epgd-plugin-tvm"

EGIT_REPO_URI="https://github.com/3PO/epgd-plugin-tvm"
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS=""


DEPEND="media-tv/epgd"

RDEPEND="${DEPEND}"

src_prepare() {
	sed -i Makefile -e 's/^EPGD_SRC.*/EPGD_SRC=\/usr\/include\/epgd/'
}

src_install() {

	MAKEOPTS="-j1"
        emake DESTDIR="${D}" install-config	
	insinto /etc/epgd || die
	doins configs/*.conf
	exeinto /usr/lib/epgd/plugins || die
	doexe *.so
}

pkg_postinstall() {
	einfo "Please merge any 'TV Movie'-specific channelmap entries you need,"
	einfo "to '/etc/epgd/channelmap.conf' manually"
}