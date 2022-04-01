/**
 * Following the point 4 from {@link https://www.conventionalcommits.org/en/v1.0.0/|Conventional Commits 1.0.0}
 * several commit types are allowed. The content of this file should describe the default commit types allowed
 * in the organization.
 */

/**
 * The default commit types accepted. (See point 4 from {@link https://www.conventionalcommits.org/en/v1.0.0/|Conventional Commits 1.0.0})
 */
import { featType } from "./constants.js";
import { fixType } from "./constants.js";

export const breakType = "break";

export const defaultTypes = [
    breakType,
    featType,
    fixType,
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
    