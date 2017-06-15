var path = require("path");
var HtmlWebpackPlugin = require("html-webpack-plugin");

let sourcePath = path.join(__dirname, "/../src/");
let distributionPath = path.join(__dirname, "/../dist/");

module.exports = {
  entry: path.join(sourcePath, "index.js"),
  output: {
    path: distributionPath,
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
  ]
};
