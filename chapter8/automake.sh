./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.18.1
make
make -j$(($(nproc)>4?$(nproc):4)) check
make install
