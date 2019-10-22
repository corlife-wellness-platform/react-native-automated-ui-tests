#!/usr/bin/env bash

if [ ! -z "$BITBAR_API_KEY" ]
  then

    echo "------------------------------Android Bitbar Testing------------------------------"

    echo "Building app for Bitbar..."
    "${PWD}/node_modules/.bin/detox" build -c android.device.release

    echo "Signing apk..."
    /usr/bin/jarsigner -keystore $APPCENTER_SOURCE_DIRECTORY/.certs/keystore.jks -storepass $APP_CENTER_KEYSTORE_PASSWORD -keypass $APP_CENTER_KEY_PASSWORD -verbose -sigalg MD5withRSA -digestalg SHA1 -signedjar ./android/app/build/outputs/apk/androidTest/release/app-release-androidTest.apk ./android/app/build/outputs/apk/androidTest/release/app-release-androidTest.apk $APP_CENTER_KEY_ALIAS

    echo "Building test file..."
    cp ./bitbar/run-tests-android.sh run-tests.sh
    zip -r bitbarTestsAndroid ./run-tests.sh ./android/app/build/outputs/apk ./e2e ./package.json
    cp ./android/app/build/outputs/apk/release/app-release.apk application.apk

    echo "Uploading tests to bitbar..."

    echo "Uploading dummy application apk..."
    appFile=$(curl -X POST -u "$BITBAR_API_KEY": https://cloud.bitbar.com/api/me/files -F "file=@application.apk" | jq -r '.id')
    echo $appFile

    echo "Uploading test file..."
    testFile=$(curl -X POST -u "$BITBAR_API_KEY": https://cloud.bitbar.com/api/me/files -F "file=@bitbarTestsAndroid.zip" | jq -r '.id')
     echo $testFile

    CONFIGURATION=$( jq -n \
              --arg file1 "${appFile}" \
              --arg file2 "${testFile}" \
              --arg projectId "${BITBAR_PROJECT_ID}" \
              --arg frameworkId "${BITBAR_FRAMEWORK_ID}" \
              --arg deviceGroupId "${BITBAR_DEVICE_GROUP_ID}" \
              --arg testRunName "Test Run - Branch: ${APPCENTER_BRANCH} - Build: ${APPCENTER_BUILD_ID}" \
              '{"osType":"ANDROID","projectId":$projectId,"files":[{"id": $file1},{"id": $file2}],"frameworkId":$frameworkId,"deviceGroupId":$deviceGroupId,"testRunName":$testRunName}' )

    echo "$CONFIGURATION" > configuration

    cat configuration

    echo "Starting tests..."
    testRunId=$(curl -H 'Content-Type: application/json' -u "$BITBAR_API_KEY": https://cloud.bitbar.com/api/me/runs --data-binary @configuration | jq -r '.id')

    echo "Checking status of Android tests..."
    source ./scripts/query-bitbar-test-status.sh $testRunId
fi
