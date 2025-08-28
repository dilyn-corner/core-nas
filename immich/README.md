# Immich

Snap package for [Immich](https://immich.app).

* This is an unofficial snap and not officially supported or released by Immich.*

## Interfaces

This snap declares the [removable-media](https://snapcraft.io/docs/removable-media-interface)
so that media stored in `/media` can be discovered. This interface is not
(currently) auto-connecting; please connect it if you keep your media there.

The [network](https://snapcraft.io/docs/network-interface) and [network-bind](https://snapcraft.io/docs/network-bind-interface)
are required for communicating with PostgreSQL and Valkey, which
can be provided by either a system package or a snap. This snap uses [dilyn-postgresql](../postgresql)
and [dilyn-valkey](../valkey) out of the box, and one could give [caddy](https://snapcraft.io/caddy)
a try to make immich viewable on the broader network :)

The [graphics-core22](https://canonical.com/mir/docs/the-graphics-core22-snap-interface)
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

The web UI will be available at the default Immich address <http://localhost:3000>.


## TBD

The below is temporary and intended as a note to self, pending implementation.

You can find documentation for all the supported env variables at https://immich.app/docs/install/environment-variables

The location where your uploaded files are stored
UPLOAD_LOCATION=./library

The location where your database files are stored
DB_DATA_LOCATION=./postgres

To set a timezone, uncomment the next line and change Etc/UTC to a TZ identifier from this list: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List
TZ=Etc/UTC

The Immich version to use. You can pin this to a specific version like "v1.71.0"
IMMICH_VERSION=release

Connection secret for postgres. You should change it to a random password
Please use only the characters `A-Za-z0-9`, without special characters or spaces
DB_PASSWORD=postgres

The values below this line do not need to be changed
DB_USERNAME=postgres
DB_DATABASE_NAME=immich

Configurations for hardware-accelerated machine learning

See https://immich.app/docs/features/ml-hardware-acceleration for info on usage.

```
services:
  armnn:
    devices:
      - /dev/mali0:/dev/mali0
    volumes:
      - /lib/firmware/mali_csffw.bin:/lib/firmware/mali_csffw.bin:ro # Mali firmware for your chipset (not always required depending on the driver)
      - /usr/lib/libmali.so:/usr/lib/libmali.so:ro # Mali driver for your chipset (always required)
  
  rknn:
    security_opt:
      - systempaths=unconfined
      - apparmor=unconfined
    devices:
      - /dev/dri:/dev/dri

  cpu: {}

  cuda:
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities:
                - gpu

  rocm:
    group_add:
      - video
    devices:
      - /dev/dri:/dev/dri
      - /dev/kfd:/dev/kfd

  openvino:
    device_cgroup_rules:
      - 'c 189:* rmw'
    devices:
      - /dev/dri:/dev/dri
    volumes:
      - /dev/bus/usb:/dev/bus/usb

  openvino-wsl:
    devices:
      - /dev/dri:/dev/dri
      - /dev/dxg:/dev/dxg
    volumes:
      - /dev/bus/usb:/dev/bus/usb
      - /usr/lib/wsl:/usr/lib/wsl
```

Configurations for hardware-accelerated transcoding

See https://immich.app/docs/features/hardware-transcoding for more info on using hardware transcoding.

```
services:
  cpu: {}

  nvenc:
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities:
                - gpu
                - compute
                - video

  quicksync:
    devices:
      - /dev/dri:/dev/dri

  rkmpp:
    security_opt: # enables full access to /sys and /proc, still far better than privileged: true
      - systempaths=unconfined
      - apparmor=unconfined
    group_add:
      - video
    devices:
      - /dev/rga:/dev/rga
      - /dev/dri:/dev/dri
      - /dev/dma_heap:/dev/dma_heap
      - /dev/mpp_service:/dev/mpp_service
      #- /dev/mali0:/dev/mali0 # only required to enable OpenCL-accelerated HDR -> SDR tonemapping
    volumes:
      #- /etc/OpenCL:/etc/OpenCL:ro # only required to enable OpenCL-accelerated HDR -> SDR tonemapping
      #- /usr/lib/aarch64-linux-gnu/libmali.so.1:/usr/lib/aarch64-linux-gnu/libmali.so.1:ro # only required to enable OpenCL-accelerated HDR -> SDR tonemapping

  vaapi:
    devices:
      - /dev/dri:/dev/dri

  vaapi-wsl: # use this for VAAPI if you're running Immich in WSL2
    devices:
      - /dev/dri:/dev/dri
      - /dev/dxg:/dev/dxg
    volumes:
      - /usr/lib/wsl:/usr/lib/wsl
    environment:
      - LIBVA_DRIVER_NAME=d3d12
```
