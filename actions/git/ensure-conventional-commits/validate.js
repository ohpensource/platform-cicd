import { convRegex } from "./constants.js";
import { logAction, logError, logWarning } from "../logging.js";
import { getConventionalCommitFields } from "../git-tools.js";
import { builtInTypes } from "./constants.js";
import { defaultTypes } from "./default-types.js"

export const validateCommit = (commit, allowedTypes) => {
  const { type, message } = getConventionalCommitFields(commit);

  const isValidCommit =
    convRegex.test(message) && checkType(type, allowedTypes);

  logCommit(commit.shortHash, message, isValidCommit);

  return isValidCommit;
};

export const areCommitsValid = (commits, allowedTypes) => {
  if (!commits || commits.length == 0 || (commits.length == 1 && !(commits[0].message))) {
    logWarning("No commits found.")
    return true;
  }
  return commits.every((commit) => validateCommit(commit, allowedTypes));
}

export const getAllowedTypes = (types) => {
  const typeArr = types ? types.split(",") : defaultTypes;

  const allowedTypes = [...new Set([...typeArr, ...builtInTypes])];

  return allowedTypes;
};

export const checkType = (type, allowedTypes) => allowedTypes.includes(type);

const logCommit = (shortHash, message, isValid) =>
  isValid
    ? logAction(`${shortHash}: ${message}`)
    : logError(`Invalid ${shortHash}: ${message}`);