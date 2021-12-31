#!/usr/bin/python3

'''
* This script is for scraping information of LFS basic packages and patches
like name, version, url, md5sum. All information is saved in packages.csv and
patches.csv

* Tested on Python3.9.9

* Requirement:
    - BeautifulSoup4
    - lxml
'''

import re
import csv
from bs4 import BeautifulSoup
import requests


PACKAGE_URL = 'https://www.linuxfromscratch.org/' + \
    'lfs/view/stable-systemd/chapter03/packages.html'
PATCH_URL = 'https://www.linuxfromscratch.org/' + \
    'lfs/view/stable-systemd/chapter03/patches.html'

def get_url_md5sum(content) -> tuple:
    info = content.find_next('dd')
    url = info.find(
        lambda tag: tag.name == 'p' and 'Download:' in tag.text
        ).a.text.strip()
    md5sum = info.find(
        lambda tag: tag.name == 'p' and 'MD5 sum:' in tag.text
        ).code.text.strip()
    return url, md5sum

packages_html = requests.get(PACKAGE_URL).text
with open('packages.csv', 'w', encoding='utf-8') as packages_file:
    soup = BeautifulSoup(packages_html, 'lxml')
    csv_writer = csv.writer(packages_file)
    for package in soup.find_all('dt'):
        pkg_name = re.split(r'\s*\(', package.span.text)[0]
        pkg_version = re.split(r'[()]', package.span.text)[1]
        pkg_url, pkg_md5sum = get_url_md5sum(package)
        csv_writer.writerow([pkg_name, pkg_version, pkg_url, pkg_md5sum])

patches_html = requests.get(PATCH_URL).text
with open('patches.csv', 'w', encoding='utf-8') as patches_file:
    soup = BeautifulSoup(patches_html, 'lxml')
    csv_writer = csv.writer(patches_file)
    for patch in soup.find_all('dt'):
        pat_name = re.split(r'\s*-\s*', patch.span.text)[0]
        pat_url, pat_md5sum = get_url_md5sum(patch)
        csv_writer.writerow([pat_name, pat_url, pat_md5sum])
