#!/bin/sh

wget -q -nc -O /tmp/eff_large_wordlist.txt https://github.com/lawliet529/dotfiles/raw/main/eff_large_wordlist.txt

echo $(shuf -n1 /tmp/eff_large_wordlist.txt)-$(shuf -n1 /tmp/eff_large_wordlist.txt)-$(shuf -n1 /tmp/eff_large_wordlist.txt)-$(shuf -n1 /tmp/eff_large_wordlist.txt)
