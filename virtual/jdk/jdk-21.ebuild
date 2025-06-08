# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for Java Development Kit (JDK)"
SLOT="${PV}"
# graalvm is only packaged for amd64
# mask this package and it if you are using otherwise
KEYWORDS="amd64"
IUSE="headless-awt"

RDEPEND="|| (
		dev-java/graalvm-ce-bin:${SLOT}[gentoo-vm(+)]
		dev-java/openjdk-bin:${SLOT}[gentoo-vm(+),headless-awt=]
		dev-java/openjdk:${SLOT}[gentoo-vm(+),headless-awt=]
)"
