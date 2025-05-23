# Copyright 2025 Your Name <your.email@example.com>
# Distributed under the terms of the GNU General Public License v2

EAPI=8
ARCH="amd64"
KEYWORDS="~*"
IUSE=""

inherit binpkg-helpers systemd

DESCRIPTION="Windscribe GUI tool for Linux"
HOMEPAGE="https://windscribe.com/guides/linux"
LICENSE="GPL-2"
SLOT="0"
PROVIDE="windscribe"
CONFLICT="windscribe-cli windscribe"

DEPEND=">=sys-libs/glibc-2.28
	c-ares
	dev-libs/freetype:2
	x11-themes/hicolor-icon-theme
	sys-apps/systemd
	sys-libs/glib:2
	sys-libs/zlib
	sys-devel/gcc-libs
	sys-apps/dbus
	media-libs/libglvnd
	x11-libs/fontconfig
	x11-libs/libX11
	x11-libs/libxkbcommon
	x11-libs/libxcb
	net-misc/net-tools
	x11-misc/xcb-util-wm
	x11-libs/xcb-util-image
	x11-libs/xcb-util-keysyms
	x11-libs/xcb-util-renderutil
	sys-apps/sudo
	sys-apps/shadow
	net-firewall/nftables"

BINPKG_URL="https://deploy.totallyacdn.com/desktop-apps/${PV}/windscribe_${PV}_x86_64.pkg.tar.zst"
BINPKG_SHA1="e04d96b77362917c3fa99ca50941698045e6c99c"

# No stripping needed as per AUR options
STRIP_EXCLUDE="*"

src_unpack() {
	unpack "${A}"
}

src_install() {
	mv "${S}/etc" "${D}"
	mv "${S}/opt" "${D}"
	mv "${S}/usr" "${D}"

	# Fix permissions on systemd unit
	chmod -x "${D}/usr/lib/systemd/system/windscribe-helper.service"

	# Install systemd unit
	systemd_dounit "${D}/usr/lib/systemd/system/windscribe-helper.service"
}

pkg_postinst() {
	systemd_reload_units
}

pkg_prerm() {
	systemd_stop_on_remove windscribe-helper.service
	systemd_disable_on_remove windscribe-helper.service
}
