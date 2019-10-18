#!/usr/bin/env bash

# Loop through the example env file and echo any vars that exist in the env to a .env file
while IFS='=' read -r key value
do
    echo "${key}=${!key}" >> .env
done <.env.example

printf "\n.env created with contents:\n"
cat .env

# Copy config files for the specified environment
echo "Copying files for $ENVIRONMENT environment"
mkdir -p android/app/src/main/assets
cp -rf "environments/$ENVIRONMENT/google-services.json" android/app
cp -rf "environments/$ENVIRONMENT/GoogleService-Info.plist" ios
cp -rf "environments/$ENVIRONMENT/appcenter-config.json" android/app/src/main/assets
cp -rf "environments/$ENVIRONMENT/AppCenter-Config.plist" ios


if [ "$APPCENTER_BUILD_ID" ]; then
  echo "Updating android build id"

  # Updating ids

  buildGradle=./android/app/build.gradle

  sed -i '' "s/versionCode 1/versionCode $APPCENTER_BUILD_ID/g" $buildGradle

  # Print out file for reference
  cat $buildGradle

  echo "Updated build id"
fi
