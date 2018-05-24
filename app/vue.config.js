module.exports = {
  lintOnSave: false,
  configureWebpack: {
    module: {
      rules: [
        {
          test: /\.geojson$/,
          use: ['file-loader']
        }
      ]
    }
  }
}
