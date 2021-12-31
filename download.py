#!/usr/bin/python3

'''
* This script is for downloading, checking packages and patches of LFS.
All failed packages, patches (mismatch md5sum) will be saved in
failed_packages.csv and failed_patches.csv

* Tested on Python3.9.9

* Requirement:
    - packages.csv and patches.csv from scrape.py script
'''

import csv
import subprocess


def download_file(name: str, url: str) -> tuple:
    file_name = subprocess.check_output(
        f'basename {url}', shell=True).decode().strip()
    if subprocess.call(f'[ -f {file_name}  ]', shell=True) == 0:
        return False, file_name
    print(f'Downloading {name} from {url} ...')
    subprocess.call(f'wget -q {url}', shell=True)
    return True, file_name


def check_file(file_name: str, name: str, md5sum: str) -> bool:
    cmd_exit_code = subprocess.call(
        f'echo "{md5sum} {file_name}"| md5sum -c > /dev/null', shell=True)
    if cmd_exit_code != 0:
        subprocess.call(f'rm -f {file_name}', shell=True)
        print(name + ': md5sum mismatch!')
        print(f'Deleted {file_name}')
        return False
    return True


with open('failed_packages.csv', 'w', encoding='utf-8') as failed_packages_file:
    failed_packages_file.write('')
    csv_writer = csv.writer(failed_packages_file)
    with open('packages.csv', 'r', encoding='utf-8') as file:
        reader = csv.reader(file)
        for line in reader:
            pkg_name = line[0]
            pkg_version = line[1]
            pkg_url = line[2]
            pkg_md5sum = line[3]
            is_successful, pkg_file_name = download_file(pkg_name, pkg_url)
            if is_successful:
                if not check_file(pkg_file_name, pkg_name, pkg_md5sum):
                    csv_writer.writerow([pkg_name, pkg_version, pkg_url, pkg_md5sum])

with open('failed_patches.csv', 'w', encoding='utf-8') as failed_patches_file:
    failed_patches_file.write('')
    csv_writer = csv.writer(failed_patches_file)
    with open('patches.csv', 'r', encoding='utf-8') as file:
        reader = csv.reader(file)
        for line in reader:
            pkg_name = line[0]
            pkg_url = line[1]
            pkg_md5sum = line[2]
            is_successful, pkg_file_name = download_file(pkg_name, pkg_url)
            if is_successful:
                if not check_file(pkg_file_name, pkg_name, pkg_md5sum):
                    csv_writer.writerow([pkg_name, pkg_url, pkg_md5sum])
