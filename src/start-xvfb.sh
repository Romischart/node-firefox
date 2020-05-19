#!/usr/bin/env bash

if [ "${START_XVFB}" = true ] ; then
  export GEOMETRY="${SCREEN_WIDTH}""x""${SCREEN_HEIGHT}""x""${SCREEN_DEPTH}"

  rm -f /tmp/.X*lock

  /usr/bin/Xvfb ${DISPLAY} -screen 0 ${GEOMETRY} -dpi ${SCREEN_DPI} -ac +extension RANDR
else
  echo "Firefox can only run in headless mode."
fi
