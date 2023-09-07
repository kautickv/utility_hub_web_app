// Config file to create two seperate builds for this react project,
// One for the main web app
// Another one for the chrome extension app
const path = require('path');

module.exports = function override(config, env) {
  // Change the entry point
  config.entry = {
    main: path.join(__dirname, 'src/index.js'),
    extension: path.join(__dirname, 'src/ExtensionApp.js'),
  };

  // Output multiple HTML files (one for each entry)
  const HtmlWebpackPlugin = require('html-webpack-plugin');
  config.plugins = config.plugins.map((plugin) => {
    if (plugin instanceof HtmlWebpackPlugin) {
      return new HtmlWebpackPlugin({
        inject: true,
        chunks: ['main'],
        template: path.join(__dirname, 'public/index.html'),
        filename: 'index.html',
      });
    }
    return plugin;
  });

  config.plugins.push(
    new HtmlWebpackPlugin({
      inject: true,
      chunks: ['extension'],
      template: path.join(__dirname, 'public/extension.html'),
      filename: 'extension.html',
    })
  );

  return config;
};
