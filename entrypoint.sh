#!/bin/bash

set -e



DEST="${JEKYLL_DESTINATION:-_site}"
REPO="https://x-access-token:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
BRANCH="gh-pages"
BUNDLE_BUILD__SASSC=--disable-march-tune-native

echo "Setting up git..."

mkdir _site
cd ${DEST}
git init
git config user.name "${GITHUB_ACTOR}"
git config user.email "${GITHUB_ACTOR}@users.noreply.github.com"
git remote add origin "${REPO}"
git checkout -b "gh-pages"
git pull origin gh-pages
echo "Git crash?"
git checkout "gh-pages"
git branch --set-upstream-to=origin/gh-pages
echo "Git checkout..."
git checkout gh-pages

cd ..

echo "Installing gems..."

bundle config path vendor/bundle
bundle install --jobs 4 --retry 3

echo "Building Jekyll site..."

if [ ! -z $YARN_ENV ]; then
  echo "Installing javascript packages..."
  yarn
fi

JEKYLL_ENV=production NODE_ENV=production bundle exec jekyll build

echo "Publishing..."

cd ${DEST}
git add .
git commit -m "published by GitHub Actions"
git push ${REPO} master:${BRANCH}
