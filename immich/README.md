# Immich

Snap package for [Immich](https://immich.app).

* This is an unofficial snap and not officially supported or released by Immich.*

[![Get it from the Snap Store](https://snapcraft.io/en/dark/install.svg)](https://snapcraft.io/dilyn-immich)

[![dilyn-immich](https://snapcraft.io/dilyn-immich/badge.svg)](https://snapcraft.io/dilyn-immich)
[![dilyn-immich](https://snapcraft.io/dilyn-immich/trending.svg?name=0)](https://snapcraft.io/dilyn-immich)

## Interfaces

This snap declares the [removable-media](https://snapcraft.io/docs/removable-media-interface)
so that media stored in `/media` can be discovered. This interface is not
(currently) auto-connecting; please connect it if you keep your media there.

The [network](https://snapcraft.io/docs/network-interface) and [network-bind](https://snapcraft.io/docs/network-bind-interface)
are required for communicating with PostgreSQL and Valkey, which
can be provided by either a system package or a snap. This snap uses [dilyn-postgresql](../postgresql)
and [dilyn-valkey](../valkey) out of the box, and one could give [caddy](https://snapcraft.io/caddy)
a try to make immich viewable on the broader network :)

The [gpu-2404](https://canonical.com/mir/docs/the-gpu-2404-snap-interface)
is meant for some provider snap to provide access to the relevant binaries,
specifically for things like machine learning and transcoding. These features
are currently not implemented or tested, but the immich server still requires
that a provider be installed and connected, though this requirement may be
removed one day.

Connecting [mount-observe](https://snapcraft.io/docs/mount-observe-interface)
may prove useful, but you may not require it.

The postgresql interface is intended for use with a snap providing the relevant
postgresql tooling, such as [dilyn-postgresql](../postgresql). It should be
possible to use this snap with a host-installed postgresql however.

## Usage

The web UI will be available at the default Immich address <http://localhost:3001>.

Currently, the UI is broken! :D You can get there and "create an account", but
if you attempt to login nothing will load. This is being investigated, kind of.
