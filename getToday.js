#!/usr/bin/env node

const fs = require('fs');
const pup = require('puppeteer');
const sleep = require('util').promisify(setTimeout);
const url = 'https://adventofcode.com/';

const date = new Date();
const year = date.getFullYear();

function msToTime(duration) {
    const hrs = Math.floor((duration / (1000 * 60 * 60)) % 24);
    const min = Math.floor((duration / (1000 * 60)) % 60);
    const sec = Math.floor((duration / 1000) % 60);

    const hours = (hrs < 10) ? "0" + hrs : hrs;
    const minutes = (min < 10) ? "0" + min : min;
    const seconds = (sec < 10) ? "0" + sec : sec;

    return hours + ":" + minutes + ":" + seconds + ".";
}

(async () => {
    const cookie = JSON.parse(await fs.readFileSync('cookie/cookies.json', 'utf8'));
    const browser = await pup.launch();
    const page = await browser.newPage();

    await page.setViewport({
        width: 1366,
        height: 768
    });
    await page.setCookie(...cookie).catch(e => console.log(e));

    let startTime = new Date();
    startTime.setHours(21);
    startTime.setMinutes(0);
    startTime.setSeconds(1);

    const year = startTime.getFullYear();
    const day = startTime.getDate() + 1;
    const day_str = day < 10 ? `0${day}` : day

    timer = setInterval(function() {
        let waitTime = (msToTime(startTime - new Date() + 1000));
        process.stdout.clearLine();
        process.stdout.cursorTo(0);
        process.stdout.write(`getting input in: ${waitTime}`);
    }, 1000);

    await sleep(startTime - new Date() + 1000);
    clearInterval(timer);
    const inputUrl = `${url}${year}/day/${day}/input`;
    const fpath = `./${year}/input/${day_str}.txt`;

    await page.goto(inputUrl);
    const input = await page.$eval('*', x => x.innerText);
    await fs.writeFileSync(fpath, input);
    console.log(`${fpath}:\n${input}`);
    await browser.close();
})();
