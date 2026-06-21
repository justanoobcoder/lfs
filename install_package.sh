#!/usr/bin/env bash

set -eou pipefail

CHAPTER="$1"
PACKAGE="$2"

TRACK_DIR="./track"
mkdir -pv "$TRACK_DIR"

status_file="${TRACK_DIR}/chapter${CHAPTER}-${PACKAGE// /-}.done"
if [ -f "$status_file" ]; then
    info "Skipping $PACKAGE (Chapter $CHAPTER) - Already installed."
    return 0
fi

case "$PACKAGE" in
"linux-api-headers") REAL_PACKAGE="linux" ;;
"libstdc++") REAL_PACKAGE="gcc" ;;
"libelf") REAL_PACKAGE="elfutils" ;;
"flit_core") REAL_PACKAGE="flit-core" ;;
*) REAL_PACKAGE="$PACKAGE" ;;
esac

line=$(grep -i "^$REAL_PACKAGE," packages.csv || true)
if [[ -z "$line" ]]; then
    error "Package $REAL_PACKAGE not found."
fi

IFS=',' read -r _ VERSION URL _ <<<"$line"
FILE_NAME=$(basename "$URL")
SCRIPT_NAME="${PACKAGE// /-}"

mkdir -p "$SRC_DIR"
rm -rf "${SRC_DIR:?}"/*

info "Compiling $PACKAGE ($VERSION)"
tar xf "$FILE_NAME" -C "$SRC_DIR" --strip-components=1 2>/dev/null ||
    (tar xf "$FILE_NAME" -C "$SRC_DIR" && cd "$SRC_DIR" && [ "$(ls -1A | wc -l)" -eq "1" ] && mv "$(ls -1A)"/* ./)

pushd "$SRC_DIR" >/dev/null
sleep 5

LOG_DIR="../log/chapter$CHAPTER"
mkdir -pv "$LOG_DIR"

if ! source "../chapter$CHAPTER/$SCRIPT_NAME.sh" 2>&1 | tee "$LOG_DIR/$SCRIPT_NAME.log"; then
    popd >/dev/null
    error "Compiling $PACKAGE failed"
fi

success "Done compiling $PACKAGE"
popd >/dev/null
touch "$status_file"

rm -rf "${SRC_DIR:?}"/*
