.POSIX:

# Could be changed
SC      ?= snapcraft
ARCH    ?= amd64
BLFLAGS ?= --destructive-mode
EXFLAGS ?= --build-for $(ARCH)
TRK     ?= --release latest/edge

# Shouldn't be changed
SCBLD = prime
SCPCK = pack
UPFLG = upload

SNAP_PRIME = valkey/prime     \
			 immich/prime     \
			 jellyfin/prime   \
			 ersatztv/prime   \
			 tubesync/prime   \
			 postgresql/prime \
			 jellyfin-ffmpeg/prime

SNAP_OBJ = valkey.snap     \
		   immich.snap     \
		   jellyfin.snap   \
		   ersatztv.snap   \
		   tubesync.snap   \
		   postgresql.snap \
		   jellyfin-ffmpeg.snap

# What is a folder if not the suffix of ${PWD%/*}
.SUFFIXES: prime .snap

.PHONY: prepare undo-prepare

# Make some modifications to ease building requirements. Snapcraft requires
# that default-providers be *installed*, so ignore them. Instead, refer to other
# build directories
prepare:
	sed -i -e 's|/snap/dilyn-jellyfin-ffmpeg|$(PWD)/jellyfin-ffmpeg|' \
		   -e 's|default-provider:|#default-provider:|'               \
		   -e 's|/current/|/prime/|'  */snap/snapcraft.yaml

# Undo preparation
undo-prepare:
	sed -i -e 's|$(PWD)/jellyfin-ffmpeg|/snap/dilyn-jellyfin-ffmpeg|' \
		   -e 's|#default-provider:|default-provider:|'               \
		   -e 's|/prime/|/current/|' */snap/snapcraft.yaml


# Build $(SNAP_PRIME) directories
$(SNAP_PRIME): prepare
	cd $* && $(SC) $(SCBLD) $(BLFLAGS) $(EXFLAGS)

# Dependencies
jellyfin/prime: jellyfin-ffmpeg/prime
ersatztv/prime: jellyfin-ffmpeg/prime
tubesync/prime: jellyfin-ffmpeg/prime
immich/prime:   jellyfin-ffmpeg/prime

# Build snap packages from $(SNAP)/prime directories
$(SNAP_OBJ): $(SNAP_PRIME)
	make undo-prepare
	$(SC) $(SCPCK) -o $@ $(@:.snap=/prime)

.DEFAULT: release-all

.PHONY: prime-all pack-all clean

# Simple rule to generate all prime directories
prime-all: $(SNAP_PRIME)

# Simple rule to generate all snap packages
pack-all:  $(SNAP_OBJ)

# Real rule to upload and release the snap packages
release-all: $(SNAP_OBJ)
	for snap in $(SNAP_OBJ); do        \
		$(SC) $(UPFLG) $(TRK) $$snap ; \
	done

clean:
	rm -f *.snap
	rm -rf */overlay */parts */prime */stage
	git restore .
