#!/bin/bash

set -e

rev=$(git rev-parse --short HEAD)

git config --global user.email "me@davy.tw"
git config --global user.name "Travis on behalf David Kuo"

git submodule init
git submodule add -b gh-pages -f --name build "https://$GH_TOKEN@github.com/crystal-tw/docs.git" build
gitbook build --gitbook=2.3.2
cp -r _book/* build/
echo "$(git rev-parse HEAD)" > build/.rev
cd build; git add -fA .; git commit -m "Build docs at ${rev} [ci skip]"; git push -q || true
