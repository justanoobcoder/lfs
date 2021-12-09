CHAPTER="$1"
PACKAGE="$2"

if [ "$PACKAGE" == "linux-api-headers" ]; then
    REAL_PACKAGE="linux"
elif [ "$PACKAGE" == "libstdc++" ]; then
    REAL_PACKAGE="gcc"
elif [ "$PACKAGE" == "libelf" ]; then
    REAL_PACKAGE="elfutils"
else
    REAL_PACKAGE="$PACKAGE"
fi

line="`cat packages.csv | grep -i "^$REAL_PACKAGE,"`"
VERSION="`echo $line | cut -d\, -f2`"
URL="`echo $line | cut -d\, -f3`"
FILE_NAME="`basename $URL`"
SCRIPT_NAME="`echo $PACKAGE | sed 's/\s/-/g'`"

if [ $(ls -1A $SRC_DIR | wc -l) -ne 0 ]; then
    rm -rf $SRC_DIR/{..?*,.[!.]*,*}
fi

echo "Extracting $FILE_NAME"
tar xf $FILE_NAME -C $SRC_DIR
pushd $SRC_DIR
    if [ $(ls -1A | wc -l) -eq 1 ]; then
        find $(ls -1A)/ -mindepth 1 -maxdepth 1 -exec mv -t ./ -- {} +
    fi
    echo "Compiling $PACKAGE"
    sleep 5
    mkdir -pv ../log/chapter$CHAPTER
    if ! source ../chapter$CHAPTER/$SCRIPT_NAME.sh 2>&1 | tee ../log/chapter$CHAPTER/$SCRIPT_NAME.log; then
        popd
        error "Compiling $PACKAGE failed"
    fi
    echo "Done compiling $PACKAGE"
popd

rm -rf $SRC_DIR/{..?*,.[!.]*,*}
