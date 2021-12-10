./configure --prefix=/usr    \
            --disable-static \
            --enable-libgdbm-compat
make
make -k check
make install
