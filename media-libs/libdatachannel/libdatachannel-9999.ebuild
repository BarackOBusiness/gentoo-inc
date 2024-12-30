# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=8

inherit cmake

DESCRIPTION="A WebRTC network library"
HOMEPAGE="https://libdatachannel.org/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/paullouisageneau/${PN}.git"
	EGIT_SUBMODULES=(
		deps/json
		deps/libjuice
		deps/libsrtp
		deps/plog
		deps/usrsctp
	)
else
	SRC_URI="https://github.com/paullouisageneau/${PN}/archive/refs/tags/v${PV}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="MPL-2.0"
SLOT="0"

# IUSE=""

#RDEPEND=""
#DEPEND="${RDEPEND}"
#BDEPEND="virtual/pkgconfig"
