# PLATFORM-CICD

Repository containing Ohpen's Github actions. An easy-to-setup set of scripts and actions to help teams (and everybody that needs it) start working with their repositories and abstract as much cognitive load from them.

- [code-of-conduct](#code-of-conduct)
- [available-actions](#available-actions)
  - [semver-and-changelog](#semver-and-changelog)
  - [check-conventional-commits](#check-conventional-commits)
  - [check-jira-tickets-commits](#check-jira-tickets-commits)

## code-of-conduct

Go crazy on the pull requests :) ! The only requirements are:

> - Use [conventional-commits](#check-conventional-commits).
> - Include [jira-tickets](#check-jira-tickets-commits) in your commits.
> - Create/Update the documentation of the use case you are creating, improving or fixing. **'Boy scout' rules apply**. That means, for example, if you fix an already existing workflow, please include the necessary documentation to help everybody. The rule of thumb is: _leave the place (just a little bit)better than when you came_.

## available-actions

#### semver-and-changelog

This repository includes an action to semantically version your repository once a merge happens to the main branch. All inputs are mandatory and this is an example on how to use the action in your own repository:

```
name: CD
on:
  push:
    branches: [main]
jobs:
  semver-changelog:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
        with:
          fetch-depth: 0
          token: ${{ secrets.CHECKOUT_WITH_A_SECRET_IF_NEEDED }}
      - uses: ohpensource/platform-cicd/actions/git/generate-version-and-release-notes@2.0.1.0
        name: semver & changelog
        with:
          user-email: "user@email.com"
          user-name: "GitHub Actions"
      - id: semver
        run: echo "::set-output name=service-version::$(cat ./version.json | jq -r '.version')"
    outputs:
      service-version: ${{ steps.semver.outputs.service-version }}
```

The action will:

- Analyse the commits from the pull request that has been merged to main branch and extract the necessary information.

:warning: Attention! You need to merge pull requests in a way their commits are present in the merge commit. To do so, merge your pull request as "squash".

- Summarise all the pull request changes into you CHANGELOG.md file.
- Deduce the new version from those commits (your commits must follow conventional-commits! Check out the _check-conventional-commits_ action).
- Tag your repository with the new version.

#### check-conventional-commits

This action checks that ALL commits present in a pull request follow [conventional-commits](https://www.conventionalcommits.org/en/v1.0.0/). Here you have an example of a complete workflow:

```
name: CI
on:
  pull_request:
    branches: ["main"]
jobs:
  check-conventional-commits:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
        with:
          fetch-depth: 0
      - uses: ohpensource/platform-cicd/actions/git/ensure-conventional-commits@0.6.0.0
        name: Ensure conventional commits
        with:
          base-branch: $GITHUB_BASE_REF
          pr-branch: $GITHUB_HEAD_REF
```

The action currently accepts the following prefixes:

- **break:** --> updates the MAJOR semver number. Used when a breaking changes are introduced in your code. A commit message example could be "_break: deprecate endpoint GET /parties V1_".
- **feat:** --> updates the MINOR semver number. Used when changes that add new functionality are introduced in your code. A commit message example could be "_feat: endpoint GET /parties V2 is now available_".
- **fix:** --> updates the PATCH semver number. Used when changes that solve bugs are introduced in your code. A commit message example could be "_fix: properly manage contact-id parameter in endpoint GET /parties V2_".
- **build:**, **chore:**, **ci:**, **docs:**, **style:**, **refactor:**, **perf:**, **test:** --> There are scenarios where you are not affecting any of the previous semver numbers. Those could be: refactoring your code, reducing building time of your code, adding unit tests, improving documentation, ... For these cases, conventional-commits allows for more granular prefixes.

#### check-jira-tickets-commits

This action checks that ALL commits present in a pull request include a JIRA ticket. Useful for teams that require an extra level of traceability on their work and tasks. Here is an example:

```
name: CI
on:
  pull_request:
    branches: ["main"]
jobs:
  check-jira-tickets-commits:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
        with:
          fetch-depth: 0
      - uses: ohpensource/platform-cicd/actions/git/ensure-commits-message-jira-ticket@0.6.0.0
        name: Ensure Jira ticket in all commits
        with:
          base-branch: $GITHUB_BASE_REF
          pr-branch: $GITHUB_HEAD_REF
```

The action essentially scans your commit messages [looking](https://stackoverflow.com/questions/19322669/regular-expression-for-a-jira-identifier) for JIRA tickets. In case a commit has no ticket, the action will fail.
