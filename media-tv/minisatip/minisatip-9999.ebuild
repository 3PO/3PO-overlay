# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils autotools git-2 flag-o-matic

DESCRIPTION="minisatip is an SATIP server for linux using local DVB-S2, DVB-S or DVB-T cards"
HOMEPAGE="https://github.com/catalinii/minisatip"

# EGIT_REPO_URI="https://github.com/catalinii/minisatip"
: ${EGIT_REPO_URI:=${MINISATIP_GIT_REPO_URI:=https://github.com/catalinii/minisatip}} 
: ${EGIT_BRANCH:=${MINISATIP_GIT_BRANCH:-master}} 

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="+linuxdvb -dvbca -dvbaes -dvbcsa -dvbapi +satipc -static"

DEPEND="
	dev-vcs/git
	dvbcsa? ( media-libs/libdvbcsa )
	dvbaes? ( dev-libs/openssl )	
"

RDEPEND="${DEPEND}"

src_unpack() {

	git-2_src_unpack
}

src_prepare() {

	sed -i "${S}"/adapter.h -e "s/#define MAX_ADAPTERS 16/#define MAX_ADAPTERS 32/" || die
	append-flags -lpthread -fPIC -lrt
	epatch_user
}

src_configure() {

    econf \
        $(use_enable linuxdvb) \
        $(use_enable dvbca) \
        $(use_enable dvbaes) \
        $(use_enable dvbcsa) \
        $(use_enable dvbapi) \
        $(use_enable satipc) \
        $(use_enable !static)								
}






src_install() {

	dobin minisatip || die
	insinto /etc/minisatip/html/ || die
	doins html/* || die
	newinitd "${FILESDIR}"/minisatip.initd minisatip || die
	newconfd "${FILESDIR}"/minisatip.confd minisatip || die
}
