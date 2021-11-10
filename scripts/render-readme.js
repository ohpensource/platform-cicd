// packages
import read from "fs-readdir-recursive";
import fs from "fs";
import yaml from "js-yaml";
import { markdownTable } from "markdown-table";

// constants
const actionsFolder = "../actions";
const readmeFile = "../README.md";

// functions
const logAction = (action) => console.log(`${action.toUpperCase()} ...`);
const logKeyValuePair = (key, value) => console.log(`    ${key}: ${value}`);
const logObject = (obj) => console.log(JSON.stringify(obj, null, 4));
const getMarkdown = (obj) => {
  let result = "";

  result += `## ${obj.name}\n`;
  result += `${obj.description}\n`;
  let table = [["name", "description", "required"]];
  for (const key of Object.keys(obj.inputs)) {
    const value = obj.inputs[key];
    table.push([key, value.description, value.required]);
  }
  result += `${markdownTable(table)}\n`;
  let withStatement = "  with:\n";
  for (const key of Object.keys(obj.withInputs)) {
    withStatement += `      ${key}: ${obj.withInputs[key]}\n`;
  }
  const example = `Example:
\`\`\`\`
- uses: ${obj.usesPath}@${obj.usesVersion}
${withStatement}
\`\`\`\`
  `;
  result += `${example}\n`;
  result += "- - -\n";

  return result;
};

// script
logAction("updating readme file");
logKeyValuePair("readme-file", readmeFile);
logKeyValuePair("actions-folder", actionsFolder);

let readmeContent = "";
read(actionsFolder)
  .filter((file) => file.endsWith(".yml"))
  .map((file) => {
    const content = fs.readFileSync(`${actionsFolder}/${file}`, "utf8");
    let obj = yaml.load(content);
    const actionPath = file.replace("/action.yml", "");
    obj.usesPath = `ohpensource/platform-cicd/actions/${actionPath}`;
    obj.usesVersion = "2.0.1.0";
    obj.withInputs = {};
    for (const key of Object.keys(obj.inputs)) {
      obj.withInputs[key] = "<your-input>";
    }
    const markdown = getMarkdown(obj);
    return markdown;
  })
  .forEach((content) => (readmeContent += `${content}\n`));
fs.writeFileSync(readmeFile, readmeContent);
