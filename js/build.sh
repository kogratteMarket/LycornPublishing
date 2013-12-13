#!/bin/sh

echo "Compiling coffee code"
coffee --join main.js --compile --output . src/
echo "Generating minified file"
uglifyjs -c -o main.min.js main.js