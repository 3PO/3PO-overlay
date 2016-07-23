# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils git-2

DESCRIPTION="TV Spielfilm loader plugin for EPGd"
HOMEPAGE="https://github.com/chriszero/epgd-plugin-tvsp"

# EGIT_REPO_URI="https://github.com/chriszero/epgd-plugin-tvsp.git"
: ${EGIT_REPO_URI:=${EPGD_PLUGIN_TVSP_GIT_REPO_URI:-git://github.com/chriszero/epgd-plugin-tvsp.git}}
: ${EGIT_BRANCH:=${EPGD_PLUGIN_TVSP_GIT_BRANCH:-master}}

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
	newins configs/epgd.conf epgd.conf-tvsp
	exeinto /usr/lib/epgd/plugins || die
	doexe *.so
}

pkg_postinstall() {
	einfo "Please merge any 'TV Spielfilm'-specific channelmap entries you need,"
	einfo "to '/etc/epgd/channelmap.conf' manually"
}