import { expect } from "chai";
import { defaultTypes } from "../ensure-conventional-commits/default-types.js";
import { validateCommit } from "../ensure-conventional-commits/validate.js";

describe("Conventional commits with default types", () => {
  const allowedCommits = [
    "feat!: add coventional commit script",
    "fix(shell): expect allowed and not allowed commits",
    "test: add testing packages and scripts",
    "ci: add workflow",
    "refactor: index.js simplified",
    "docs: documentation added",
    "perf(shell): login is quicker",
    "feat(shell,mfe): more than one scope",
  ];

  const notAllowedCommits = [
    "break: this is a new feature",
    "docu: documentation added",
    "feat:! new feature with breaking change",
    "fix:new ligin fix",
    "ci : new workflow",
    "feat(): new feature",
    "Feat: new feature camelcase",
    "fix1: bug is fixed",
    "cI(app)!: pipeline is green again",
    "feat(*): this is a new feature",
  ];
  it("should validate allowed commits", () => {
    allowedCommits.forEach((commit) => {
      const subject = {
        subject: commit,
      };
      expect(validateCommit(subject, defaultTypes)).to.be.true;
    });
  });

  it("should validate not allowed commits", () => {
    notAllowedCommits.forEach((commit) => {
      const subject = {
        subject: commit,
      };
      expect(validateCommit(subject, defaultTypes)).to.be.false;
    });
  });
});

describe("Conventional commits with custom types", () => {
  const customTypes = ["feat", "fix", "test", "ci", "css"];
  const allowedCommits = [
    "feat!: add coventional commit script",
    "fix(shell): expect allowed and not allowed commits",
    "test: add testing packages and scripts",
    "ci: add workflow",
    "css: css changed",
  ];

  const notAllowedCommits = [
    "break: this is a new feature",
    "docs: documentation added",
    "refactor: code refactored",
    "chore: regex changed",
    "perf: new performance",
  ];
  it("should validate allowed commits", () => {
    allowedCommits.forEach((commit) => {
      const subject = {
        subject: commit,
      };
      expect(validateCommit(subject, customTypes)).to.be.true;
    });
  });

  it("should validate not allowed commits", () => {
    notAllowedCommits.forEach((commit) => {
      const subject = {
        subject: commit,
      };
      expect(validateCommit(subject, customTypes)).to.be.false;
    });
  });
});
