# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=8

inherit cmake-multilib

DESCRIPTION="Reference implementation of the APV professional video format"
HOMEPAGE="https://github.com/AcademySoftwareFoundation/openapv"

if [[ ${PV} == 9999 ]]; then
  inherit git-r3
  EGIT_REPO_URI="https://github.com/AcademySoftwareFoundation/${PN}"
else
  SRC_URI="https://github.com/AcademySoftwareFoundation/${PN}/archive/refs/tags/v${PV}.tar.gz"
  KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD-3"
SLOT="0"

# Only depends on the build tools, which I think are handled by the eclass
