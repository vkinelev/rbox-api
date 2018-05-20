const { environment, config } = require('@rails/webpacker');
const MonacoWebpackPlugin = require('monaco-editor-webpack-plugin');

// console.log('Config', environment.loaders );
// environment.loaders.get('css').use.splice(1, 0, {
//   loader: 'style-loader'
// })

// console.log('Config', environment.loaders.get('css') );


environment.plugins.append(
  'MonacoWebpackPlugin',
  new MonacoWebpackPlugin()
);

module.exports = environment
