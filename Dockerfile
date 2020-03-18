FROM ruby:2.6.5

# install a modern bundler version
RUN gem install bundler

ENV LC_ALL=C.UTF-8 LANG=en_US.UTF-8	LANGUAGE=en_US.UTF-8	

LABEL "com.github.actions.name"="Build & Deploy to GitHub Pages" \
  "com.github.actions.description"="Builds & deploys a Jekyll 4.x site to gh-pages branch of the same repository." \
  "com.github.actions.icon"="globe" \
  "com.github.actions.color"="green" \
  "repository"="http://github.com/joshlarsen/jekyll4-deploy-gh-pages"	

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]