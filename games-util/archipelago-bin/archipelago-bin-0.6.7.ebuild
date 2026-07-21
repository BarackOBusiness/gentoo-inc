# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg-utils

MY_PN="Archipelago"

DESCRIPTION="Multi-Game Randomizer and Server"
HOMEPAGE="https://www.archipelago.gg"
SRC_URI="https://github.com/ArchipelagoMW/${MY_PN}/releases/download/${PV}/${MY_PN}_${PV}_linux-x86_64.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="strip"
QA_PREBUILT="*"

# I don't know
RDEPEND="${DEPEND}"

src_install() {
	# Create destination
	local destdir="/opt/archipelago"
	insinto "${destdir}"
	doins -r *
	# Install archipelago launcher wrapper to bin dir
	dobin "${FILESDIR}/archipelago-launcher" || die
	# Add icon
	newicon -s 512 "icon.png" archipelago.png
	# Create desktop entry
	make_desktop_entry --eapi9 "/usr/bin/archipelago-launcher" -n "Archipelago Launcher" -d archipelago -i archipelago
	# Handle permissions of executables
	fperms 0755 "${destdir}"/Archipelago{Adventure,AHIT,BizHawk,ChecksFinder,MMBN3,OoT,SNI,Text,Undertale,Zelda1,Zillion}Client
	fperms 0755 "${destdir}"/Archipelago{Generate,Launcher,LttPAdjuster,OoTAdjuster,OptionsCreator,Server}
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
