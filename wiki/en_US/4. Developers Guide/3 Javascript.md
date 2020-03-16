
# Javascript & Gulp

Download dependencies
```bat
$ npm updated
```

## Gulp
The Gulp script builds project js files from /assets/js directory to public/assets/js/.min.js and
moves dependencies from node_modules directory to public/assets/js/vendor/ where they're just
included as needed by the twig templates

```bat
$ gulp
```
