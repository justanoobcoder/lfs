./configure --prefix=/usr
make
make check
make install
rm -fv /usr/lib/libz.a
