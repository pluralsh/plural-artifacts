const name = process.env.APP_NAME;

module.exports = {
  branches: ["main"],
  tagFormat: name + '-v${version}',
  plugins: [
    [
      "@semantic-release/commit-analyzer",
      {
        preset: "conventionalcommits"
      }
    ],
    "@semantic-release/release-notes-generator",
    "@semantic-release/github"
  ],
  commitPaths: [
    name,
  ]
};
