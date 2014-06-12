# Intercessor

## Install

    npm install intercessor

## Usage

The app must contain a `manifest.coffee` to signal it is a Intercessor app.

Recognized files and dirs:

* `app/` – If it exists, it is compiled from CoffeeScript into `build/app/`.
* `client/` – If it exists, it has to contain a `index.coffee`. It and its
requirements are browserified into `build/s/js/client.js`.
* `gulpfile.js` – If it exists, `gulp` is run before any of the other files
are used.
* `static/` – If it exists, all contents are copied into `build/s/`.
* `styles/` – If it exists, it has to contain a `index.styl`. It and its
requirements are compiled into `build/s/css/app.css`.
* `views/` – If it exists, it is copied to `build/views`.

## Example

See [intercessor-example][example].

## Development

Rebuild it:

    npm run-script preinstall

## License

MIT

[example]: https://github.com/paul-nechifor/intercessor-example
