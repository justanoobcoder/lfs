CC='gcc -std=c99' ./configure.sh --prefix=/usr -G -O3 -r
make
make test
make install
