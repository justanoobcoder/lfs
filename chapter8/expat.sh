./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/expat-2.4.1
make
make check
make install
install -v -m644 doc/*.{html,png,css} /usr/share/doc/expat-2.4.1
