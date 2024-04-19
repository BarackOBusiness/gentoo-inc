# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=8


inherit cmake

DESCRIPTION="A powerful and versatile multimedia development framework"
HOMEPAGE="https://arcan-fe.com/"
LICENSE="BSD-3-Clause GPL-2.0-or-later"

SRC_URI="https://github.com/letoram/${PN}/archive/refs/tags/${PV}.tar.gz"
KEYWORDS="~amd64"
SLOT="0"

IUSE="wayland -ffmpeg"

# Definitely need to figure all this shit out
#RDEPEND=""
#DEPEND="${RDEPEND}"
#BDEPEND="virtual/pkgconfig"

src_prepare() {
	# ???????? What the FUCK
	cd "${S}/src"
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DDISTR_TAG='Gentoo Linux'
		# -DBUILD_PRESET="everything"
		-DVIDEO_PLATFORM=egl-dri
		-DHYBRID_SDL=On
		-DDISABLE_WAYLAND=$(use wayland && echo OFF || echo ON)
		-DDISABLE_FSRV_ENCODE=$(use ffmpeg && echo OFF || echo ON)
	)
	cmake_src_configure
}

# The following src_compile function is implemented as default by portage, so
# you only need to call it, if you need different behaviour.
#src_compile() {
	# emake is a script that calls the standard GNU make with parallel
	# building options for speedier builds (especially on SMP systems).
	# Try emake first.  It might not work for some packages, because
	# some makefiles have bugs related to parallelism, in these cases,
	# use emake -j1 to limit make to a single process.  The -j1 is a
	# visual clue to others that the makefiles have bugs that have been
	# worked around.

	#emake
#}

# The following src_install function is implemented as default by portage, so
# you only need to call it, if you need different behaviour.
#src_install() {
	# You must *personally verify* that this trick doesn't install
	# anything outside of DESTDIR; do this by reading and
	# understanding the install part of the Makefiles.
	# This is the preferred way to install.
	#emake DESTDIR="${D}" install

	# When you hit a failure with emake, do not just use make. It is
	# better to fix the Makefiles to allow proper parallelization.
	# If you fail with that, use "emake -j1", it's still better than make.

	# For Makefiles that don't make proper use of DESTDIR, setting
	# prefix is often an alternative.  However if you do this, then
	# you also need to specify mandir and infodir, since they were
	# passed to ./configure as absolute paths (overriding the prefix
	# setting).
	#emake \
	#	prefix="${D}"/usr \
	#	mandir="${D}"/usr/share/man \
	#	infodir="${D}"/usr/share/info \
	#	libdir="${D}"/usr/$(get_libdir) \
	#	install
	# Again, verify the Makefiles!  We don't want anything falling
	# outside of ${D}.
#}
