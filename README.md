wintersmith-pngquant
====================

[pngquant](http://pngquant.org/) plugin for [Wintersmith](https://github.com/jnordberg/wintersmith) 

## Installing

Install using `wintersmith plugin install pngquant`

or install globally/locally using npm

```
npm install [-g] wintersmith-pngquant
```

and add `wintersmith-pngquant` to your config.json

```json
{
  "plugins": [
    "wintersmith-pngquant"
  ]
}
```

## Options

Add a pngquant object to your wintersmith config, defaults shown here, see http://pngquant.org/ for more info.

Speed defaults to 11 (fastest) when previewing and 1 (best quality) when building.

```json
{
  "ncolors": 256,
  "speed": 1/11
  quality: null
  nofs: false
}
```
