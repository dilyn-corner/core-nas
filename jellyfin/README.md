# Jellyfin

Snap package for the [Jellyfin media server](https://jellyfin.org/).

*This is an unofficial snap and not officially supported or released by Jellyfin.*

## Interfaces

This snap requires [dilyn-jellyfin-ffmpeg](https://snapcraft.io/dilyn-jellyfin-ffmpeg)
or some other snap providing a sufficiently similar structure to provide the [graphics-core22](https://canonical.com/mir/docs/the-graphics-core22-snap-interface)
slot. Please refer to [that snap](../jellyfin-ffmpeg) for details on what that
means.

This snap declares the [removable-media](https://snapcraft.io/docs/removable-media-interface)
so that media stored in `/media` can be discovered. This interface is not
(currently) auto-connecting; please connect it if you keep your media there.
This snap declares the [home](https://snapcraft.io/docs/home-interface), but
because the Jellyfin server is a daemon it is run as root so this only gives
access to `/root`. Either store your media there for easy discovery or switch
to `/media`.

There are plans to use `attribute.read: all` for the home interface to gain
access to *all* home directories, but this attribute causes the home interface
to become super-privileged and thus requires manual review. That review might
not ever be approved :)

Connecting [firewall-control](https://snapcraft.io/docs/firewall-control-interface)
allows Jellyfin to manage some ports on your system. If you're fine with the
default, you may not need to connect it.

Connecting [mount-observe](https://snapcraft.io/docs/mount-observe-interface)
may prove useful, but you may not require it.

## Usage

The web UI will be available at the default Jellyfin address <http://localhost:8096>.
Once the relevant interfaces are connected and media is placed in the correct
location, usage should be equivalent to standard packaging.

Hardware acceleration support has been tested with at least the following:

 * Radeon RX 7800XT (VA-API)

You can test hardware acceleration support yourself:

```
  snap run --shell dilyn-jellyfin.server
  real_xdg_runtime_dir=$(dirname "${XDG_RUNTIME_DIR}")
  export WAYLAND_DISPLAY="${real_xdg_runtime_dir}/${WAYLAND_DISPLAY:-wayland-0}"
  mkdir -p "$XDG_RUNTIME_DIR" -m 700
  unset DISPLAY
  vainfo --display drm --device /dev/dri/renderD128
  vulkaninfo
  clinfo
  ffmpeg -v debug -init_hw_device drm=dr:/dev/dri/renderD128 -init_hw_device vulkan@dr
...

Please refer to [the
documentation](https://jellyfin.org/docs/general/post-install/transcoding/hardware-acceleration)
for instructions on testing support for your GPU and please report success or
failure (PRs welcome!).
