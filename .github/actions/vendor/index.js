const core = require('@actions/core');
const exec = require('@actions/exec');

async function run() {
  const img = core.getInput('img');
  const imgArray = img.split("/");
  if (imgArray[0].includes(".")) {
    imgOut = img.replace(imgArray[0]+'/', '')
  } else {
    imgOut = img
  }
  const repo = core.getInput('repo');
  await exec.exec(`docker pull ${img}`)
  await tagAndPush(img, imgOut, 'gcr.io/pluralsh/')

  if (repo) {
    await tagAndPush(img, imgOut, `dkr.plural.sh/${repo}/`)
  }
}

async function tagAndPush(img, imgOut, prefix) {
  await exec.exec(`docker tag ${img} ${prefix}${imgOut}`)
  await exec.exec(`docker push ${prefix}${imgOut}`)
}

run();
