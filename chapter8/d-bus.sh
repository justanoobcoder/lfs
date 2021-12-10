./configure --prefix=/usr                        \
            --sysconfdir=/etc                    \
            --localstatedir=/var                 \
            --disable-static                     \
            --disable-doxygen-docs               \
            --disable-xml-docs                   \
            --docdir=/usr/share/doc/dbus-1.12.20 \
            --with-console-auth-dir=/run/console \
            --with-system-pid-file=/run/dbus/pid \
            --with-system-socket=/run/dbus/system_bus_socket
make
make install
ln -sfv /etc/machine-id /var/lib/dbus
