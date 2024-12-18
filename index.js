import puppeteer from 'puppeteer';

if (process.env.SUNNY_USERNAME === undefined || process.env.SUNNY_PASSWORD === undefined) {
    console.log("Please set SUNNY_USERNAME and SUNNY_PASSWORD environment variables")
    process.exit(1)
}

console.log("Starting browser")
const browser = await puppeteer.launch({
    browser: "chrome",
    args: ['--no-sandbox'],
});
console.log("Browser started")
const page = await browser.newPage();
try {
    while (true) {
        console.log("Navigating to login page")
        await page.goto('https://ennexos.sunnyportal.com/login', {waitUntil: 'networkidle0'});
        await page.setViewport({width: 1920, height: 1080});
        if (await page.$("#onetrust-accept-btn-handler") !== null) {
            console.log("Accepting cookies")
            await page.click("#onetrust-accept-btn-handler");
        }
        // wait a bit to close popup (else login button doesn't work)
        await new Promise(resolve => setTimeout(resolve, 500))
        await page.click('#login > button');
        console.log("Login button clicked")
        await page.waitForSelector('#username');
        await page.type('#username', process.env.SUNNY_USERNAME);
        await page.type('#password', process.env.SUNNY_PASSWORD);
        await page.keyboard.press('Enter');
        console.log("Login form submitted")
        await new Promise(resolve => setTimeout(resolve, 3000)) // wait for login to succeed
        await page.goto('https://ennexos.sunnyportal.com/14654281,14193940/dashboard', {waitUntil: 'networkidle0'});
        console.log("Navigated to dashboard")
        await new Promise(resolve => setTimeout(resolve, 1000))

        while (true) {
            await page.screenshot({
                path: 'images/screenshot.png'
            });
            // console.log("Screenshot taken")

            // check if logged out
            console.log("url", page.url())
            if (!page.url().includes('14654281,14193940/dashboard')) {
                break;
            }
            await new Promise(resolve => setTimeout(resolve, process.env.SCREENSHOT_DELAY ?? 10000))
        }
    }
} catch (e) {
    console.log(e)
    await page.screenshot({
        path: 'images/screenshot.png'
    });
} finally {
    await browser.close();
}