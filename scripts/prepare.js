const path = require('path');
const shell = require("shelljs/global");

var dest = path.join(process.env.PWD, process.env.npm_package_config_www_dir);
var src = path.join(process.env.PWD, process.env.npm_package_config_resources_dir, "*");

if (!test("-e", dest))
    mkdir("-p", dest);

cp('-R', src, dest);
