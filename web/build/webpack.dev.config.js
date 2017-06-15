var webpackBaseConfig = require("./webpack.base.config");
var merge = require("webpack-merge");

module.exports = merge(webpackBaseConfig, {
  watch: true,
  watchOptions: {
    aggregateTimeout: 300,
    poll: 1000 // needed for Docker-Support (fsevents not propagated correctly)
  },
  devServer: {
    contentBase: "/dist/",
    inline: true,
    host: "0.0.0.0", // needed for Docker-Support (bind to all interfaces)
    port: 8000
  }
});
