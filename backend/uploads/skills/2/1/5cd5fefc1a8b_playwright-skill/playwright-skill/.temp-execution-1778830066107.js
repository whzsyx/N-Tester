
(async () => {
  try {
    const dir = process.env.SCREENSHOT_DIR || "./media/screenshots"; const { chromium } = require("playwright"); const browser = await chromium.launch({ headless: true }); const page = await browser.newPage(); await page.goto("http://47.113.104.130:9966"); await page.screenshot({ path: dir + "/smart_example.png", fullPage: true }); console.log("saved", dir + "/smart_example.png"); await browser.close();
  } catch (error) {
    console.error('❌ Automation error:', error.message);
    if (error.stack) {
      console.error(error.stack);
    }
    process.exit(1);
  }
})();
