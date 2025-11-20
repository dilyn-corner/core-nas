#!/bin/sh -eux

_uiport="$(snapctl get port.ui)"
_strmport="$(snapctl get port.streaming)"

export ETV_UI_PORT="${_uiport:-8409}"
export ETV_STREAMING_PORT="${_strmport:-8409}"

start() {
  "${SNAP}/ErsatzTV"
}

stop() {
  kill -s SIGINT "$(pgrep ErsatzTV)"
}

"$@"
