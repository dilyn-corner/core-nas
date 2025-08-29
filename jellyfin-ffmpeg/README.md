# Jellyfin

Snap package for the [Jellyfin](https://jellyfin.org/) ffmpeg binaries and libraries.

This snap provides the ffmpeg related binaries and libraries built by the
Jellyfin team for Jellyfin.

These libraries are used primarily for the purposes of supporting more hardware
for accelerated transcoding tasks.

*This is an unofficial snap and not officially supported or released by Jellyfin.*

[![Get it from the Snap Store](https://snapcraft.io/en/dark/install.svg)](https://snapcraft.io/dilyn-jellyfin-ffmpeg)

[![dilyn-jellyfin-ffmpeg](https://snapcraft.io/dilyn-jellyfin-ffmpeg/badge.svg)](https://snapcraft.io/dilyn-jellyfin-ffmpeg)
[![dilyn-jellyfin-ffmpeg](https://snapcraft.io/dilyn-jellyfin-ffmpeg/trending.svg?name=0)](https://snapcraft.io/dilyn-jellyfin-ffmpeg)

## Interfaces

This snap provides the [graphics-core22](https://canonical.com/mir/docs/the-graphics-core22-snap-interface)
slot. THe function of this slot is to expose its binaries and libraries to
other snaps to leverage for the purposes of utilizing hardware acceleration for
transcoding.

## Usage

The [dilyn-jellyfin](../jellyfin) snap provides an example of how to use this snap.

Some effort will have to be taken on your end to properly use this as a provider
snap. Many environment variables are involved in tools discovering graphics
libraries they can use for hardware acceleration - sometimes those paths
are even hard-coded. Care has been taken in making this snap to make it as
not-hardcoded as possible (such as stripping rpaths and runpaths from binaries
and libraries), but coverage may vary. I can't test with all possible hardware
:)

One specifically important thing has to do with layouts. In this snapcraft.yaml
you'll see a collection of layouts, but those *won't be helpful for your
consumer snap*. Those layouts won't apply to your snap. Instead, you'll have to
implement them yourself.

Luckily (buggily), whether or not a layout will mount empty content is not
checked by snapd. This means that your snap could declare:

```
layout:
  /etc/OpenCL:
    bind: $SNAP/graphics/etc/OpenCL
```

And at first, snapd will mount nothing to `/etc/OpenCL` (as there is no
`$SNAP/graphics/etc/OpenCL` to mount). However, after connecting the
graphics-core22 interface between your consumer and this provider and rebooting
your system, there *will* be content in `$SNAP/graphics/etc/OpenCL`, and
something will successfully appear in *your* snap's `/etc/OpenCL`. Hacky,
effective! It isn't clear how long this workaround will work for. In an ideal
world, snapd would enable this kind of functionality explicitly, by perhaps
allowing layout sources to come from content interface provider snaps. Until
then, this trick works!

Finally, some tweaks have to be made to the execution environment of your snap.
Some paths must be set ahead of execution so that the app can successfully
find relevant libraries. While you could set these paths yourself, it may be
easier to rely on this snap to provide that script which will set those paths
for you. In order to leverage this, refer to the dilyn-jellyfin snap and see
its graphics-core22 part, and note the script added to the jellyfin app's
`command-chain`. Your consumer should do something similar.
