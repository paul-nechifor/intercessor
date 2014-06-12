# Intercessor

## Install

    npm install intercessor

## Usage

The app must contain a `manifest.coffee` to signal it is a Intercessor app.

The following files and dirs are recognized and processed.

Name | Destination | Action
--- | --- | ---
`app/` | `build/app/` | Compiled from CoffeeScript.
`client/` | `build/s/js/client.js` | Browserified with its requirements. Has to contain a `index.coffee`.
`html/` | `build/html/` | Copied and served from root.
`static/` | `build/s/` | Copied.
`styles/` | `build/s/css/app.css` | Compiled from Stylus. Has to contain a `index.styl`.
`views/` | `build/views/` | Copied.

## Example

See [intercessor-example][example].

## Development

Rebuild it:

    npm run-script preinstall

## License

MIT

[example]: https://github.com/paul-nechifor/intercessor-example
