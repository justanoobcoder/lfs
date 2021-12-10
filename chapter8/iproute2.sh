sed -i /ARPD/d Makefile
rm -fv man/man8/arpd.8

sed -i 's/.m_ipt.o//' tc/Makefile
make
make SBINDIR=/usr/sbin install

mkdir -v              /usr/share/doc/iproute2-5.13.0
cp -v COPYING README* /usr/share/doc/iproute2-5.13.0
