const config = require('./webpack.config.base')

config.devtool = 'eval-cheap-module-source-map'
// Add ESLint in development
config.module.preLoaders = [
  {
    test: /\.js$/,
    loader: 'eslint',
    exclude: /node_modules/,
  }
]

module.exports = config
