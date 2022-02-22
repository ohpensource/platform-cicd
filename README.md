# PLATFORM-CICD

Repository containing Ohpen's Github actions. An easy-to-setup set of scripts and actions to help teams (and everybody that needs it) start working with their repositories and abstract as much cognitive load from them.

- [code-of-conduct](#code-of-conduct)
- [available-actions](#available-actions)
  - [semver-and-changelog](#semver-and-changelog)
  - [check-conventional-commits](#check-conventional-commits)
  - [check-jira-tickets-commits](#check-jira-tickets-commits)
- [Java actions](#Java actions)
  - [setup-maven](#setup-maven)
  - [run-maven](#run-maven)

## code-of-conduct

Go crazy on the pull requests :) ! The only requirements are:

> - Use [conventional-commits](#check-conventional-commits).
> - Include [jira-tickets](#check-jira-tickets-commits) in your commits.
> - Create/Update the documentation of the use case you are creating, improving or fixing. **[Boy scout](https://biratkirat.medium.com/step-8-the-boy-scout-rule-robert-c-martin-uncle-bob-9ac839778385) rules apply**. That means, for example, if you fix an already existing workflow, please include the necessary documentation to help everybody. The rule of thumb is: _leave the place (just a little bit)better than when you came_.

## available-actions

### semver-and-changelog

This repository includes an action to semantically version your repository once a merge happens to the main branch. This is an example on how to use the action in your own repository:

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
          skip-commit: "true" # This is for testing so you don't polute your git history. Default value is false.
          version-prefix: "v" # useful for repos that terraform modules where the versions are like "v0.2.4".
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
- Commit, tag and push changes in version.json and CHANGELOG.md (you can skip this part by setting parameter _skip-git-commit_ to true, for example when you want to change more files and push changes in one commit by yourself)
- You can also set up name to sign the commit with parameter: _user-name_. Default value is _GitHub Actions_
- The action will, by default, use MAJOR.MINOR.PATCH semantics to generate version number, if you want to use MAJOR.MINOR.PATCH.SECONDARY versioning, the version.json file in the root of your project have to contain 4 numbers separated by dot. For new applications it can look like this:

```yaml
{
  "version": "0.0.0.0"
}
```

- There are 2 optional parameters in this action:

> **skip-commit**: use it with value "true" if you want to prevent the action from commiting.

> **version-prefix**: use with a value different than an empty string ("beta-" or "v" for example) to have tags in the form of '{version-prefix}M.m.p'

### check-conventional-commits

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

### check-jira-tickets-commits

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

### update-deployment-info

Action ensures that performed deployments are document in git repository by creating deploy(-service-group).info files with current deployed version and date of deployment.
It creates file by convention in the folder: configuration/$CUSTOMER/$ENVIRONMENT/

## Java actions

### setup-maven

Action prepares environment for running maven project for both runners: github and selfhosted. Includes restoring cache after build.

```
- uses: ohpensource/platform-cicd/actions/builds/setup-maven
        name: Setup maven evnironment
        with:
          java-version: 11
          restore-cache: true
          maven-aws-access-key: <<AWS_ACCESS_KEY>>
          maven-aws-secret-key: <<AWS_SECRET_KEY>>
          account-id: <<ACCOUNT_ID>>
          maven-wagon-version: 1.4.5
```

### run-maven

Action runs maven command with supplied parameters. Includes saving cache after build.

```
- uses: ohpensource/platform-cicd/actions/builds/run-maven
        name: Run maven command
        with:
          phases: clean install
          profiles: github
          parameters: -DskipTests=true -Denable.deploy=false
          threads: 1C
          save-cache: true
          maven-aws-access-key: <<AWS_ACCESS_KEY>>
          maven-aws-secret-key: <<AWS_SECRET_KEY>>
          maven-aws-role: <<AWS_ROLE_TO_ASSUME>>
```