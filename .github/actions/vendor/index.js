const core = require('@actions/core');
const exec = require('@actions/exec');

async function run() {
  const img = core.getInput('image');
  const repo = core.getInput('repo');
  await exec.exec(`docker pull ${img}`)
  await tagAndPush(img, 'gcr.io/pluralsh/')

  if (repo) {
    await tagAndPush(img, `dkr.plural.sh/${repo}/`)
  }
}

async function tagAndPush(img, prefix) {
  await exec.exec(`docker tag ${img} ${prefix}${img}`)
}

run();