#!/bin/bash
# 本地预览：运行后在浏览器打开 http://localhost:4000/
cd "$(dirname "$0")"
export PATH="$HOME/Sites/.ruby-env/bin:$PATH" LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
bundle exec jekyll serve --livereload "$@"
