#!/usr/bin/env bash

if [ "$APP_CENTER_CURRENT_PLATFORM" == "android" ]
    then

      echo "------------------------------Android Post Build Script------------------------------"

      source ./scripts/android/appcenter-post-build.sh
elif [ "$APP_CENTER_CURRENT_PLATFORM" == "ios" ]
    then

      echo "--------------------------------iOS Post Build Script--------------------------------"
      #todo
fi
