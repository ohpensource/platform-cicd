import * as fs from "fs";

export function getJsonFrom(file) {
  let jsonObject = {};
  if (fs.existsSync(file)) {
    jsonObject = JSON.parse(fs.readFileSync(file));
  }
  return jsonObject;
}

export function saveJsonTo(file, jsonObject) {
  fs.writeFileSync(file, jsonObject);
}

export function prettifyJsonObject(obj) {
  return JSON.stringify(obj, null, 4);
}
