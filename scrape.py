import re
import csv
from typing import Tuple
from bs4 import BeautifulSoup
import requests

PACKAGE_URL = (
    "https://www.linuxfromscratch.org/"
    "lfs/view/stable-systemd/chapter03/packages.html"
)
PATCH_URL = (
    "https://www.linuxfromscratch.org/"
    "lfs/view/stable-systemd/chapter03/patches.html"
)

MD5_RE = re.compile(r"\b[0-9a-fA-F]{32}\b")


def get_url_md5sum(content) -> Tuple[str, str]:
    info = content.find_next("dd")
    if not info:
        return "", ""

    dl_p = info.find(lambda tag: tag.name == "p" and "Download:" in tag.get_text())
    download_url = ""
    if dl_p:
        a = dl_p.find("a")
        if a and a.has_attr("href"):
            download_url = a["href"].strip()
        elif a:
            download_url = a.get_text(strip=True)

    md5_p = info.find(lambda tag: tag.name == "p" and "MD5 sum:" in tag.get_text())
    md5sum = ""
    if md5_p:
        code = md5_p.find("code")
        if code:
            md5sum = code.get_text(strip=True)
        else:
            m = MD5_RE.search(md5_p.get_text())
            if m:
                md5sum = m.group(0)

    return download_url, md5sum


def scrape_to_csv(url: str, csv_path: str, row_writer, is_package: bool = True):
    resp = requests.get(url, timeout=15)
    resp.raise_for_status()
    soup = BeautifulSoup(resp.text, "html.parser")

    for entry in soup.find_all("dt"):
        span = entry.find("span")
        if not span:
            continue

        if is_package:
            text = span.get_text(strip=True)
            name = re.split(r"\s*\(", text)[0]
            version = ""
            m = re.search(r"\(([^)]+)\)", text)
            if m:
                version = m.group(1)
            url_field, md5 = get_url_md5sum(entry)
            row_writer([name, version, url_field, md5])
        else:
            text = span.get_text(strip=True)
            name = re.split(r"\s*-\s*", text)[0]
            url_field, md5 = get_url_md5sum(entry)
            row_writer([name, url_field, md5])


def main():
    with open("packages.csv", "w", encoding="utf-8", newline="") as packages_file:
        csv_writer = csv.writer(packages_file)
        csv_writer.writerow(["name", "version", "url", "md5sum"])
        scrape_to_csv(PACKAGE_URL, "packages.csv", csv_writer.writerow, is_package=True)

    with open("patches.csv", "w", encoding="utf-8", newline="") as patches_file:
        csv_writer = csv.writer(patches_file)
        csv_writer.writerow(["name", "url", "md5sum"])
        scrape_to_csv(PATCH_URL, "patches.csv", csv_writer.writerow, is_package=False)


if __name__ == "__main__":
    main()
