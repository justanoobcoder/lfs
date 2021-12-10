./configure --prefix=/usr --disable-static
make
make check
make docdir=/usr/share/doc/check-0.15.2 install
