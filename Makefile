.POSIX:

SC      ?= snapcraft

SCBLD   ?= prime
SCPCK   ?= pack
SCUPL   ?= upload

BLFLAGS ?= --destructive-mode
UPFLAGS ?= --release latest/edge

EXFLAGS ?= --build-for amd64

SNAP_PRIME = valkey/prime     \
			 immich/prime     \
			 jellyfin/prime   \
			 ersatztv/prime   \
			 postgresql/prime \
			 jellyfin-ffmpeg/prime

SNAP_OBJ = valkey.snap     \
		   immich.snap     \
		   jellyfin.snap   \
		   ersatztv.snap   \
		   postgresql.snap \
		   jellyfin-ffmpeg.snap

# What is a folder if not the suffix of ${PWD%/*}
.SUFFIXES: prime .snap

.PHONY: prepare

# Make some necessary modifications to ease building requirements
# snapcraft will require that default-providers be *installed*, so ignore them
# Instead, refer to other build directories
prepare:
	sed -i -e 's|/snap/dilyn-jellyfin-ffmpeg|$(PWD)/jellyfin-ffmpeg|' \
		   -e 's/current/prime/' \
		   -e 's/default-provider:/#default-provider:/' */snap/snapcraft.yaml

# Build $(SNAP_PRIME) directories
$(SNAP_PRIME): prepare
	cd $* && $(SC) $(SCBLD) $(BLFLAGS) $(EXFLAGS)

# A dependency
jellyfin/prime: jellyfin-ffmpeg/prime
ersatztv/prime: jellyfin-ffmpeg/prime
immich/prime:   jellyfin-ffmpeg/prime

# Build snap packages from $(SNAP)/prime directories
#   $(OBJ): src/$(@:.o=.c)
$(SNAP_OBJ): $(SNAP_PRIME)
        # Undo preparation
	sed -i -e 's|$(PWD)/jellyfin-ffmpeg|/snap/dilyn-jellyfin-ffmpeg|' \
		   -e 's/prime/current/' \
		   -e 's/#default-provider:/default-provider:/' */snap/snapcraft.yaml

	$(SC) $(SCPCK) -o $@ $<

.PHONY: prime-all pack-all release-all clean

prime-all: $(SNAP_PRIME)

pack-all: $(SNAP_OBJ)

release: $(SNAP_OBJ)
	$(SC) $(SCUPL) $(UPFLAGS) $(CHANNEL) $<

clean:
	rm -f *.snap
	rm -rf */overlay */parts */prime */stage
	git restore .
