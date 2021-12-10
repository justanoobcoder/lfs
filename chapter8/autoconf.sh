./configure --prefix=/usr
make
make check TESTSUITEFLAGS=-j4
make install
