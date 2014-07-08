# Intercessor

Intercessor is a simple web framework based on Express. I created it so that I
can write small convention over configuration apps for my web site
([nechifor.net][nechifor-net]) but still have them run standalone. The apps are
joined together with [nechifor-site][nechifor-site].

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

## Development

Rebuild it:

    npm run preinstall

## License

MIT

[nechifor-net]: http://nechifor.net
[nechifor-site]: https://github.com/paul-nechifor/nechifor-site
[nec-apps]: https://github.com/paul-nechifor/nechifor-site#apps
[icex]: https://github.com/paul-nechifor/intercessor-example
