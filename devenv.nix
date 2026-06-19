{
  pkgs,
  ...
}:

{
  packages = with pkgs; [
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
    gum
  ];

  env = {
    LFS = "/mnt/lfs";
    LC_ALL = "C";
    LFS_TGT = "x86_64-lfs-linux-gnu";
    LFS_DISK = "/dev/nvme0n1p8";
    SRC_DIR = "/mnt/lfs/sources/src_dir";
    CONFIG_SITE = "/mnt/lfs/usr/share/config.site";
  };

  enterShell = ''
    cl() { clear; }
    v() { nvim "$@"; }
    export MAKEFLAGS="-j$(nproc)"
    export PATH="$LFS/tools/bin:$PATH"
  '';
}
