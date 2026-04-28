# LFS - Linux From Scratch Package Downloader

LFS is a simple CLI tool designed to automate the process of fetching, downloading, and verifying packages and patches required for building Linux From Scratch.

## Features

- **Fetch Manifests**: Download the `wget-list` and `md5sums` files directly from the LFS website.
- **Parallel Downloads**: Download all required packages and patches with configurable parallel jobs.
- **MD5 Verification**: Verify the integrity of downloaded files against official MD5 sums.
- **Error Logging**: Failed downloads and verification errors are logged to separate files for easy troubleshooting.

## Usage

The tool follows a simple three-step workflow: **Fetch** → **Download** → **Verify**.

### 1. Fetch Manifests

First, download the list of packages (`wget-list`) and their expected hashes (`md5sums`).

```bash
# Download both files
./lfs fetch -w -m

# Force override existing files
./lfs fetch -w -m -f
```

### 2. Download Packages

Once you have the `wget-list`, you can start downloading all the packages.

```bash
# Download using default settings (5 parallel jobs)
./lfs download

# Download using 10 parallel jobs
./lfs download -j 10

# Overwrite existing files
./lfs download -f
```

### 3. Verify Integrity

Finally, verify that the downloaded files match the official MD5 hashes.

```bash
./lfs verify
```

## Configuration

The tool is configured via `config.json` in the root directory.

```json
{
  "wget-list-link": "https://www.linuxfromscratch.org/lfs/view/systemd/wget-list-systemd",
  "md5sums-link": "https://www.linuxfromscratch.org/lfs/view/systemd/md5sums",
  "wget-list-file": "wget-list",
  "md5sums-file": "md5sums",
  "failed-packages-log": "failed-packages.log",
  "failed-verify-log": "failed-verify.log"
}
```

- `wget-list-link`: URL to the `wget-list` file for your LFS version.
- `md5sums-link`: URL to the `md5sums` file.
- `wget-list-file`: Local filename for the package list.
- `md5sums-file`: Local filename for the MD5 sums.
- `failed-packages-log`: File where failed download URLs are logged.
- `failed-verify-log`: File where verification failures are logged.

## License

[MIT](LICENSE)
