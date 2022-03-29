import { expect } from "chai";
import { defaultTypes } from "../ensure-conventional-commits/default-types.js";
import { getAllowedTypes } from "../ensure-conventional-commits/validate.js";

describe("AllowedTypes", () => {
  it("should return default types when action types is null", () => {
    expect(getAllowedTypes(undefined)).to.deep.equal(defaultTypes);
    expect(getAllowedTypes(null)).to.deep.equal(defaultTypes);
  });
  it("should return custom types when action types is custom", () => {
    const customTypes = "test,break";
    const allowedTypes = ["test", "break", "feat", "fix"];

    expect(getAllowedTypes(customTypes)).to.deep.equal(allowedTypes);
  });
  it("should return custom types when action types is custom", () => {
    const customTypes = "test,break,fix";
    const allowedTypes = ["test", "break", "fix", "feat"];

    expect(getAllowedTypes(customTypes)).to.deep.equal(allowedTypes);
  });
});
