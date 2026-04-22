# VeraCrypt compiler from the official GitHub source (For Ubuntu 24.04 LTS Noble Numbat)
## Requirements
1. docker
## Compile
Run `docker build . --no-cache -t veracrypt-compiler`
## How to get the binary and the deb package
1. Run `docker run -t -v ~/veracrypt-output:/data veracrypt-compiler cp -a "/opt/." /data/`
1. The deb package and binary will be exported to veracrypt-output directory of your home directory
## Installation
1. Run `apt install -f ~/veracrypt-output/veracrypt.deb`