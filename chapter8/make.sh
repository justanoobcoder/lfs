./configure --prefix=/usr
make
chown -R tester .
su tester -c "PATH=$PATH make check"
make install
