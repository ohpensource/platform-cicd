export const convRegex =
  /(?<type>feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(?<scope>\([a-z,]+\))?(?<breaking>!)?(?<colon>:{1})(?<space> {1})(?<subject>.*)/;
