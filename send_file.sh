#!/bin/bash

echo RELOADAGENT | gpg-connect-agent &>/dev/null

passlength=40
string="$(tr -dc [:graph:] </dev/urandom | head -c $passlength)"
# qrencode -s 10 -l H -o qr.png "$string"
echo $string >> "KEY_$1.txt"

if [[ -d $1 ]]; then
	echo "+ Compressing $(tput setaf 1)$1 $(tput sgr0)directory..."
	tar -zcvpf $1.tar.gz $1 && \
		echo -e "+ Done compression\n+ Starting Encryption on $(tput setaf 1)$1.tar.gz$(tput sgr0)..." && \
	echo $string | gpg --batch --yes --passphrase-fd 0 --symmetric --cipher-algo AES256 -o "$1.tar.gz.gpg" "$1.tar.gz" && \
	echo "+ Done Encryption" && \
	rm -rf $1.tar.gz
	else
		echo "+ Starting encryption on $(tput setaf 1)$1$(tput sgr0)" && \
		echo $string | gpg --batch --yes --passphrase-fd 0 --symmetric --cipher-algo AES256 -o "$1.gpg" "$1" && \
		echo "+ Done Encryption"
fi

# convert qr.png -gravity center -scale 200% -extent 125% -scale 125% -gravity south -pointsize 30 -fill black -draw "text 0,12 '$string'" "KEY_$1.png"
#  rm -rf qr.png
