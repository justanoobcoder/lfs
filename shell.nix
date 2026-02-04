{pkgs ? import <nixpkgs> {}}:
(pkgs.buildFHSEnv {
  name = "lfs-env";
  targetPkgs = pkgs: (with pkgs; [
    bashInteractive
    binutils
    bison
    coreutils
    diffutils
    findutils
    gawk
    gcc
    glibc
    gnugrep
    gzip
    m4
    gnumake
    patch
    perl
    python3
    gnused
    gnutar
    xz
    texinfo
    file
    e2fsprogs
  ]);
  #runScript = "bash";
  profile = ''
    alias cl=clear
    alias v=nvim

    export LFS="/mnt/lfs"
    export LC_ALL="POSIX"
    export LFS_TGT="x86_64-lfs-linux-gnu"
    export LFS_DISK="/dev/nvme0n1p7"
    export SRC_DIR="$LFS/sources/src_dir"
    export CONFIG_SITE="$LFS/usr/share/config.site"
    export MAKEFLAGS="-j$(nproc)"
    export PATH="$LFS/tools/bin:$PATH"
  '';
}).env
