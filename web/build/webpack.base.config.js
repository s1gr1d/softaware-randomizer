var path = require("path");
var HtmlWebpackPlugin = require("html-webpack-plugin");
var CopyWebpackPlugin = require("copy-webpack-plugin");
var FaviconsWebpackPlugin = require("favicons-webpack-plugin");

let sourcePath = path.join(__dirname, "/../src/");
let distPath = path.join(__dirname, "/../dist/");
let graphicsPath = path.join(__dirname, "/../_graphics/");

module.exports = {
  entry: path.join(sourcePath, "index.js"),
  output: {
    path: distPath,
    filename: "bundle.js"
  },
  module: {
    rules: [
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader: "elm-webpack-loader"
      },
      {
        test: /\.css$/,
        use: [{ loader: "style-loader" }, { loader: "css-loader" }]
      }
    ],
    noParse: /\.elm$/
  },
  resolve: {
    extensions: [".js", ".elm"]
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: path.join(sourcePath, "index.ejs"),
      filename: "index.html"
    })
    // new CopyWebpackPlugin([
    //   {
    //     from: path.join(sourcePath, "assets/"),
    //     to: path.join(distPath, "assets/")
    //   }
    // ]),
    // new FaviconsWebpackPlugin(path.join(graphicsPath, "favicon.png"))
  ]
};
