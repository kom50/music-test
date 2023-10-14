#!/usr/bin/env sh

# abort on errors
set -e

# Install depedencies
npm i

# build
npm run build

# navigate into the build output directory
cd dist

# if you are deploying to a custom domain
# echo 'www.example.com' > CNAME
echo 'Deploying'

git init
git checkout -b main
git add -A
git commit -m 'deploy' 

git push -f origin main:gh-pages

echo 'Done'

cd -    