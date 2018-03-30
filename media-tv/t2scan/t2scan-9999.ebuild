# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils git-r3
DESCRIPTION="a small channel scan tool which generates DVB-T/T2 channels.conf"
HOMEPAGE="https://github.com/mighty-p/t2scan/"
EGIT_REPO_URI="https://github.com/mighty-p/t2scan/"

SRC_URI=""

# EGIT_COMMIT=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=virtual/linuxtv-dvb-headers-5.3"
RDEPEND=""

src_install() {
	default
}
