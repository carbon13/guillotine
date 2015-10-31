#!/bin/bash

cd `dirname $0`
cp -rf ~/Dropbox/Guillotine/slice.sh .

git add .
git commit -m "something has changed"
git push origin 
