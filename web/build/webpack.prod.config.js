var webpackBaseConfig = require("./webpack.base.config");
var merge = require("webpack-merge");

// modify the HtmlWebpackPlugin to minify the HTML for production-build
// TODO: find a better way to merge plugins, index-based merging is meant to fail
// http://stackoverflow.com/questions/40089394/how-do-i-split-a-webpack-config-to-override-commonchunksplugin
webpackBaseConfig.plugins[0].options.minify = {
  collapseWhitespace: true,
  collapseInlineTagWhitespace: true,
  removeAttributeQuotes: true,
  removeComments: true,
  removeEmptyAttributes: true,
  removeEmptyElements: false,
  removeOptionalTags: true,
  removeRedundantAttributes: true,
  useShortDoctype: true
};

module.exports = merge(webpackBaseConfig, {});
