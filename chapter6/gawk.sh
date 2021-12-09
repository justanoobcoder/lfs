sed -i 's/extras//' Makefile.in

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(./config.guess) \
&& make \
&& make DESTDIR=$LFS install
