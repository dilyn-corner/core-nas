# Valkey

Snap package for [Valkey](https://valkey.io)

*This is an unofficial snap and not officially supported or released by Valkey.*

## Interfaces

The interfaces (both [network](https://snapcraft.io/docs/network-interface) and
[network-bind](https://snapcraft.io/docs/network-bind-interface)) enable valkey
to be accessible in the standard way via 127.0.0.1 and (by default) port 6379.

For both standard packages and snaps which require valkey or (or redis) it
should be sufficient to have this snap installed. The snap may require at least
the network interface.

## Usage

This snap does allow configuring the port valkey listens on from the standard 6379. To change the port:

* On the command line

```
  snap set valkey.port=portnumber
```

* In a gadget snap's gadget.yaml

```yaml
defaults:
  4BqExISm4BJoSpSr6GW2kvhZP3IkfCdC:
    port: portnumber
```

This snap is not necessarily intended for any sort of direct management; it is
very feature-poor right now (as I don't use valkey outside of Immich, which has
very straight-forward requirements). PRs welcome to add features.
