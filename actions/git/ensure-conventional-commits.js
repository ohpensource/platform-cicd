const git = require("./git.js");
const logger = require("./logging.js");

const convRegex =
  /(?<type>feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(?<scope>\([a-z,]+\))?(?<breaking>!)?(?<colon>:{1})(?<space> {1})(?<subject>.*)/gm;

const acceptablePrefixes = [
  "feat",
  "fix",
  "docs",
  "style",
  "refactor",
  "perf",
  "test",
  "build",
  "ci",
  "chore",
  "revert",
];

logger.logAction("ENSURING CONVENTIONAL COMMITS");
const baseBranch = process.argv[2];
logger.logKeyValuePair("base-branch", baseBranch);
const prBranch = process.argv[3];
logger.logKeyValuePair("pr-branch", prBranch);

let ok = git
  .getCommitsInsidePullRequest(baseBranch, `origin/${prBranch}`)
  .every((commit) => {
    logger.logKeyValuePair("commit", commit);
    const messageOk = convRegex.test(commit.subject);

    let result = {
      message: messageOk ? "OK" : "WRONG",
      documentation: "https://www.conventionalcommits.org/en/v1.0.0/",
      supportedPreffixes: acceptablePrefixes,
      examples: [
        "feat: awesome new feature",
        "fix!: awesome new feature",
        "feat(app)!: removing GET /ping endpoint",
      ],
    };
    logger.logKeyValuePair("result", result);

    return messageOk;
  });

if (!ok) {
  process.exit(1);
}
