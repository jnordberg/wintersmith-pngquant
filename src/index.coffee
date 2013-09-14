fs = require 'fs'
PngQuant = require './pngquant'

bytesToSize = (bytes) ->
  sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB']
  i = ~~(Math.floor(Math.log(bytes) / Math.log(1024)))
  return "#{ bytes } #{ sizes[i] }" if i is 0
  return "#{ (bytes / Math.pow(1024, i)).toFixed(1) } #{ sizes[i] }"

module.exports = (env, callback) ->

  defaults =
    ncolors: 256
    speed: if env.mode is 'build' then 1 else 11
    quality: null #'65-80'
    nofs: false

  options = env.config.pngquant or {}
  options[key] ?= defaults[key] for key of defaults

  pqopts = ["-s#{ options.speed }"]
  pqopts.push "--quality=#{ options.quality }" if options.quality?
  pqopts.push "--nofs" if options.nofs
  pqopts.push options.ncolors

  class PngFile extends env.ContentPlugin

    constructor: (@filepath) ->

    getFilename: -> @filepath.relative

    getView: -> (env, locals, contents, templates, callback) ->
      image = fs.createReadStream @filepath.full
      pngq = new PngQuant pqopts
      pngq.on 'end', =>
        original = pngq.pngQuantProcess.stdin.bytesWritten
        optimized = pngq.pngQuantProcess.stdout.bytesRead
        env.logger.info "pngq: #{ @filepath.relative } #{ bytesToSize original } -> #{ bytesToSize optimized }"
      image.pipe pngq
      callback null, pngq

  PngFile.fromFile = (filepath, callback) ->
    callback null, new PngFile filepath

  env.registerContentPlugin 'images', '**/*.png', PngFile
  callback()
