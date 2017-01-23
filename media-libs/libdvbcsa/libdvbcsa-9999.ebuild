# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit eutils subversion git-r3

EGIT_REPO_URI="https://code.videolan.org/videolan/libdvbcsa.git"

DESCRIPTION="libdvbcsa is a free implementation of the DVB Common Scrambling Algorithm - DVB/CSA - with encryption and decryption capabilities."
HOMEPAGE="http://www.videolan.org/developers/libdvbcsa.html/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ppc"
IUSE="uint32 uint64 mmx sse2 altivec"

src_prepare() {
	./bootstrap || die "bootstrap failed"
	eapply_user
}

src_compile() {
	econf --prefix="/usr" \
	$(use_enable altivec) \
	$(use_enable uint32) \
	$(use_enable uint64) \
	$(use_enable mmx) \
	$(use_enable sse2) || die "configure failed"
	emake || die "make failed"
}

src_install() {
	default
}

pkg_postinst() {
	einfo "Runing Benchmarks ... "
	"${S}"/test/testdec
	"${S}"/test/benchdec
	einfo "Done"
}
