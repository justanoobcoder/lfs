# My Linux From Scratch scripts

This is my scripts for building a LFS system.
DO NOT USE THEM IF YOU HAVE NO IDEA WHAT THEY DO!!!

## Download LFS's packages and patches

I use python scripts to download packages and patches. To use these scripts:

    python -m venv venv
    source ./venv/bin/activate
    pip install -r requirements.txt
    python scrape.py
    python download.py
    deactivate

## Result
### LFS
[![LFS Demo video](https://img.youtube.com/vi/YvsK_jcLrqA/0.jpg)](https://www.youtube.com/watch?v=YvsK_jcLrqA)

### BLFS
[![LFS Demo video](https://img.youtube.com/vi/C-InYjWA0rg/0.jpg)](https://www.youtube.com/watch?v=C-InYjWA0rg)
