mkdir build
cd    build

meson setup --prefix=/usr --buildtype=release --wrap-mode=nofallback ..

ninja
ninja test
ninja install
ln -sfv /etc/machine-id /var/lib/dbus
