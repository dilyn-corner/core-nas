# ErsatzTV

Snap package for [ErsatzTV](https://ersatztv.org).

* This is an unofficial snap and not officially supported or released by ErsatzTV.*

[![Get it from the Snap Store](https://snapcraft.io/en/dark/install.svg)](https://snapcraft.io/dilyn-ersatztv)

[![dilyn-ersatztv](https://snapcraft.io/dilyn-ersatztv/badge.svg)](https://snapcraft.io/dilyn-ersatztv)
[![dilyn-ersatztv](https://snapcraft.io/dilyn-ersatztv/trending.svg?name=0)](https://snapcraft.io/dilyn-ersatztv)

## Interfaces

This snap declares the [removable-media](https://snapcraft.io/docs/removable-media-interface)
so that media stored in `/media` can be discovered. This interface is not
(currently) auto-connecting; please connect it if you keep your media there.

The [network](https://snapcraft.io/docs/network-interface) and [network-bind](https://snapcraft.io/docs/network-bind-interface)
are required for accessing services such as Emby or Jellyfin, which can be
provided by either a system package or a snap.

The [graphics-core22](https://canonical.com/mir/docs/the-graphics-core22-snap-interface)
is meant for some provider snap to provide access to the relevant binaries,
specifically for things like transcoding. The default provider is currently
[dilyn-jellyfin-ffmpeg](../jellyfin-ffmpeg) but you can choose whichever ffmpeg
provider you'd like.

## Usage

The web UI will be available at the default ErsatzTV address <http://localhost:8409>.

This snap does allow configuring the port(s) used for the UI and streaming from
the standard 8409. To change the port:

* On the command line

```
  snap set dilyn-ersatztv port.ui=portnumber
  snap set dilyn-ersatztv port.stream=otherportnumber
```

* In a gadget snap's `gadget.yaml`:

```yaml
defaults:
  vgDIAs3PXlWFvI9QfSH9J9FmBP7grCQp
    port:
      ui: portnumber
      stream: otherportnumber
```
