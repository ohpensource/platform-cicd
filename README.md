# PLATFORM-CICD

Repository containing Ohpen's Github actions. An easy-to-setup set of scripts and actions to help teams (and everybody that needs it) start working with their repositories and abstract as much cognitive load from them.

- [PLATFORM-CICD](#platform-cicd)
  - [code-of-conduct](#code-of-conduct)
  - [git](#git)
    - [semver-and-changelog](#semver-and-changelog)
    - [check-conventional-commits](#check-conventional-commits)
    - [check-jira-tickets-commits](#check-jira-tickets-commits)
  - [terraform](#terraform)
    - [validate](#validate)
    - [plan](#plan)
    - [apply](#apply)
  - [cloudformation](#cloudformation)
    - [get-properties-from-json](#get-properties-from-json)
  - [post-deployment](#post-deployment)
    - [update-deployment-info](#update-deployment-info)
  - [build-actions](#build-actions)
    - [dotnet](#dotnet)
      - [build-dotnet-app](#build-dotnet-app)
    - [java](#java)
      - [setup-maven](#setup-maven)
      - [run-maven](#run-maven)

## code-of-conduct

Go crazy on the pull requests :) ! The only requirements are:

> - Use [conventional-commits](#check-conventional-commits).
> - Include [jira-tickets](#check-jira-tickets-commits) in your commits.
> - Create/Update the documentation of the use case you are creating, improving or fixing. **[Boy scout](https://biratkirat.medium.com/step-8-the-boy-scout-rule-robert-c-martin-uncle-bob-9ac839778385) rules apply**. That means, for example, if you fix an already existing workflow, please include the necessary documentation to help everybody. The rule of thumb is: _leave the place (just a little bit)better than when you came_.

## git

### semver-and-changelog

This repository includes an action to semantically version your repository once a merge happens to the main branch. This is an example on how to use the action in your own repository:

```yaml
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
          skip-commit: "true"  This is for testing so you don't polute your git history. Default value is false.
          version-prefix: "v"  useful for repos that terraform modules where the versions are like "v0.2.4".
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

```json
{
  "version": "0.0.0.0"
}
```

- There are 2 optional parameters in this action:

> **skip-commit**: use it with value "true" if you want to prevent the action from commiting.
> **version-prefix**: use with a value different than an empty string ("beta-" or "v" for example) to have tags in the form of '{version-prefix}M.m.p'

### check-conventional-commits

This action checks that ALL commits present in a pull request follow [conventional-commits](https://www.conventionalcommits.org/en/v1.0.0/). Here you have an example of a complete workflow:

```yaml
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
- **build:**, **chore:**, **ci:**, **docs:**, **style:**, **refactor:**, **perf:**, **test:** --> There are scenarios where you are not affecting any of the previous semver numbers. Those could be: refactoring your code, reducing building time of your code, adding unit tests, improving documentation, ... For these cases, conventional-commits allows for more granular prefixes. A commit message example could be "docs: improve readme with examples".

:warning: Attention! If you set your action to work with 3 numbers, these prefixes will update the PATCH number.

### check-jira-tickets-commits

This action checks that ALL commits present in a pull request include a JIRA ticket. Useful for teams that require an extra level of traceability on their work and tasks. Here is an example:

```yaml
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

## terraform

### validate

This action performs a [_terraform validate_](https://www.terraform.io/cli/commands/validate) on the IAC that is specified. The (required) inputs are _terraform-folder_ and _use-backend_. Here is an example:

```yaml
name: CI
on:
  pull_request:
    branches: ["main"]
jobs:
  validate-iac:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: ohpensource/platform-cicd/actions/terraform/tfm-validate@2.2.0.0
        name: validate-terraform
        with:
          terraform-folder: "terraform"
          use-backend: "false"
```

### plan

This action performs a [_terraform plan_](https://www.terraform.io/cli/commands/plan) on the IAC that is specified. The (required) inputs are:

- _region_: aws region name.
- _access-key_: user access key to be used.
- _secret-key_: user secret key to be used.
- _terraform-folder_: folder where the terraform configuration is.
- _backend-configuration_: path of the tfvars file with backend configuration.
- _terraform-var-file_: tfvars file to use as variables input.
- _terraform-state-file_: File where terraform will write down the plan.

⚠️ Attention! Terraform will try to assume the deployment role in the destination AWS account. Such deployment will fail if the user is not allowed to assume such role.

Here is an example:

```yaml
name: CI
on:
  pull_request:
    branches: ["main"]
jobs:
  plan-team-branch-deployment:
    needs: [configure-team-branch-environment, download-artifacts]
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/download-artifact@v2
        with:
          name: deployment-folder
          path: deployment-folder
      - uses: actions/download-artifact@v2
        with:
          name: deployment-team-branch-conf
          path: deployment-team-branch-conf
      - uses: ohpensource/platform-cicd/actions/terraform/tfm-plan@2.3.0.0
        name: terraform plan
        with:
          region: $REGION
          access-key: $COR_AWS_ACCESS_KEY_ID
          secret-key: $COR_AWS_SECRET_ACCESS_KEY
          terraform-folder: "deployment-folder/terraform"
          backend-configuration: "deployment-team-branch-conf/backend.tfvars"
          terraform-var-file: "deployment-team-branch-conf/terraform.tfvars"
          terraform-state-file: "deployment-team-branch-plan/tfplan"
```

### apply

This action performs a [_terraform apply_](https://www.terraform.io/cli/commands/apply) on the IAC that is specified. The (required) inputs are:

- _region_: aws region name.
- _access-key_: user access key to be used.
- _secret-key_: user secret key to be used.
- _terraform-folder_: folder where the terraform configuration is.
- _backend-configuration_: path of the tfvars file with backend configuration.
- _terraform-plan-file_: terraform plan previously generated by 'plan' job.
- _terraform-outputs-file_: File where terraform will write down the outputs after applying.

⚠️ Attention! Terraform will try to assume the deployment role in the destination AWS account. Such deployment will fail if the user is not allowed to assume such role.

Here is an example:

```yaml
name: CI
on:
  pull_request:
    branches: ["main"]
jobs:
  apply-team-branch-plan:
    needs: [plan-team-branch-deployment]
    runs-on: ubuntu-latest
    steps:
      - uses: actions/download-artifact@v2
        with:
          name: deployment-folder
          path: deployment-folder
      - uses: actions/download-artifact@v2
        with:
          name: deployment-team-branch-plan
          path: deployment-team-branch-plan
      - uses: actions/download-artifact@v2
        with:
          name: deployment-team-branch-conf
          path: deployment-team-branch-conf
      - uses: ohpensource/platform-cicd/actions/terraform/tfm-apply@2.2.3.0
        name: terraform apply
        with:
          region: $REGION
          access-key: $COR_AWS_ACCESS_KEY_ID
          secret-key: $COR_AWS_SECRET_ACCESS_KEY
          terraform-folder: "deployment-folder/terraform"
          backend-configuration: "deployment-team-branch-conf/backend.tfvars"
          terraform-plan-file: "deployment-team-branch-plan/tfplan"
          terraform-outputs-file: "deployment-team-branch-outputs/outputs.json"
```

## cloudformation

### get-properties-from-json

This actions will parse input json file based on input parameter *json-file-path* and search for element matching input parameter *account-name* and exposes following outputs:

- environment
- account_id
- account_name
- cfn_main_file
- stack_name
- capabilities

expected json file format is following:

```json
{
    "cfn_main_file": "main.yaml",
    "stack_name": "awesome_stack",
    "capabilities": "CAPABILITY_AUTO_EXPAND,CAPABILITY_NAMED_IAM",
    "accounts": [
        {
            "environment": "acc",
            "account_name": "client-acc",
            "account_id": "012345678900"
        },
        {
            "environment": "acc",
            "account_name": "internal-acc",
            "account_id": "012345678901"
        },
        {
            "environment": "acc",
            "account_name": "external-acc",
            "account_id": "012345678902"
        }
    ]
}
```

example usage:

```yaml
name: CI
on:
  pull_request:
    branches: ["main"]
jobs:
    build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Get Properties From Json
        id: get-properties
        uses: ohpensource/platform-cicd/actions/aws/cloudformation/get-properties-from-json@2.15.0.x
        with:
          account-name: "account-name-you-need"
          json-file-path: ./params/matrix.json
      - name: output usage
        run: |
          echo ${{steps.get-properties.outputs.account_id}}
          echo ${{steps.get-properties.outputs.account_name}}
          echo ${{steps.get-properties.outputs.environment}}
          echo ${{steps.get-properties.outputs.cfn_main_file}}
          echo ${{steps.get-properties.outputs.stack_name}}
          echo ${{steps.get-properties.outputs.capabilities}}
```


## post-deployment

### update-deployment-info

Action ensures that performed deployments are document in git repository by creating deploy(-service-group).info files with current deployed version and date of deployment.
It creates file by convention in the folder: configuration/$CUSTOMER/$ENVIRONMENT/

## build-actions

### dotnet

#### build-dotnet-app

This action performs a _dotnet build_ on any solution (.sln file) inside the specified folder. The (required) input is _app-path_. Here is an example:

```yaml
name: CI
on:
  pull_request:
    branches: ["main"]
jobs:
    build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Add Dotnet NuGet Sources
        run: dotnet nuget add source ${{ secrets.COR_CICD_NUGET_FEED }} -n "GitHubPackages" -u ohp-github-svc -p ${{ secrets.CICD_GITHUB_PACKAGES_TOKEN }} --store-password-in-clear-text
      - uses: ohpensource/platform-cicd/actions/builds/dotnet/build-dotnet-app@0.6.0.0
        name: Build dotnet application
        with:
          app-path: "src"
```


### java

#### setup-maven

* Action prepares environment for running maven project for both runners: github and selfhosted.
* Includes restoring cache before build (can be disabled by restore-cache parameter).
* Action sets AWS_REGION env variable with default: eu-west-1

```yaml
- uses: ohpensource/platform-cicd/actions/builds/setup-maven
        name: Setup maven evnironment
        with:
          java-version: 11
          restore-cache: false
          maven-aws-access-key: <<AWS_ACCESS_KEY>>
          maven-aws-secret-key: <<AWS_SECRET_KEY>>
          account-id: <<ACCOUNT_ID>>
```

#### run-maven

* Action runs maven command with supplied parameters. 
* Includes saving cache after build. 
* In case that build needs to assume aws role use optional parameter: maven-aws-role.

```yaml
- uses: ohpensource/platform-cicd/actions/builds/run-maven
        name: Run maven command
        with:
          phases: clean install
          profiles: github
          parameters: >- 
            -DuseGitHub=true
            -Denable.deploy=false
          threads: 1C
          save-cache: true
          maven-aws-access-key: <<AWS_ACCESS_KEY>>
          maven-aws-secret-key: <<AWS_SECRET_KEY>>
          maven-aws-role: <<AWS_ROLE_TO_ASSUME>>
```
