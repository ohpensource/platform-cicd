import { expect } from "chai";
import { defaultTypes } from "../ensure-conventional-commits/default-types.js";
import { checkType } from "../ensure-conventional-commits/validate.js";

describe("checkType", () => {
  it("should return true when it is included in allowedtypes", () => {
    expect(checkType("docs", defaultTypes)).to.be.true;
    expect(checkType("test", defaultTypes)).to.be.true;
    expect(checkType("refactor", defaultTypes)).to.be.true;
    expect(checkType("feat", defaultTypes)).to.be.true;
    expect(checkType("fix", defaultTypes)).to.be.true;
    expect(checkType("chore", defaultTypes)).to.be.true;
    expect(checkType("ci", defaultTypes)).to.be.true;
    expect(checkType("ci", ["feat", "fix", "chore", "ci"])).to.be.true;
  });
  it("should return false when it is not included in allowedtypes", () => {
    expect(checkType("angular", defaultTypes)).to.be.false;
    expect(checkType("react", defaultTypes)).to.be.false;
  });
});
