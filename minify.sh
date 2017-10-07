#!/bin/bash

# Save The List Of Changed Files
git log --name-only --pretty=format:"" -n 1 | cut -f1 -d"/" --complement > ./diff

# Html Minifier
html-minifier -c html-minifier.conf --input-dir ./source --output-dir ./mehranbaghi.com --file-ext html

# Html Validator
find ./source -type f -name "*.html" -exec html-validator --file="{}" --verbose \;

# Css Lint
stylelint "./source/css/main.css" --config stylelint.json

# CssNano Minifier
mkdir -p ./mehranbaghi.com/css
postcss ./source/css/main.css > ./mehranbaghi.com/css/main.css

# Updating The gh-pages
git checkout gh-pages

while IFS= read -r line
do
    rm $line
    cp ./mehranbaghi.com/$line ./$line
done <"./diff"

rm -rf ./mehranbaghi.com
rm ./diff

sync
