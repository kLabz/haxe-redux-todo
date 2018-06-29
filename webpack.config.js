const path = require('path');

const buildMode = process.env.NODE_ENV || 'development';
const buildTarget = process.env.TARGET || 'web';

const isProd = buildMode === 'production';
const isCordova = buildTarget.startsWith('cordova');

const sourcemapsMode = isProd ? 'eval-source-map' : undefined;
const dist = isCordova ? path.resolve(__dirname, 'cordova/www') : path.resolve(__dirname, '.build');

const webpack = require('webpack');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const CleanWebpackPlugin = require('clean-webpack-plugin');
const ExtractTextPlugin = require('extract-text-webpack-plugin');

const useFriendly = true;
const FriendlyErrorsWebpackPlugin = require('friendly-errors-webpack-plugin');
const haxeFormatter = require('haxe-loader/errorFormatter');
const haxeTransformer = require('haxe-loader/errorTransformer');

const extractCSS = new ExtractTextPlugin('app.css');
const cleanCordovaPlugin = new CleanWebpackPlugin(['cordova/www/*'], {dry: false});

module.exports = {
	entry: {
		app: './build.hxml'
	},
	output: {
		path: dist,
		filename: '[name].js'
		// publicPath: '/',
	},
	resolve: {
		modules: [path.resolve(__dirname, 'res/scss'), 'node_modules'],
		extensions: ['.js']
	},
	devtool: sourcemapsMode,
	devServer: {
		contentBase: dist,
		quiet: useFriendly,
		compress: true,
		port: 9050,
		https: true,
		overlay: true,
		historyApiFallback: true,
	},
	module: {
		rules: [
			{
				test: /\.hxml$/,
				loader: 'haxe-loader',
				options: {
					emitStdoutAsWarning: true,
					extra: `-D build_mode=${buildMode}`
						+ (!isProd ? ' -debug' : '')
						+ (isCordova ? ' -D cordova' : '')
				}
			},
			{
				test: /\.(gif|png|jpg|svg)$/,
				loader: 'file-loader',
				options: {
					name: '[name].[hash:7].[ext]'
				}
			},
			isProd
			? {
				test: /\.scss$/,
				loader: extractCSS.extract({
					fallback: "style-loader",
					use: [
						{loader: 'css-loader'},
						{
							loader: 'sass-loader',
							options: {
								includePaths: [path.resolve(__dirname, 'res/scss'), path.resolve(__dirname, 'src')]
							}
						}
					]
				})
			}
			: {
				test: /\.scss$/,
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
	plugins: [
		new HtmlWebpackPlugin({
			template: '!!pug-loader!res/index.pug'
		}),
	]
	.concat(useFriendly ? [
		new FriendlyErrorsWebpackPlugin({
			compilationSuccessInfo: {
				messages: [
					`Your application is running here: https://localhost:${9050}`
				]
			},
			additionalTransformers: [haxeTransformer],
			additionalFormatters: [haxeFormatter]
		})
	] : [])
	.concat(isCordova ? [cleanCordovaPlugin] : [])
	.concat(isProd ? [extractCSS] : []),
};
