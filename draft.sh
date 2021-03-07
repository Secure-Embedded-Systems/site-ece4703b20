#!/bin/sh

make SPHINXOPTS='-t draft' html
rsync -avz -e "ssh -oStrictHostKeyChecking=no -oPort=2222" --delete --progress ./build/html/ schaum@schaumont.dyn.wpi.edu:/home/schaum/www/www-ece4703b20draft
