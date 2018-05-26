module.exports = {
  lintOnSave: false,
  configureWebpack: config => {
    if (process.env.NODE_ENV === 'production') {
      return {
        output: {
          publicPath: '/urban_greenspaces/'
        }
      }
      // mutate config for production...
    } else {
      // mutate for development...
    }
  }
}
