# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-vm-2 toolchain-funcs

GRAALVM_PATCH="36.1"

DESCRIPTION="A high-performance Java Development Kit (JDK) Distribution by Oracle"
HOMEPAGE="https://www.graalvm.org"
SRC_URI="https://download.oracle.com/graalvm/$(ver_cut 1)/latest/graalvm-jdk-$(ver_cut 1)_linux-x64_bin.tar.gz"

LICENSE="GPL-2-with-classpath-exception"
SLOT="$(ver_cut 1)"
# KEYWORDS="-*"
S="${WORKDIR}/graalvm-jdk-$(ver_cut 1)+${GRAALVM_PATCH}"

RDEPEND="
	media-libs/alsa-lib
	media-libs/freetype
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXrender
	x11-libs/libXtst
"

src_install() {
  local dest="/opt/${P}"
  local ddest="${ED}/${dest#/}"

  rm -v lib/security/cacerts || die
  dosym -r /etc/ssl/certs/java/cacerts "${dest}"/lib/security/cacerts

  dodir "${dest}"
  cp -pPR * "${ddest}" || die

  dosym "${P}" "/opt/${PN}-${SLOT}"
  
  java-vm_install-env "${FILESDIR}"/${PN}.env.sh
  java-vm_set-pax-markings "${ddest}"
  java-vm_revdep-mask
  java-vm_sandbox-predict /dev/random /proc/self/coredump_filter
}

pkg_postinst() {
  java-vm-2_pkg_postinst
}
