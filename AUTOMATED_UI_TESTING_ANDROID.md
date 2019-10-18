# Automated UI Testing on Android

## Real Device and Emulator Testing

### Cloud
For Android, we run the detox tests on real devices in Bitbar.

In order to trigger tests in Bitbar from the App Center build, we initialise the test files upload and test from the `scripts/android/bitbar-testing.sh` script.

Some environment variables need to be set in the App Center build config:

- BITBAR_API_KEY - the API key from Bitbar
- BITBAR_PROJECT_ID - the ID of the particular project on Bitbar
- BITBAR_DEVICE_GROUP_ID - the ID of the particular device testing group on Bitbar
- BITBAR_FRAMEWORK_ID - the ID of the particular testing framework on Bitbar (`Appium Server Side`)

More information regarding the Bitbar REST API can be found [here](https://docs.bitbar.com/testing/api/index.html).

#### Signing and testing release builds

In order to test the signed release apk that App Center produces, we also need to sign the `androidTest` apk.

This is done using `jarsigner` and unfortunately also requires that you re-add the android keystore credentials as App Center environment variables:

- APP_CENTER_KEYSTORE_PASSWORD
- APP_CENTER_KEY_PASSWORD
- APP_CENTER_KEY_ALIAS

### Local

You can build and run these tests locally, on an emulator or a real device:

To run a test, first build the app for a specific target:

`detox build -c android.emu.debug`

Then test:

`detox test -c android.emu.debug`

In this case, the test will run on an Android emulator, as defined in the `package.json` file.

Make sure metro is running `yarn start` if running a debug build test.

To change the target device edit the `name` property in the `package.json` config, setting it to whichever real or emulated device you require:

```
"android.emu.debug": {
    "binaryPath": "android/app/build/outputs/apk/debug/app-debug.apk",
    "build": "cd android && ./gradlew assembleDebug assembleAndroidTest -DtestBuildType=debug && cd ..",
    "type": "android.emulator",
    "name": "Pixel_3_API_28"
},
```

To obtain the name of an emulated device, run:

`adb -s emulator-5554 emu avd name`

To obtain the name of a real device, run:

`adb devices`

NOTE: you may need to run `adb reverse tcp:8081 tcp:8081` to connect to a real device.
