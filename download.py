#!/usr/bin/python3

import csv
import subprocess

failed_packages_file = open('failed_packages.csv', 'w')
failed_packages_file.write('')
failed_patches_file = open('failed_patches.csv', 'w')
failed_patches_file.write('')

csv_writer = csv.writer(failed_packages_file)
with open('packages.csv', 'r') as file:
    reader = csv.reader(file)
    for line in reader:
        name = line[0]
        version = line[1]
        url = line[2]
        md5sum = line[3]
        filename = subprocess.check_output(['basename', url]).decode('UTF-8').strip()
        if subprocess.call('[ -f ' + filename + ' ]', shell=True) == 0:
            continue
        
        print('Downloading ' + name + ' from ' + url +" ...")
        subprocess.call(['wget', '-q', url])
        return_code = subprocess.call('echo "' + md5sum + ' ' + filename +
                '" | md5sum -c > /dev/null', shell=True)
        if return_code != 0:
            subprocess.call('rm -f ' + filename)
            print(name + ': md5sum mismatch!')
            print('Deleted ' + filename)
            csv_writer.writerow([name, version, url, md5sum])
failed_packages_file.close()

csv_writer = csv.writer(failed_patches_file)
with open('patches.csv', 'r') as file:
    reader = csv.reader(file)
    for line in reader:
        name = line[0]
        url = line[1]
        md5sum = line[2]
        filename = subprocess.check_output(['basename', url]).decode('UTF-8').strip()
        if subprocess.call('[ -f ' + filename + ' ]', shell=True) == 0:
            continue
        
        print('Downloading ' + name + ' from ' + url +" ...")
        subprocess.call(['wget', '-q', url])
        return_code = subprocess.call('echo "' + md5sum + ' ' + filename +
                '" | md5sum -c > /dev/null', shell=True)
        if return_code != 0:
            subprocess.call('rm -f ' + filename)
            print(name + ': md5sum mismatch!')
            print('Deleted ' + filename)
            csv_writer.writerow([name, url, md5sum])
failed_patches_file.close()
