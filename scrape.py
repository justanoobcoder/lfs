#!/usr/bin/python3

from bs4 import BeautifulSoup
import requests
import re
import csv

packages_html = requests.get('https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter03/packages.html').text
patches_html = requests.get('https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter03/patches.html').text
packages_file = open('packages.csv', 'w')
patches_file = open('patches.csv', 'w')

soup = BeautifulSoup(packages_html, 'lxml')
csv_writer = csv.writer(packages_file)
for package in soup.find_all('dt'):
    name_and_version = package.span.text
    name = re.search('.*(?=\()', name_and_version).group(0).strip().lower()
    version = re.search('(?<=\().*(?=\))', name_and_version).group(0).strip()
    info = package.find_next('dd')
    url = info.find(lambda tag: tag.name == 'p' and 'Download:' in tag.text).a.text.strip()
    md5sum = info.find(lambda tag: tag.name == 'p' and 'MD5 sum:' in tag.text).code.text.strip()
    print(name)
    print(version)
    print(url)
    print(md5sum)
    csv_writer.writerow([name, version, url, md5sum])
packages_file.close()

soup = BeautifulSoup(patches_html, 'lxml')
csv_writer = csv.writer(patches_file)
for patch in soup.find_all('dt'):
    name = re.search('.*(?= -)', patch.span.text).group(0).strip()
    info = patch.find_next('dd')
    url = info.find(lambda tag: tag.name == 'p' and 'Download:' in tag.text).a.text.strip()
    md5sum = info.find(lambda tag: tag.name == 'p' and 'MD5 sum:' in tag.text).code.text.strip()
    print(name)
    print(url)
    print(md5sum)
    csv_writer.writerow([name, url, md5sum])
patches_file.close()
