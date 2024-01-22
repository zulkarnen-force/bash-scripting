#/bin/bash
VERSION="1.1.0"
version="1.2.0"
short_version=$(echo $version | cut -d. -f1,2)
echo $short_version