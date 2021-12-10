./configure --prefix=/usr        \
            --enable-shared      \
            --with-system-expat  \
            --with-system-ffi    \
            --with-ensurepip=yes \
            --enable-optimizations
make
make install
install -v -dm755 /usr/share/doc/python-3.9.9/html 

tar --strip-components=1  \
    --no-same-owner       \
    --no-same-permissions \
    -C /usr/share/doc/python-3.9.9/html \
    -xvf ../python-3.9.9-docs-html.tar.bz2
