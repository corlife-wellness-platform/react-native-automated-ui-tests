# React Native Automated UI Tests

See the blog post here.

To test the UI we use the [Detox](https://github.com/wix/Detox) framework for Android device and iOS simulator testing.

## Running

### Detox

To run a Detox test, first build the app for a specific target:

`detox build -c ios.sim.debug`

Then test:

`detox test -c ios.sim.debug`

In this case, the test will run on an iOS simulator, as defined in the `package.json` file.

## Writing tests

### Detox

To add a Detox test, create a spec file and add it to the `./e2e` folder.

Documentation for writing tests and interacting with a device can be found [here](https://github.com/wix/Detox/blob/master/docs/README.md).

## Running in the Cloud

Currently we build and upload tests in App Center during the post-build script. 
App Center uploads the assets, initiates the test and then polls for the test results, failing the build if tests do not pass.

The following environment variable needs to be set for each build configuration:

- APP_CENTER_CURRENT_PLATFORM - the platform i.e. `android` or `ios`

This will ensure that the correct post build script will be picked up for each platform.

## Android

For Android specific information, see [Android Automated UI Testing](AUTOMATED_UI_TESTING_ANDROID.md)

## Useful resources

- [Bitbar REST API docs](https://docs.bitbar.com/testing/api/index.html)
- [Bitbar sample detox app](https://github.com/bitbar/bitbar-samples/tree/master/samples/testing-frameworks/detox/react-native)
- [Detox actions on elements](https://github.com/wix/Detox/blob/master/docs/APIRef.ActionsOnElement.md)
- [Detox on Bitbar blog post](https://bitbar.com/blog/its-time-to-detox-your-mobile-tests-on-bitbar-cloud/)
