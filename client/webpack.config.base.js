const webpack = require('webpack')
const path = require('path')

const config = {
  entry: [
    'babel-polyfill',
    './app/app.js',
  ],

  output: {
    path: path.resolve(__dirname, '../app/assets/webpack'),
    filename: 'webpack-bundle.js',
  },

  resolve: {
    alias: {
      app: path.resolve(__dirname, 'app'),
      // Load from a prebuild file, reduce loading time zone information for all years.
      'moment-timezone$': path.resolve(__dirname, 'node_modules/moment-timezone/builds/moment-timezone-with-data-2010-2020.js'),
    },
  },

  module: {
    // Prevent Webpack to load all locales.
    noParse: [/moment.js/],
    loaders: [
      {
        test: /\.js$/,
        loader: 'babel',
        exclude: /node_modules/,
      },
      {
        include: /\.json$/,
        loaders: ["json-loader"],
      },
    ],
  },

  plugins: [
    new webpack.DefinePlugin({
      'process.env': {
        NODE_ENV: JSON.stringify(process.env.NODE_ENV),
      },
    }),
  ],
}

module.exports = config
