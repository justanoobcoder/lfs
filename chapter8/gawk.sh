sed -i 's/extras//' Makefile.in

./configure --prefix=/usr
make
make check
make install
mkdir -v /usr/share/doc/gawk-5.1.0
cp    -v doc/{awkforai.txt,*.{eps,pdf,jpg}} /usr/share/doc/gawk-5.1.0
