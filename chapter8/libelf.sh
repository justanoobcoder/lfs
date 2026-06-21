./configure --prefix=/usr        \
            --disable-debuginfod \
            --enable-libdebuginfod=dummy

make -C lib
make -C libelf

make -C libelf install
install -vm644 config/libelf.pc /usr/lib/pkgconfig
rm /usr/lib/libelf.a
