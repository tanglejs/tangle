(function() {
  var argv, cli, helmsman;

  helmsman = require('helmsman');

  cli = helmsman({
    localDir: 'bin',
    prefix: 'tangle',
    usePath: true
  });

  cli.on('--help', function() {
    console.log("\ntangle - wire up your frontends using grunt & marionette");
    return console.log("\nFor detailed usage, view \"man tangle\".");
  });

  argv = process.argv;

  cli.parse(argv);

}).call(this);
