# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=8

inherit unpacker

MY_PN="libamdenc-amdgpu-pro"

INTERNAL_VER="6.1.3"
UBUNTU_VER="22.04"

PV_MAJOR=$(ver_cut 1)
PV_MINOR=$(ver_cut 2)
PV_REV=$(ver_cut 3)

MY_PV="${PV_MAJOR}.${PV_MINOR}"
PV_FULL="${MY_PV}-${PV_REV}"

DESCRIPTION="AMD's closed source Advanced Media Framework (AMF) encoding library"
HOMEPAGE="https://www.amd.com/en/support"
SRC_URI="https://repo.radeon.com/amdgpu/${INTERNAL_VER}/ubuntu/pool/proprietary/liba/${MY_PN}/${MY_PN}_${PV_FULL}.${UBUNTU_VER}_amd64.deb -> ${P}.deb"

S="${WORKDIR}"

RESTRICT="bindist mirror"

LICENSE="AMD-GPU-PRO-EULA"
SLOT="0"
KEYWORDS="-* ~amd64"

RDEPEND="
  media-libs/libglvnd
  x11-libs/libdrm
"

QA_PREBUILT="
  usr/lib64/libamdenc64.so*
"

src_unpack() {
  mkdir "${S}/${PN}-amd64" || die
  cd "${S}/${PN}-amd64" || die
  unpack_deb "${DISTDIR}/${P}.deb"
}

src_install() {
  insinto "/usr/$(get_libdir)"

  doins "${S}/${PN}-amd64/opt/amdgpu-pro/lib/x86_64-linux-gnu/libamdenc64.so.${MY_PV}"
  dosym "libamdenc64.so.${MY_PV}" "/usr/$(get_libdir)/libamdenc64.so.${PV_MAJOR}"
  dosym "libamdenc64.so.${MY_PV}" "/usr/$(get_libdir)/libamdenc64.so"
}
