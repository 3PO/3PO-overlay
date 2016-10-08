# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit flag-o-matic eutils subversion cmake-utils git-2

DESCRIPTION="OSCam is an Open Source Conditional Access Module software, based on the very good MpCS version 0.9d"
HOMEPAGE="http://streamboard.gmc.to:8001/wiki/"
EGIT_REPO_URI="https://github.com/oscam-emu/oscam-emu"
ESVN_REPO_URI="http://www.streamboard.tv/svn/oscam/trunk"

# ESVN_REVISION="11194" 

SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS=""

IUSE_ADDONS="+webif +touch +dvbapi +irdeto-guessing +anticacading -ssl +debug +monitor +loadbalancing +chacheex -led -lcd -ipv6 +clockfix -emu" 
IUSE_PROTOCOL="-camd33 +camd35_udp +camd35_tcp +newcamd +cccam +cccshare +gbox +radegast +serial +constantcw +pandora -ghttp"
IUSE_READER="+nagra +irdeto +conax +cryptoworks +seca +viaccess +videoguard +dre +tongfang +blucrypt +griffin +dgcrypt"
IUSE_CARDREADER="+phoenix +internal +sc8in1 +mp35 +smartreader +dbox2 +stapi pcsc"

IUSE="${IUSE_ADDONS} ${IUSE_PROTOCOL} ${IUSE_READER} ${IUSE_CARDREADER} cardreader +usb +doc"


DEPEND="dev-util/cmake
       dev-vcs/subversion
       dev-vcs/git
	ssl? ( dev-libs/openssl )
	usb? ( virtual/libusb:1 dev-libs/libusb-compat )
       pcsc? ( sys-apps/pcsc-lite )
	smartreader? ( dev-libs/libusb-compat )"

RDEPEND="${DEPEND}"

src_unpack() {

       subversion_src_unpack

       if use emu; then
            mkdir "${S}/oscam-emu"
            EGIT_SOURCEDIR="${S}/oscam-emu"
            git-2_src_unpack
       fi
}

src_prepare () {

	subversion_src_prepare  
  	sed -i -e 's:\(CMAKE_EXE_LINKER_FLAGS\) "-s":\1 "":' CMakeLists.txt || die
	sed -i 's|\(svnversion -n \)\.|\1/usr/portage/distfiles/svn-src/oscam/trunk|' config.sh || die
	epatch_user
        use emu && epatch "${EGIT_SOURCEDIR}/oscam-emu.patch"
}

src_configure() {

	local mycmakeargs="
		-DCS_CONFDIR=/etc/oscam
		-DCMAKE_VERBOSE_MAKEFILE=ON
		-INCLUDED=Yes 
		$(cmake-utils_use webif WEBIF)
		$(cmake-utils_use touch TOUCH)
		$(cmake-utils_use dvbapi HAVE_DVBAPI)
		$(cmake-utils_use irdeto-guessing IRDETO_GUESSING)
		$(cmake-utils_use anticacading CS_ANTICASC)
		$(cmake-utils_use debug WITH_DEBUG)
		$(cmake-utils_use monitor MODULE_MONITOR)
		$(cmake-utils_use ssl WITH_SSL)
		$(cmake-utils_use loadbalancing WITH_LB)
		$(cmake-utils_use chacheex CS_CACHEEX)
		$(cmake-utils_use lcd LEDSUPPORT)
		$(cmake-utils_use lcd LCDSUPPORT)
		$(cmake-utils_use ipv6 IPV6SUPPORT)
		$(cmake-utils_use clockfix CLOCKFIX)
		$(cmake-utils_use emu WITH_EMU)
		$(cmake-utils_use camd33 MODULE_CAMD33)
		$(cmake-utils_use camd35_udp MODULE_CAMD35)
		$(cmake-utils_use camd35_tcp MODULE_CAMD35_TCP)
		$(cmake-utils_use newcamd MODULE_NEWCAMD)
		$(cmake-utils_use cccam MODULE_CCCAM)
		$(cmake-utils_use cccshare MODULE_CCCSHARE)
		$(cmake-utils_use gbox MODULE_GBOX)
		$(cmake-utils_use radegast MODULE_RADEGAST)
		$(cmake-utils_use serial MODULE_SERIAL)
		$(cmake-utils_use constantcw MODULE_CONSTCW)
		$(cmake-utils_use pandora MODULE_PANDORA)
		$(cmake-utils_use ghttp MODULE_GHTTP)
		$(cmake-utils_use cardreader WITH_CARDREADER)
		$(cmake-utils_use nagra READER_NAGRA)
		$(cmake-utils_use irdeto READER_IRDETO)
		$(cmake-utils_use conax READER_CONAX)
		$(cmake-utils_use cryptoworks READER_CRYPTOWORKS)
		$(cmake-utils_use seca READER_SECA)
		$(cmake-utils_use viaccess READER_VIACCESS)
		$(cmake-utils_use videoguard READER_VIDEOGUARD)
		$(cmake-utils_use dre READER_DRE)
		$(cmake-utils_use tongfang READER_TONGFANG)
		$(cmake-utils_use blucrypt READER_BULCRYPT)
		$(cmake-utils_use griffin READER_GRIFFIN)
		$(cmake-utils_use dgcrypt READER_DGCRYPT)
		$(cmake-utils_use pcsc WITH_PCSC)"

       cmake-utils_src_configure
}

src_install() {

	cmake-utils_src_install

	if use smartreader; then
	  dobin "${WORKDIR}"/"${P}"_build/utils/list_smargo|| die
	fi

	dodir /etc/oscam || die
	dodir /var/log/oscam || die
	fperms 0755 /etc/oscam || die
	newinitd "${FILESDIR}"/oscam.initd oscam || die
	newconfd "${FILESDIR}"/oscam.confd oscam || die
	insinto /etc/oscam || die 
	doins "${WORKDIR}"/"${P}"/Distribution/doc/example/* || die
	exeinto /usr/bin || die
	doexe "${FILESDIR}"/watchdog/oscam_watchdog.sh || die

	if use doc; then
	  docinto examples
	  dodoc Distribution/doc/example/oscam.* || die
	fi
}

pkg_postinst() {
	einfo "Please reffer to the wiki for assistance with the setup "
	einfo "     located at http://www.streamboard.tv/oscam "
}		
