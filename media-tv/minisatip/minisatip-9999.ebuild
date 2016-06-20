# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils autotools git-2 flag-o-matic

DESCRIPTION="minisatip is an SATIP server for linux using local DVB-S2, DVB-S or DVB-T cards"
HOMEPAGE="https://github.com/catalinii/minisatip"

EGIT_REPO_URI="https://github.com/catalinii/minisatip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="-dvbcsa"

DEPEND="
	dev-vcs/git
	dvbcsa? ( media-libs/libdvbcsa )
"

RDEPEND="${DEPEND}"


src_unpack() {

	git-2_src_unpack
}


src_prepare() {
 
	if ! use dvbcsa ; then
	  sed -i "${S}"/Makefile -e "s/DVBCSA?=yes/DVBCSA?=no/" || die
	fi
      	append-flags -lpthread -fPIC -lrt
#	filter-flags -O2 -pipe
}


src_install() {

	dobin minisatip || die
	insinto /etc/minisatip/html/ || die
	doins html/* || die
	newinitd "${FILESDIR}"/minisatip.initd minisatip || die
	newconfd "${FILESDIR}"/minisatip.confd minisatip || die
}

