const nodeExternals = require('webpack-node-externals')
const config = require('./webpack.config.base')

config.target = 'node'
config.externals = [nodeExternals()]
config.devtool = 'inline-source-map'
delete config.output
config.output = {
  devtoolModuleFilenameTemplate: '[absolute-resource-path]',
  devtoolFallbackModuleFilenameTemplate: '[absolute-resource-path]?[hash]',
}

module.exports = config
