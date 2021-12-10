sed -i '/install -m.*STA/d' libcap/Makefile

make prefix=/usr lib=lib
make test
make prefix=/usr lib=lib install
chmod -v 755 /usr/lib/lib{cap,psx}.so.2.53
