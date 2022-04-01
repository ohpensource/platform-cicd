import { argv } from "process";
import { areCommitsValid, getAllowedTypes } from "./validate.js";
import { getCommitsInsidePullRequest } from "../git-tools.js";
import { logError, logKeyValuePair, logAction } from "../logging.js";

const [base, head, types] = argv.slice(2);

// set Allowed types
const allowedTypes = getAllowedTypes(types);

logAction("");
logAction("CONVENTIONAL COMMITS CHECKER - This action will analyze whether your commits follow Conventional Commits.");
logAction("Please see: https://www.conventionalcommits.org/en/v1.0.0/ for more info.\n");
logAction("The list of allowed types for your configuration is:");
logKeyValuePair("allowedTypes", allowedTypes);
logAction("");

if (!base || !head) {
  logError("Please provide base ref and head ref");
  logKeyValuePair("base:", base);
  logKeyValuePair("head:", head);
  process.exit(1);
}

// get all commits from specific head branch.
const commits = getCommitsInsidePullRequest(base, `origin/${head}`);

const result = areCommitsValid(commits, allowedTypes);

if (result) {
  logAction("Your commits follow our commit conventions.");
  process.exit(0);
} else {
  logError("\nYour commits don't follow conventional commits convention!");
  logAction("  Please check documentation at: https://www.conventionalcommits.org/en/v1.0.0/");
  process.exit(1);
}