const git = require("./git.js");
const logger = require("./logging.js");
const convRegex = require("./constants.js");

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
    logger.logKeyValuePair("commit", commit);

    return messageOk;
  });

if (!ok) {
  process.exit(1);
}
