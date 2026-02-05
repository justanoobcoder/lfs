./configure --prefix=/usr    \
            --disable-static \
            --enable-libgdbm-compat
make
make check
make install
