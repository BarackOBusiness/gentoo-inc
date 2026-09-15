# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=8

inherit flag-o-matic

DESCRIPTION="A roguelike set in a hyperbolic world"
HOMEPAGE="https://roguetemple.com/z/hyper/"
LICENSE="GPL-2.0"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/zenorogue/${PN}.git"
else
	SRC_URI="https://github.com/zenorogue/${PN}/archive/refs/tags/v${PV}.tar.gz"
	KEYWORDS="~amd64"
fi

SLOT="0"

IUSE="+sdl2 sdl3"
REQUIRED_USE="|| ( sdl2 sdl3 )"

# SDL3 requires sdl3_gfx to be packages
RDEPEND="
	media-libs/glew
	media-libs/libpng
	sdl2? (
		media-libs/libsdl2
		media-libs/sdl2-mixer
		media-libs/sdl2-gfx
		media-libs/sdl2-ttf
	)
	sdl3? (
		media-libs/libsdl3
		media-libs/sdl3-mixer
		media-libs/sdl3_gfx
		media-libs/sdl3-ttf
	)
"
DEPEND="${RDEPEND}"
BDEPEND="dev-build/make"

src_compile() {
	local opts=$(
		use sdl2 && echo "-sdl2"
		use sdl3 && echo "-sdl3"
	)
	opts+=" -O3"

	# This is what the makefile does, but alas, doesn't work outside of the makefile context
	# which is a problem because the makefile doesn't get updated to build SDL2/3
	# append-cxxflags $(pkg-config --cflags fontconfig)
	# append-ldflags $(pkg-config --libs fontconfig)

	make mymake
	./mymake $opts
}

src_install() {
	exeinto "/usr/bin"
	newexe "hyper" "hyperrogue"

	insinto "/usr/share/hyperrogue"
	doins -r "music"
	doins -r "sounds"
	doins "hyperrogue-music.txt"
	# These should probably be handled by fontconfig but there's no feasible way to do that 
	doins "DejaVuSans.ttf"
	doins "DejaVuSans-Bold.ttf"

	insinto "/usr/share/applications"
	doins "contrib/hyperrogue.desktop"

	local icon_sizes=(36x36:ldpi 48x48:mdpi 72x72:hdpi 96x96:xhdpi 144x144:xxhdpi 192x192:xxxhdpi)
	for size_dpi in "${icon_sizes[@]}"; do
		size=${size_dpi%:*}
		dpi=${size_dpi#*:}
		insinto "/usr/share/icons/hicolor/$size/apps/"
		newins "hyperroid/app/src/main/res/drawable-$dpi/icon.png" "hyperrogue.png"
	done
}
