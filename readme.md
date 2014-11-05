# Intercessor

Intercessor is a simple web framework based on Express. I created it so that I
can write small convention over configuration apps for my web site
([nechifor.net][]) but still have them run standalone. The apps are joined
together in [nechifor-site][].

## Examples

The basic example meant for cloning is [intercessor-example][icex]. All other
projects are listed in the [Apps section][nec-apps] of Nechifor Site.

## Usage

An app must contain a `intercessor.coffee` to signal it is a Intercessor app.

The following files and dirs are recognized and processed.

Name | Destination | Action
--- | --- | ---
`app/` | `build/app/` | Compiled from CoffeeScript.
`client/` | `build/s/js/client.js` | Browserified with its requirements. Has to contain a `index.coffee`.
`html/` | `build/html/` | Copied and served from root.
`gulpfile.js` | — | `gulp` is executed. This is done first.
`static/` | `build/s/` | Copied.
`styles/` | `build/s/css/app.css` | Compiled from Stylus. Has to contain a `index.styl`.
`views/` | `build/views/#{app.id}` | Copied.

## Supported commands

Intercessor apps should use the scripts field in `package.json` to implement
simple common commands. This means you can run the commands with `npm run
<command>`. Intercessor apps should support these commands:

* `up` - Download every requirement, build everything and bring the standalone
web server up. One command to rule them all.

* `build` - Build the web site in `build/` and build all other necessary
content.

* `start` - Start the build web server.

* `intercessor-make` - Make everything necessary before the site is built with
`intercessor` to run jointly (non standalone).

## License

MIT

[nechifor.net]: http://nechifor.net
[nechifor-site]: https://github.com/paul-nechifor/nechifor-site
[nec-apps]: https://github.com/paul-nechifor/nechifor-site#apps
[icex]: https://github.com/paul-nechifor/intercessor-example
