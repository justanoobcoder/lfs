./configure --prefix=/usr \
            --docdir=/usr/share/doc/flex-2.6.4 \
            --disable-static
make
make check
make install
rm -f /usr/bin/lex
ln -sv flex   /usr/bin/lex
rm -f /usr/share/man/man1/lex.1
ln -sv flex.1 /usr/share/man/man1/lex.1
