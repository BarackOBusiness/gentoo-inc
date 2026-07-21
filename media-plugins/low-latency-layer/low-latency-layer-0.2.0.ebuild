# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Vulkan layer for hardware agnostic input latency reduction"
HOMEPAGE="https://github.com/Korthos-Software/low_latency_layer"
LICENSE="MIT"

MY_PN="low_latency_layer"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Korthos-Software/${MY_PN}.git"
else
	SRC_URI="https://github.com/Korthos-Software/${MY_PN}/archive/refs/tags/v${PV}.tar.gz"
	KEYWORDS="~amd64"
fi

SLOT="0"

S="${WORKDIR}/${MY_PN}-${PV}"

BDEPEND="
	dev-util/vulkan-headers
	dev-util/vulkan-utility-libraries
"
