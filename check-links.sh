#!/bin/bash

# halt script on error
set -e
# compile MD to HTML and put in _site directory
jekyll build
# validate HTML, but ignore custom_404.html, custom_50x.html, search.html, and missing image alt tags
htmlproofer ./_site --only-4xx --url-ignore "/reference/" --alt-ignore "/.*/" --allow-hash-href "true" --file-ignore "/custom|search/"
