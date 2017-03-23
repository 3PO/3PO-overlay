# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_DEPEND="2"

inherit eutils git-2 python-utils-r1

DESCRIPTION="a EPG daemon which fetch the EPG and additional data from various sources"
HOMEPAGE="http://projects.vdr-developer.org/projects/vdr-epg-daemon"
# EGIT_REPO_URI="git://projects.vdr-developer.org/vdr-epg-daemon.git"
: ${EGIT_REPO_URI:=${EPGD_GIT_REPO_URI:-git://projects.vdr-developer.org/vdr-epg-daemon.git}}
: ${EGIT_BRANCH:=${EPGD_GIT_BRANCH:-master}}

SRC_URI=""

# EGIT_COMMIT=""

LICENSE=""
SLOT="0"
KEYWORDS=""

IUSE=" tvm tvsp -debug -systemd"

DEPEND="dev-vcs/git
        app-arch/libarchive
        net-misc/curl
        dev-libs/libxslt
        dev-libs/libxml2
        >=dev-db/mysql-5.1.70
        dev-libs/libzip
        dev-libs/jansson
        media-libs/imlib2
        net-libs/libmicrohttpd[messages,epoll]
        dev-java/rhino"        
       
RDEPEND="${DEPEND}"

PDEPEND="tvm? ( media-tv/epgd-plugin-tvm )
	tvsp? ( media-tv/epgd-plugin-tvsp )"


pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_unpack() {

	git-2_src_unpack || default

}

src_prepare() {
  
	MAKEOPTS="-j1"
	cd "${WORKDIR}/${P}"

	sed -i Make.config -e "s/\/local//"

	sed -i http/Makefile -e "s/^LESS_Compiler.*/LESS_Compiler=\/usr\/bin\/jsscript-1.6/" || die

        if use systemd; then
	  einfo "Using init system 'systemd'"
	else
	  einfo "Using init systemd 'none'"
	  sed -i Make.config -e "s/INIT_SYSTEM  = systemd/INIT_SYSTEM  = none/"
	fi

	if use debug; then
	  sed -i Make.config -e "s/# DEBUG/DEBUG/"
	fi

       EPATCH_OPTS="-p1" 
	for LOCALPATCH in ${EPGD_LOCAL_PATCHES_DIR}/*.{diff,patch}; do
	  test -f "${LOCALPATCH}" && epatch "${LOCALPATCH}"
	done

}

src_install() {

	emake DESTDIR="${D}" install
	insinto $(mysql_config --plugindir) || die
	doins epglv/mysql*.so
	newinitd "${FILESDIR}"/epgd.initd epgd || die
	newconfd "${FILESDIR}"/epgd.confd epgd || die
        mkdir include
       	find . -name "*.h" | xargs cp --parents --target-directory="include"
        insinto /usr/include/epgd
	doins Make.config
	doins -r include/*

}

pkg_postinst() {
	einfo "Please reffer to the wiki for assistance with the setup"
	einfo "located at http://projects.vdr-developer.org/projects/vdr-epg-daemon/wiki"
	einfo "You can use \"epgd-tool\" for installing the MySQL Database"

}		
