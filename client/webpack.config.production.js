const webpack = require('webpack')
const config = require('./webpack.config.base')

config.plugins.push(
  new webpack.optimize.DedupePlugin()
)

module.exports = config
