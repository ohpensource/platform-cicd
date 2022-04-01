/**
 * The purpose of this JavaScript file is to define the Conventional Commit constants according to
 * {@link https://www.conventionalcommits.org/en/v1.0.0/|Conventional Commits 1.0.0}
 */

/**
 * The regular expression to extract the structural elements of a commit message formatted according to
 * {@link https://www.conventionalcommits.org/en/v1.0.0/|Conventional Commits 1.0.0}
 */
export const convRegex =
  /(?<type>^[a-z]+)(?<scope>\([a-z,\-]+\))?(?<breaking>!)?(?<colon>:{1})(?<space> {1})(?<subject>.*)/;

/**
 * The default accepted types
 */
export const featType = "feat";
export const fixType = "fix";

export const builtInTypes = [
  featType,
  fixType
];