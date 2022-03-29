import { expect } from "chai";
import { getConventionalCommitFields } from "../git.js";

describe("Git", () => {
  it("should return conventional commits fields if the commit is correct", () => {
    const commit = {
      subject: "feat(app)!: SPT-XXX new utility method",
      body: "body of the commit",
    };
    expect(getConventionalCommitFields(commit)).to.deep.equal({
      message: "feat(app)!: SPT-XXX new utility method",
      body: "body of the commit",
      subject: "SPT-XXX new utility method",
      type: "feat",
      scope: "(app)",
      breaking: "!",
    });
  });
  it("should return fields as null if the commit is incorrect", () => {
    const commit = {
      subject: "feat():! SPT-XXX new utility method",
      body: "body of the commit",
    };
    expect(getConventionalCommitFields(commit)).to.deep.equal({
      message: "feat():! SPT-XXX new utility method",
      body: "body of the commit",
      subject: null,
      type: null,
      scope: null,
      breaking: null,
    });
  });
});
