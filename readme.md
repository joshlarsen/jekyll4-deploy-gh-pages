## Jekyll 4 GitHub Pages Deploy Action

A GitHub Action for building and deploying a Jekyll site into a `gh-pages` branch.

### Prior Work

Thanks to [Bryan Schuetz](https://github.com/BryanSchuetz) for a [working example](https://github.com/BryanSchuetz/jekyll-deploy-gh-pages). This version cleans up a few things and works with Bundler 2.x and Jekyll 4.x.

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
          JEKYLL_DESTINATION: docs
```

The `JEKYLL_DESTINATION` variable is only needed if you are **not** using `_site` as the Jekyll build destination.

