const gulp         = require('gulp');
const autoprefixer = require('gulp-autoprefixer');
const babel        = require('gulp-babel');
//const cleanCSS     = require('gulp-clean-css');
const concat       = require('gulp-concat');
const rename       = require('gulp-rename');
//const sass         = require('gulp-sass');
const sourcemaps   = require('gulp-sourcemaps');
const uglify       = require('gulp-uglify');
const pump         = require('pump');



//let sassFiles = 'assets/scss/*.scss';
let jsFiles   = './assets/js/*.js';
let dest      = 'public/assets/';

gulp.task('javascript', function () {
    return gulp.src(jsFiles)
        .pipe(sourcemaps.init())
        .pipe(babel({
            presets: ['env']
        }))
        .pipe(sourcemaps.write('.'))
        .pipe(gulp.dest(dest + 'js/'));
});

gulp.task('minify-js', function (cb) {
    pump([
        gulp.src(dest + 'js/*.js'),
        uglify(),
        rename({ suffix: '.min' }),
        gulp.dest(dest + 'js/')
    ], cb);
});

//hack export dependencies from node_modules to assets/js/vendor
gulp.task('depend', function() {
  gulp.src([
      './node_modules/popper.js/dist/umd/popper.min.js',
      './node_modules/jquery/dist/jquery.min.js',
      './node_modules/jquery.easing/jquery.easing.min.js',
      './node_modules/bootstrap-select/dist/js/bootstrap-select.min.js',
      './node_modules/interact/dist/interact.min.js',
      './node_modules/dropzone/dist/min/dropzone.min.js',
      './node_modules/codemirror/lib/codemirror.js',
      './node_modules/codemirror/mode/xml/xml.js',
      './node_modules/codemirror/mode/php/php.js',
      './node_modules/codemirror/mode/twig/twig.js',
      './node_modules/codemirror/mode/htmlmixed/htmlmixed.js',
      './node_modules/codemirror/mode/javascript/javascript.js',
      './node_modules/codemirror/mode/css/css.js',
      './node_modules/codemirror/mode/clike/clike.js',
      './node_modules/js-cookie/src/js.cookie.js',
      './node_modules/bootstrap-cron-picker/dist/cron-picker.js'])
      .pipe(gulp.dest(dest + 'js/vendor/'));

  gulp.src([
      './node_modules/@fortawesome/fontawesome-free/css/all.min.css',
      './node_modules/bootstrap-select/dist/css/bootstrap-select.min.css',
      './node_modules/codemirror/lib/codemirror.css',
      './node_modules/dropzone/dist/min/dropzone.min.css',
      './node_modules/bootstrap-cron-picker/dist/cron-picker.css'])
      .pipe(gulp.dest(dest + 'css/vendor/'));
  gulp.src('./node_modules/@fortawesome/fontawesome-free/webfonts').pipe(gulp.dest(dest+'css/'));
});

gulp.task('minify', ['minify-js']);

gulp.task('build', ['javascript', 'depend']);

gulp.task('prod', ['build', 'minify']);

gulp.task('watch', function () {
    //  gulp.watch(sassFiles, ['sass']);
    gulp.watch(jsFiles, ['javascript']);
});

gulp.task('default', ['build', 'watch']);
