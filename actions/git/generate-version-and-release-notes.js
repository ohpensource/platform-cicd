import * as child from "child_process";
import * as fs from "fs";
import { convRegex } from "./ensure-conventional-commits/constants.js";
import * as git from "./git-tools.js";
import * as logger from "./logging.js";
import * as files from "./file-tools.js";
import { featType } from "./ensure-conventional-commits/constants.js";
import { fixType } from "./ensure-conventional-commits/constants.js";
import { breakType } from "./ensure-conventional-commits/default-types.js";

const noneType = "none";

const skipGitCommit = process.argv[2];
const versionPrefix = process.argv[3];

const versionFile = "version.json";
const changelogFile = "CHANGELOG.md";

// ------------------ //
// ----- SCRIPT ----- //
// ------------------ //
logger.logAction("GETTING MERGE COMMIT");
let lastCommit = git.getLastCommit();
logger.logKeyValuePair("commit", lastCommit);

logger.logAction("GETTING CHANGES");
let changes = lastCommit.body
  .split("\n")
  .filter((block) => block.startsWith("* "))
  .map((block) => getChange(block.replace("* ", "")));
if (changes.length === 0) {
  changes.push(getChange(lastCommit.subject));
}
logger.logKeyValuePair("changes", changes);

logger.logAction("GETTING PREVIOUS VERSION");
let versionFileContent = files.getJsonFrom(versionFile);
let previousVersion = getPreviousVersionAsText(versionFileContent);
logger.logKeyValuePair("previous-version", previousVersion);

logger.logAction("GETTING NEW VERSION");
let newVersion = getUpdatedVersion(previousVersion, changes);
logger.logKeyValuePair("new-version", newVersion);

logger.logAction("UPDATING VERSION FILE");
files.saveJsonTo(
  versionFile,
  files.prettifyJsonObject({ version: newVersion })
);

logger.logAction("UPDATING CHANGELOG FILE");
updateChangelogFile(newVersion, changes);

if (skipGitCommit !== "true") {
  logger.logAction("COMMITTING AND TAGGING");
  commitAndTag(`${versionPrefix}${newVersion}`);
}

// --------------------- //
// ----- FUNCTIONS ----- //
// --------------------- //
function updateChangelogWith(changelog, title, changeContents) {
  if (changeContents.length > 0) {
    changelog += `${title}`;
    changeContents.forEach((content) => {
      changelog += content;
    });
  }
  return changelog;
}
function getUpdatedVersion(version, changes) {
  let versionFileContent = version.split(".");
  let major = parseInt(versionFileContent[0], 10);
  let minor = parseInt(versionFileContent[1], 10);
  let patch = parseInt(versionFileContent[2], 10);
  let secondary = 0;
  if (versionFileContent.length > 3) {
    secondary = parseInt(versionFileContent[3], 10);
  }

  let newMajor = 0;
  let newMinor = 0;
  let newPatch = 0;
  let newSecondary = 0;
  if (changes.some((change) => change.type === breakType)) {
    newMajor = major + 1;
    newMinor = 0;
    newPatch = 0;
    newSecondary = 0;
  } else if (changes.some((change) => change.type === featType)) {
    newMajor = major;
    newMinor = minor + 1;
    newPatch = 0;
    newSecondary = 0;
  } else if (
    changes.some((change) => change.type === fixType) ||
    versionFileContent.length === 3
  ) {
    newMajor = major;
    newMinor = minor;
    newPatch = patch + 1;
    newSecondary = 0;
  } else {
    newMajor = major;
    newMinor = minor;
    newPatch = patch;
    newSecondary = secondary + 1;
  }

  if (versionFileContent.length === 3) {
    return `${newMajor}.${newMinor}.${newPatch}`;
  } else {
    return `${newMajor}.${newMinor}.${newPatch}.${newSecondary}`;
  }
}
function getChange(line) {
  let matchResult = line.match(convRegex);
  let changeFields = {
    type: null,
    breaking: null,
    subject: null
  }

  if (matchResult)
    changeFields = matchResult.groups;

  const { type, breaking, subject } = changeFields;
  
  if (type === breakType || breaking) {
    return {
      type: breakType,
      content: subject,
    };
  } else if (type === featType || type === fixType) {
    return {
      type: type,
      content: subject,
    };
  } else {
    return {
      type: noneType,
      content: subject,
    };
  }
}
function getPreviousVersionAsText(versionFileContent) {
  let previousVersion = "";
  if (versionFileContent.version) {
    previousVersion = versionFileContent.version;
  } else {
    previousVersion = "0.0.0";
  }
  return previousVersion;
}
function updateChangelogFile(newVersion, changes) {
  let changelog = `# :confetti_ball: ${newVersion} (${new Date().toISOString()})\n`;
  changelog += "- - -\n";
  changelog = updateChangelogWith(
    changelog,
    "## :boom: BREAKING CHANGES\n",
    changes
      .filter((change) => change.type == breakType)
      .map((change) => `* ${change.content}\n`)
  );
  changelog = updateChangelogWith(
    changelog,
    "## :hammer: Features\n",
    changes
      .filter((change) => change.type == featType)
      .map((change) => `* ${change.content}\n`)
  );
  changelog = updateChangelogWith(
    changelog,
    "## :bug: Fixes\n",
    changes
      .filter((change) => change.type == fixType)
      .map((change) => `* ${change.content}\n`)
  );
  changelog = updateChangelogWith(
    changelog,
    "## :newspaper: Others\n",
    changes
      .filter((change) => change.type == noneType)
      .map((change) => `* ${change.content}\n`)
  );
  changelog += "- - -\n";
  changelog += "- - -\n";
  console.log(changelog);
  let previousChangelog = "";
  try {
    previousChangelog = fs.readFileSync(changelogFile, "utf-8");
  } catch (error) {
    previousChangelog = "";
  }
  fs.writeFileSync(changelogFile, `${changelog}${previousChangelog}`);
}
function commitAndTag(tagContent) {
  child.execSync(`git add ${versionFile}`);
  child.execSync(`git add ${changelogFile}`);
  child.execSync(`git commit -m "[skip ci] Bump to version ${tagContent}"`);
  child.execSync(`git tag -a -m "Tag for version ${tagContent}" ${tagContent}`);
  child.execSync(`git push --follow-tags`);
}
