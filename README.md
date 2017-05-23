# Overview
This page lists each script in this repo and a short description of what it does. The scripts contain comments that document what the code is doing.

## Scripts

-   **aws-s3-deploy.sh**: A bash script that reads user input to download and extract a tarball from one of several AWS S3 buckets.
-   **check-links.sh**: A bash script that builds a Jekyll based static site and validates the HTML (e.g., links, well-formed HTML).
-   **deploy.sh**: A bash script that downloads a tarball from a URL via a curl command and extracts to a web server.''
-   **jekyll-gulp.js**: A typical Gulp file used to build a Jekyll static site. Includes HTML validation and minification.
-   **jekyll-rakefile.rb**: A typical Ruby makefile used to build a Jekyll static site. Includes HTML validation and minification.
-   **open-mobile-nav.js**: Custom JS that uses jQuery to show the TOC for API reference topics after clicking the mobile-nav hamburger menu.
-   **prevent-default.js**: Custom JS that uses jQuery to prevent a page from refreshing when clicking on an active TOC link.
-   **scrollspy.js**: Custom JS that uses jQuery to ensures h2 elements are formatted correctly so that the MaterializeCSS framework can display headings on a page and produce a scrollspy effect depending on scroll position.
