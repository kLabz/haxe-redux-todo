//
// Webpack documentation is fairly extensive,
// just search on https://webpack.js.org/
//
// Be careful: there are a lot of outdated examples/samples,
// so always check the official documentation!
//
//

const path = require('path');

// Plugins
const webpack = require('webpack');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');

// Options
const buildMode = process.env.NODE_ENV || 'development';
const sourcemapsMode = buildMode !== 'production' ? 'eval-source-map' : undefined;
const dist = buildMode === 'production' ? `${__dirname}/.build/prod/` : `${__dirname}/.build/`;

//
// Configuration:
// This configuration is still relatively minimalistic;
// each section has many more options
//
module.exports = {
	// List all the JS modules to create
	// They will all be linked in the HTML page
	entry: {
		app: './build.hxml'
	},
	// Generation options (destination, naming pattern,...)
	output: {
		path: dist,
		publicPath: '/',
		filename: '[name].js'
		// filename: '[name].[chunkhash:7].js'
	},
	// Module resolution options (alias, default paths,...)
	resolve: {
		modules: [path.resolve(__dirname, 'res/scss'), 'node_modules'],
		extensions: ['.js']
		// extensions: ['.js', '.json']
	},
	// Sourcemaps option for development
	devtool: sourcemapsMode,
	// Live development server (serves from memory)
	devServer: {
		contentBase: dist,
		compress: true,
		port: 9050,
		https: true,
		overlay: true,
		historyApiFallback: true,
	},
	// List all the processors
	module: {
		rules: [
			// Haxe loader (through HXML files for now)
			{
				test: /\.hxml$/,
				loader: 'haxe-loader',
				options: {
					// Additional compiler options added to all builds
					extra: `-D build_mode=${buildMode}` + (buildMode !== 'production' ? ' -debug' : '')
				}
			},
			// Static assets loader
			// - you will need to adjust for webfonts
			// - you may use 'url-loader' instead which can replace
			//   small assets with data-urls
			{
				test: /\.(gif|png|jpg|svg)$/,
				loader: 'file-loader',
				options: {
					name: '[name].[hash:7].[ext]'
				}
			},
			// CSS processor/loader
			// - this is where you can add sass/less processing,
			// - also consider adding postcss-loader for autoprefixing
			{
				test: /\.scss$/,
				// loader: 'style-loader!css-loader!sass-loader'
				use: [
					{loader: 'style-loader'},
					{loader: 'css-loader'},
					{
						loader: 'sass-loader',
						options: {
							includePaths: [path.resolve(__dirname, 'res/scss'), path.resolve(__dirname, 'src')]
						}
					}
				]
			}
		]
	},
	// Plugins can hook to the compiler lifecycle and handle extra tasks
	plugins: [
		// Like generating the HTML page with links the generated JS files
		new HtmlWebpackPlugin({
			template: '!!pug-loader!res/index.pug'
		}),
		// You may want to also:
		// - minify/uglify the output using UglifyJSPlugin,
		// - extract the small CSS chunks into a single file using ExtractTextPlugin
		// - inspect your JS output weight using BundleAnalyzerPlugin

		new CopyWebpackPlugin([
			{from: 'public/img', to: 'img'},
			// {from: 'public/favicon.png', to: 'favicon.png'}
		])
	],
};
