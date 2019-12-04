const fs = require('fs');
const url = 'https://adventofcode.com/';

(async () => {
    const cookie = JSON.parse(await fs.readFileSync('cookie/cookies.json', 'utf8'));
    const browser = await pup.launch();
    const page = await browser.newPage();

    await page.setViewport({ width: 1366, height: 768 });
    await page.setCookie(...cookie).catch(e => console.log(e));

    await browser.close();
});

var i = 0;  // dots counter
setInterval(function() {
  process.stdout.clearLine();  // clear current text
  process.stdout.cursorTo(0);  // move cursor to beginning of line
  i = (i + 1) % 4;
  var dots = new Array(i + 1).join(".");
  process.stdout.write("Waiting" + dots);  // write text
}, 300);

console.log("done");