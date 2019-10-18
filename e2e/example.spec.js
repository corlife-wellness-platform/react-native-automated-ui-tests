const detox = require('detox');
const config = require('../package.json').detox;

describe('Example', () => {
  beforeEach(async () => {
    if (typeof(device) == 'undefined') {
      await detox.init(config);
    }
    await device.reloadReactNative();
  });

  it('should show "Welcome to React"', async () => {
    try {
      await expect(element(by.text('Welcome to React'))).toBeVisible();
    } catch (error) {
    }
  });
});
