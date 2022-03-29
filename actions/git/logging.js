export const logAction = (action) => {
  console.log("\x1b[37m%s\x1b[0m", action);
};

export const logKeyValuePair = (key, value) => {
  console.log("\x1b[37m%s\x1b[0m", key, JSON.stringify(value, null, 2));
};

export const logError = (action) => {
  console.error("\x1b[31m%s\x1b[0m", action);
};

export const logWarning = (action) => {
  console.error("\x1b[33m%s\x1b[0m", action);
};
