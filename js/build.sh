coffee --join main.js --compile --output . src/
uglifyjs -o main.min.js main.js vendor/*.js