## Jekyll 4 GitHub Pages Deploy Action

A GitHub Action for building and deploying a Jekyll site into a `gh-pages` branch.

### Why?

GitHub Pages supports Jekyll out of the box, but very few plugins are supported. If you are using anything but the most basic Jekyll setup, you're likely going to need another way to get your site into GitHub Pages.

### Prior Work

Thanks to [Bryan Schuetz](https://github.com/BryanSchuetz) for a [working example](https://github.com/BryanSchuetz/jekyll-deploy-gh-pages). This version cleans up a few things, works with Bundler 2.x and Jekyll 4.x, and supports a custom Jekyll build/destination directory.

### Setup

Create a `main.yml` file in `./github/workflows`.

```yaml
name: Jekyll Deploy

on: [push]

jobs:
  build_and_deploy:
    runs-on: ubuntu-latest
    steps:
      - name: GitHub Checkout
        uses: actions/checkout@v1
      - name: Build & Deploy to GitHub Pages
        uses: joshlarsen/jekyll4-deploy-gh-pages@master
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          GITHUB_REPOSITORY: ${{ secrets.GITHUB_REPOSITORY }}
          GITHUB_ACTOR: ${{ secrets.GITHUB_ACTOR }}
```



### Custom Build Directory

If you use a directory other than `_site` as the Jekyll build destination, set it with the `JEKYLL_DESTINATION` variable.

```yaml
name: Jekyll Deploy

on: [push]

jobs:
  build_and_deploy:
    runs-on: ubuntu-latest
    steps:
      - name: GitHub Checkout
        uses: actions/checkout@v1
      - name: Build & Deploy to GitHub Pages
        uses: joshlarsen/jekyll4-deploy-gh-pages@master
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          GITHUB_REPOSITORY: ${{ secrets.GITHUB_REPOSITORY }}
          GITHUB_ACTOR: ${{ secrets.GITHUB_ACTOR }}
          JEKYLL_DESTINATION: docs
```



### Faster Builds with Bundler Caching

You can use the `caching` branch of the GitHub Action to enable Bundler caching and speed up the build/deploy considerably. Note the last build step in `mail.yml` specifies the `caching` branch, not the `master` branch.

```yaml
name: Jekyll Deploy

on: [push]

jobs:
  build_and_deploy:
    runs-on: ubuntu-latest
    steps:
      - name: GitHub Checkout
        uses: actions/checkout@v1
      - name: Bundler Cache
        uses: actions/cache@v1
        with:
          path: vendor/bundle
          key: ${{ runner.os }}-gems-${{ hashFiles('**/Gemfile.lock') }}
          restore-keys: |
            ${{ runner.os }}-gems-
      - name: Build & Deploy to GitHub Pages
        uses: joshlarsen/jekyll4-deploy-gh-pages@caching
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          GITHUB_REPOSITORY: ${{ secrets.GITHUB_REPOSITORY }}
          GITHUB_ACTOR: ${{ secrets.GITHUB_ACTOR }}
```



Enabling caching on a mostly vanilla Jekyll site reduces deploy time from 3-4 minutes down to less than 1 minute. The cached build step is reduced from ~3 minutes to ~12 seconds.

![build without cache](img/build-no-cache.png)

![build with cache](img/build-with-cache.png)



### Security

If you don't trust running third party actions in your repo, you can always clone this one and substitute `joshlarsen/jekyll4-deploy-gh-pages@master` or `joshlarsen/jekyll4-deploy-gh-pages@caching` with your repo name/branch in your workflow `.yml`.



### Details

This Action is very simple, it installs a modern version of Bundler so Jekyll 4.x can be installed. The runner simply builds the Jekyll site and pushes it to the `gh-pages` branch of your repo.

```bash
#!/bin/bash

set -e

DEST="${JEKYLL_DESTINATION:-_site}"
REPO="https://x-access-token:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
BRANCH="gh-pages"

echo "Installing gems..."

bundle

echo "Building Jekyll site..."

jekyll build

echo "Publishing..."

cd ${DEST}

git init
git config user.name "${GITHUB_ACTOR}"
git config user.email "${GITHUB_ACTOR}@users.noreply.github.com"
git add .
git commit -m "published by GitHub Actions"
git push --force ${REPO} master:${BRANCH}
```



### Issues

Feel free to file an issue if you have a bug fix or an improvement.
