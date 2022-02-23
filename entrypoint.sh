#!/bin/bash

set -e

DEST="${JEKYLL_DESTINATION:-_site}"
SOURCE_BRANCH="${JEKYLL_SOURCE_BRANCH:-main}"
REPO="https://x-access-token:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
BRANCH="gh-pages"
BUNDLE_BUILD__SASSC=--disable-march-tune-native

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

git init
git config --global init.defaultBranch "${SOURCE_BRANCH}"
git config user.name "${GITHUB_ACTOR}"
git config user.email "${GITHUB_ACTOR}@users.noreply.github.com"
git add .
git commit -m "published by GitHub Actions"
git push --force ${REPO} ${SOURCE_BRANCH}:${BRANCH}
