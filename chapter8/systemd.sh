patch -Np1 -i ../systemd-249-upstream_fixes-1.patch

sed -i -e 's/GROUP="render"/GROUP="video"/' \
        -e 's/GROUP="sgx", //' rules.d/50-udev-default.rules.in

mkdir -p build
cd       build

LANG=en_US.UTF-8                    \
meson --prefix=/usr                 \
      --sysconfdir=/etc             \
      --localstatedir=/var          \
      --buildtype=release           \
      -Dblkid=true                  \
      -Ddefault-dnssec=no           \
      -Dfirstboot=false             \
      -Dinstall-tests=false         \
      -Dldconfig=false              \
      -Dsysusers=false              \
      -Db_lto=false                 \
      -Drpmmacrosdir=no             \
      -Dhomed=false                 \
      -Duserdb=false                \
      -Dman=false                   \
      -Dmode=release                \
      -Ddocdir=/usr/share/doc/systemd-249 \
      ..
LANG=en_US.UTF-8 ninja
LANG=en_US.UTF-8 ninja install
tar -xf ../../systemd-man-pages-249.tar.xz --strip-components=1 -C /usr/share/man
rm -rf /usr/lib/pam.d
systemd-machine-id-setup
systemctl preset-all
systemctl disable systemd-time-wait-sync.service
