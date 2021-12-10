./configure --prefix=/usr --localstatedir=/var/lib/locate
make
chown -Rv tester .
su tester -c "PATH=$PATH make check"
make install
