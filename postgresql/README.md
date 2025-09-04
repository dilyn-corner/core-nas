# PostgreSQL

Snap package for [PostgreSQL](https://www.postgresql.org/).

*This is an unofficial snap and not officially supported by or released by PostgreSQL.*

[![Get it from the Snap Store](https://snapcraft.io/en/dark/install.svg)](https://snapcraft.io/dilyn-postgresql)

[![dilyn-postgresql](https://snapcraft.io/dilyn-postgresql/badge.svg)](https://snapcraft.io/dilyn-postgresql)
[![dilyn-postgresql](https://snapcraft.io/dilyn-postgresql/trending.svg?name=0)](https://snapcraft.io/dilyn-postgresql)

## Interfaces

The interfaces (both [network](https://snapcraft.io/docs/network-interface) and
[network-bind](https://snapcraft.io/docs/network-bind-interface)) enable
postgresql to be accessible in the standard way via 127.0.0.1 and (by
default) port 5432.

For standard packages and snaps which do not need to manage their own e.g.
cluster settings which require postgresql it should be sufficient to have this
snap installed. Direct management of clusters and databases is only loosely
supported and not very well tested (as I don't use postgresql outside of
Immich).

For snaps which would prefer to manage everything directly, it should be
sufficient to declare the postgresql plug:

```yaml
plugs:
  interface: content
  content: pg-content
  target: postgresql
  default-provider: dilyn-postgresql

apps:
  my-app:
    ...
    plugs: [postgresql]
```

## Usage

This snap does not provide very extensive configuration right now, but it *is*
planned. For userless Ubuntu Core devices, the best I can give you right now
is managing your own cluster directly and controlling its configuration etc.
through your own snap. See [dilyn-immich](../immich) for an example.

Libraries are a bit trickier to manage in this style, as postgresql will examine
`$SNAP/postgresql/usr/lib/postgresql/<ver>/lib` for libraries to load (instead
of the consumer-snap provided `$SNAP/usr/lib/postgresql/<ver>/lib` as one might
expect), meaning that additional libraries must be shipped in this snap and
handled accordingly by consumer snaps. This is undesirable behavior, but it's a
pill I swallow for now. If someone can craft a clever way around this, I'd love
to see it :)

PRs are welcome to extend functionality.
