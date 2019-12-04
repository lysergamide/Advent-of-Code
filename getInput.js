const bar = require('cli-progress');
const pup = require('puppeteer');
const fs = require('fs');

const url = 'https://adventofcode.com/';

async function saveDay(page, year, day) {
  let day_str = `${day}`

  if (day < 10) {
    day_str = "0" + day_str;
  }

  let fpath = `./${year}/input/${day_str}.txt`;
  if (!fs.existsSync(fpath)) {
    let input_url = `${url}${year}/day/${day}/input`;
    await page.goto(input_url)
    let text = await page.$eval('*', x => x.innerText);
    fs.writeFileSync(fpath, text);
  }
}

async function savePast(page) {
  const b = new bar.Bar(
    {
      barCompleteChar: '#',
      barIncompleteChar: ' ',
      format: '|previous years' + '||{bar}||' + '{percentage}%|',
      fps: 5,
      stream: process.stdout,
      barsize: 30
    }
  );

  b.start(25 * ((new Date().getFullYear()) - 2015), 0);
  let i = 0;
  for (year = 2015; year < 2019; year++) {
    for (day = 1; day <= 25; day++) {
      i++;
      b.update(i);
      await saveDay(page, year, day);
    }
  }
  b.stop();
}

(async () => {
  const cookie = JSON.parse(await fs.readFileSync('cookie/cookies.json', 'utf8'));
  const browser = await pup.launch();
  const page = await browser.newPage();

  await page.setViewport({ width: 1366, height: 768 });
  await page.setCookie(...cookie).catch(e => console.log(e));

  await savePast(page);

  await browser.close();
})();
