chown -R root:root .

CC='gcc -std=c99' ./configure --prefix=/usr -G -O3 -r

make
make test
make install
