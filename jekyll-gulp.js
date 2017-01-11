var gulp         = require('gulp');
var gutil        = require('gulp-util');
var exec         = require('child_process').exec;
var cleanCSS     = require('gulp-clean-css');
var uglify       = require('gulp-uglify');
var imagemin     = require('gulp-imagemin');
var pngquant     = require('imagemin-pngquant');
var cheerio      = require('gulp-cheerio');
var runSequence  = require('run-sequence');
var messages     = {
    jekyllBuild: '<span style="color: orange">Running:</span> $ jekyll build',
    jekyllServe: '<span style="color:orange">Serving:</span> $ jekyll serve'
};

/**
 * Build the Jekyll Site. Executes the built-in "jekyll build" shell command with the "JEKYLL_ENV=production" parameter set to ensure that the google analytics tracking code is inserted in all pages.
 */
 gulp.task('make', function (cb) {
   exec('JEKYLL_ENV=production jekyll build', function (err, stdout, stderr) {
     console.log(stdout);
     console.log(stderr);
     cb(err);
   });
 });

 /**
 * minifiy css
 */
 gulp.task('minify-css', function() {
    return gulp.src('css/*.css')
        .pipe(cleanCSS({debug: true, processImport: false}, function(details) {
            console.log(details.name + ': ' + details.stats.originalSize);
            console.log(details.name + ': ' + details.stats.minifiedSize);
        }))
        .pipe(gulp.dest('_site/css'));
});

/**
* minifiy js
*/
gulp.task('minify-js', function() {
  gulp.src('js/*.js')
    .pipe(uglify())
    .pipe(gulp.dest('_site/js'))
});

/**
 * Copy and minimize image files; not currently in use
*/
gulp.task('optimize:images', function() {
  return gulp.src('images/*.png')
    .pipe(imagemin({optimizationLevel: 3, progressive: true, interlaced: true}))
    .pipe(gulp.dest('_site/images'))
    .pipe(size());
});

/* Insert Google Analytics tracking code in index.html on production builds because Jekyll sucks sometimes * and I can't use the logic for conditional builds that I'm using in _includes/head.html
*/
gulp.task('insert-analytics', function () {
  return gulp
  .src(['_site/index.html'])
  .pipe(cheerio({
    run: function ($, file) {
      $('head').append('<script src="js/analytics.js"><\/script>');
    }
  }))
  .pipe(gulp.dest('_site/'));
});
/**
* Start a local server for the site at localhost:4000. Simply executes built-in "jekyll serve" shell command. Auto-regeneration enabled by default. No need for a separate gulp task to watch files.
*/
gulp.task('serve', function (cb) {
  exec('jekyll serve', function (err, stdout, stderr) {
    console.log(stdout);
    console.log(stderr);
    cb(err);
  });
});

// validate HTML, but ignore custom_404.html, custom_50x.html, search.html, and missing image alt tags. also ignores _site/reference b/c API links aren't generated during build; they're generated dynamically by tocify.js when opening page in browser. if we don't ignore this, we get loads of non-error errors
gulp.task('htmlproofer', function (cb) {
  exec('htmlproofer ./_site --only-4xx --url-ignore "/reference/" --alt-ignore "/.*/" --allow-hash-href "true" --file-ignore "/custom|search/"',
  function (err, stdout, stderr) {
    gutil.log(gutil.colors.cyan(stdout));
    gutil.log(gutil.colors.red(stderr));
    cb(err);
  });
});

//Build, serve, and watch files for changes.  Used for development.
gulp.task('default', ['make', 'minify-css', 'minify-js', 'serve']);

//Build but don't serve or watch files for changes. Required for Jenkins build. Runs tasks sequentially because 'insert-analytics' won't work unless it runs AFTER 'make'. The release of Gulp v4 will probably break this, but it's a great workaround for now to insert the google analytics tracking code in the index.html file for production builds
gulp.task('build', function() {
  runSequence('make', 'insert-analytics', 'minify-css', 'minify-js', 'htmlproofer');
});
