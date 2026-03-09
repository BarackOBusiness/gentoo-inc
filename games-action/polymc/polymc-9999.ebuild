# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=6.0.0
inherit cmake java-pkg-2 optfeature toolchain-funcs xdg

DESCRIPTION="Custom, open source Minecraft launcher"
HOMEPAGE="https://polymc.org/ https://github.com/PolyMC/PolyMC"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/PolyMC/PolyMC"
	EGIT_SUBMODULES=( 'depends/libnbtplusplus' 'libraries/quazip' 'libraries/tomlplusplus' 'libraries/filesystem' )
else
	MY_PN="PolyMC"
	# use vendored tarball to avoid dealing with submodules directly
	SRC_URI="
		https://github.com/PolyMC/PolyMC/releases/download/${PV}/${MY_PN}-${PV}.tar.gz -> ${P}.tar.gz
	"
	S="${WORKDIR}/${MY_PN}-${PV}"
	KEYWORDS="~amd64 ~arm64"
fi

# GPL-3 for PolyMC
# Apache-2.0 for MultiMC (PolyMC is forked from it)
# LGPL-3+ for libnbtplusplus
# rest of its libs: https://github.com/PolyMC/PolyMC/tree/develop/libraries
LICENSE="Apache-2.0 BSD BSD-2 GPL-2+ GPL-3 ISC LGPL-2.1+ LGPL-3+"
SLOT="0"
IUSE="test"

RESTRICT="!test? ( test )"

# Required at both build time and runtime
COMMON_DEPEND="
	app-text/cmark:=
	>=dev-qt/qtbase-${QTMIN}:6[concurrent,gui,network,widgets,xml(+)]
	>=dev-qt/qtnetworkauth-${QTMIN}:6
	>=dev-qt/qtcharts-${QTMIN}:6
	media-gfx/qrencode:=
	virtual/zlib:=
"
# max jdk-25 for bug #968411
DEPEND="${COMMON_DEPEND}
	media-libs/libglvnd
	<virtual/jdk-26:*
"
# QtSvg imageplugin needed at runtime for svg icons, via QIcon.
# At runtime we don't depend on JDK, only JRE
# And we need more than just the GL headers
RDEPEND="${COMMON_DEPEND}
	>=dev-qt/qtsvg-${QTMIN}:6
	>=virtual/jre-1.8.0:*
	virtual/opengl
"
BDEPEND="
	app-text/scdoc
	>=kde-frameworks/extra-cmake-modules-6.0.0:*
	virtual/pkgconfig
"

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
		-DCMAKE_INSTALL_PREFIX="/usr"
		-DLauncher_BUILD_PLATFORM="Gentoo"
		-DLauncher_QT_VERSION_MAJOR=6

		-DENABLE_LTO=$(tc-is-lto)
		-DBUILD_TESTING=$(usex test)
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

pkg_postinst() {
	xdg_pkg_postinst

	# Original issue: https://github.com/PolyMC/PolyMC/issues/227
	optfeature "old Minecraft (<= 1.12.2) support" x11-apps/xrandr

	optfeature "built-in MangoHud support (available in GURU overlay)" games-util/mangohud
	optfeature "built-in Feral Gamemode support" games-util/gamemode
}
