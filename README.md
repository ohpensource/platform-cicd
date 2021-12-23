## create-iac-artifact

creates the iac artifact (.zip) for the provided iac folder
| name                | description                                  | required |
| ------------------- | -------------------------------------------- | -------- |
| region              | aws region name                              | true     |
| access-key          | access key                                   | true     |
| secret-key          | secret key                                   | true     |
| destination-account | where to store the artifact                  | true     |
| role-name           | role to assume to grant access to the bucket | true     |
| version             | service version                              | true     |
| service-name        | service name                                 | true     |
| iac                 | iac (terraform or cloudformation)            | true     |
| butcket-name        | bucket name                                  | true     |
Example:
````
- uses: ohpensource/platform-cicd/actions/artifacts/create-iac-artifact@2.0.1.0
  with:
      region: <your-input>
      access-key: <your-input>
      secret-key: <your-input>
      destination-account: <your-input>
      role-name: <your-input>
      version: <your-input>
      service-name: <your-input>
      iac: <your-input>
      butcket-name: <your-input>

````
  
- - -

## download-artifact

downloads the artifact(s) of an application and stores them locally into a folder
| name               | description                                  | required |
| ------------------ | -------------------------------------------- | -------- |
| region             | aws region name                              | true     |
| access-key         | access key                                   | true     |
| secret-key         | secret key                                   | true     |
| account            | where to store the artifact                  | true     |
| role-name          | role to assume to grant access to the bucket | true     |
| version            | service version                              | true     |
| service-name       | service name                                 | true     |
| iac                | iac (terraform or cloudformation)            | true     |
| bucket-name        | bucket name                                  | true     |
| destination-folder | folder where to store the artifact           | true     |
Example:
````
- uses: ohpensource/platform-cicd/actions/artifacts/download-artifact@2.0.1.0
  with:
      region: <your-input>
      access-key: <your-input>
      secret-key: <your-input>
      account: <your-input>
      role-name: <your-input>
      version: <your-input>
      service-name: <your-input>
      iac: <your-input>
      bucket-name: <your-input>
      destination-folder: <your-input>

````
  
- - -

## create-dotnet-lambda-artifact
creates the lambda artifact (.zip) for the provided dotnet application
| name                    | description                             | required |
| ----------------------- | --------------------------------------- | -------- |
| region                  | aws region name                         | true     |
| access-key              | access key                              | true     |
| secret-key              | secret key                              | true     |
| account                 | aws account id                          | true     |
| role-name               | role to assume                          | true     |
| version                 | version of the service                  | true     |
| service-name            | name of the service                     | true     |
| function-project-folder | folder where the function is located    | true     |
| function-project-name   | name of the function (.csproj file)     | true     |
| application-framework   | dotnet framework version for compiling  | true     |
| bucket-name             | bucket name where to store the artifact | true     |
Example:
````
- uses: ohpensource/platform-cicd/actions/artifacts/lambda/dotnet/create-dotnet-lambda-artifact@2.0.1.0
  with:
      region: <your-input>
      access-key: <your-input>
      secret-key: <your-input>
      account: <your-input>
      role-name: <your-input>
      version: <your-input>
      service-name: <your-input>
      function-project-folder: <your-input>
      function-project-name: <your-input>
      application-framework: <your-input>
      bucket-name: <your-input>

````
  
- - -

## upload-lambda-artifact-to-s3

| name                  | description | required |
| --------------------- | ----------- | -------- |
| region                |             | true     |
| access-key            |             | true     |
| secret-key            |             | true     |
| account               |             | true     |
| role-name             |             | true     |
| version               |             | true     |
| service-name          |             | true     |
| function-project-name |             | true     |
| artifact-folder       |             | true     |
| s3-bucket             |             | true     |
Example:
````
- uses: ohpensource/platform-cicd/actions/artifacts/lambda/upload-lambda-artifact-to-s3@2.0.1.0
  with:
      region: <your-input>
      access-key: <your-input>
      secret-key: <your-input>
      account: <your-input>
      role-name: <your-input>
      version: <your-input>
      service-name: <your-input>
      function-project-name: <your-input>
      artifact-folder: <your-input>
      s3-bucket: <your-input>

````
  
- - -

## create-or-update-stack
creates (or updates) an stack based on cfn inputs
| name                | description                                            | required |
| ------------------- | ------------------------------------------------------ | -------- |
| region              | aws region name                                        | true     |
| access-key          | access key                                             | true     |
| secret-key          | secret key                                             | true     |
| account             | aws account id                                         | true     |
| role-name           | role to assume                                         | true     |
| stack-name          | name of the stack to update                            | true     |
| template-body-path  | path where the cloudformation template file is located | true     |
| cfn-parameters-path | path where the cloudformation inputs are located       | true     |
Example:
````
- uses: ohpensource/platform-cicd/actions/aws/cloudformation/create-or-update-stack@2.0.1.0
  with:
      region: <your-input>
      access-key: <your-input>
      secret-key: <your-input>
      account: <your-input>
      role-name: <your-input>
      stack-name: <your-input>
      template-body-path: <your-input>
      cfn-parameters-path: <your-input>

````
  
- - -

## validate-cloudformation
validates (using aws api) a cloudformation yaml file
| name                | description                                           | required |
| ------------------- | ----------------------------------------------------- | -------- |
| cfn-template        | cloudformation file                                   | true     |
| region              | aws region name                                       | true     |
| access-key          | access key                                            | true     |
| secret-key          | secret key                                            | true     |
| destination-account | aws account id where to validate the cloudformation   | true     |
| role-name           | name of the role to assume in the destination account |          |
Example:
````
- uses: ohpensource/platform-cicd/actions/aws/cloudformation/validate-cloudformation@2.0.1.0
  with:
      cfn-template: <your-input>
      region: <your-input>
      access-key: <your-input>
      secret-key: <your-input>
      destination-account: <your-input>
      role-name: <your-input>

````
  
- - -

## create-s3-bucket
sets up the credentials in the current shell for an aws user
| name       | description     | required |
| ---------- | --------------- | -------- |
| region     | aws region name | true     |
| access-key | access key      | true     |
| secret-key | secret key      | true     |
| account    | aws account id  | true     |
| role-name  | role name       | true     |
| s3-bucket  | bucket name     | true     |
Example:
````
- uses: ohpensource/platform-cicd/actions/aws/s3/create-s3-bucket@2.0.1.0
  with:
      region: <your-input>
      access-key: <your-input>
      secret-key: <your-input>
      account: <your-input>
      role-name: <your-input>
      s3-bucket: <your-input>

````
  
- - -

## build-dotnet-app
builds the provided application (developed in dotnet)
| name     | description                                        | required |
| -------- | -------------------------------------------------- | -------- |
| app-path | the root path of the application (defaults to src) | true     |
Example:
````
- uses: ohpensource/platform-cicd/actions/builds/dotnet/build-dotnet-app@2.0.1.0
  with:
      app-path: <your-input>

````
  
- - -

## ensure-commits-message-jira-ticket
checks that all commits in a pull request contain a jira ticket
| name        | description                                          | required |
| ----------- | ---------------------------------------------------- | -------- |
| base-branch | name of the branch where the pull request goes to    | true     |
| pr-branch   | name of the branch where the pull request comes from | true     |
Example:
````
- uses: ohpensource/platform-cicd/actions/git/ensure-commits-message-jira-ticket@2.0.1.0
  with:
      base-branch: <your-input>
      pr-branch: <your-input>

````
  
- - -

## ensure-conventional-commits
checks that the commits in a pull request follow conventional commits
| name        | description                                          | required |
| ----------- | ---------------------------------------------------- | -------- |
| base-branch | name of the branch where the pull request goes to    | true     |
| pr-branch   | name of the branch where the pull request comes from | true     |
Example:
````
- uses: ohpensource/platform-cicd/actions/git/ensure-conventional-commits@2.0.1.0
  with:
      base-branch: <your-input>
      pr-branch: <your-input>

````
  
- - -

## generate-version-and-release-notes
generates semver and changelog.md after a pull request has been merge
| name       | description                                                 | required |
| ---------- | ----------------------------------------------------------- | -------- |
| user-email | email to sign the commit that will be pushed to main branch | true     |
| user-name  | name to sign the commit that will be pushed to main branch  | true     |
Example:
````
- uses: ohpensource/platform-cicd/actions/git/generate-version-and-release-notes@2.0.1.0
  with:
      user-email: <your-input>
      user-name: <your-input>

````
  
- - -

## nuget-pack-push
Packages and pushes NuGet packages
| name              | description                                                                    | required |
| ----------------- | ------------------------------------------------------------------------------ | -------- |
| nuget-feed-source | The source (repo) name of the NuGet feed to push to                            | true     |
| nuget-feed-url    | The URL of the NuGet feed to push to                                           | true     |
| username          | The username to use when reading/pushing to the NuGet feed                     | true     |
| password          | The password/PAT to use when pushing to the NuGet feed                         | true     |
| package-project   | The package name to push to the NuGet feed                                     | true     |
| package-folder    | The folder prefix where the project file is. Defaults to ./                    | false    |
| version-suffix    | The version suffix to append to the package version. Defaults to empty string. | false    |
Example:
````
- uses: ohpensource/platform-cicd/actions/packages/nuget/nuget-pack-push@2.0.1.0
  with:
      nuget-feed-source: <your-input>
      nuget-feed-url: <your-input>
      username: <your-input>
      password: <your-input>
      package-project: <your-input>
      package-folder: <your-input>
      version-suffix: <your-input>

````
  
- - -

## terraform-apply
applies a terraform configuration
| name                   | description                                               | required |
| ---------------------- | --------------------------------------------------------- | -------- |
| region                 | aws region name                                           | true     |
| access-key             | access key                                                | true     |
| secret-key             | secret key                                                | true     |
| terraform-folder       | folder where your terraform configuration is              | true     |
| backend-configuration  | file with additional backend configuration                | true     |
| terraform-plan-file    | An terraform plan file (previously created)               | true     |
| terraform-outputs-file | File where terraform will print the configuration outputs | false    |
Example:
````
- uses: ohpensource/platform-cicd/actions/terraform/tfm-apply@2.0.1.0
  with:
      region: <your-input>
      access-key: <your-input>
      secret-key: <your-input>
      terraform-folder: <your-input>
      backend-configuration: <your-input>
      terraform-plan-file: <your-input>
      terraform-outputs-file: <your-input>

````
  
- - -

## terraform-plan
plans a terraform configuration
| name                  | description                                                                    | required |
| --------------------- | ------------------------------------------------------------------------------ | -------- |
| region                | aws region name                                                                | true     |
| access-key            | access key                                                                     | true     |
| secret-key            | secret key                                                                     | true     |
| account               | aws account id                                                                 | true     |
| terraform-folder      | folder where your terraform configuration is                                   | true     |
| backend-configuration | file with additional backend configuration                                     | true     |
| terraform-var-file    | file with the terraform variables (.tfvars or .tfvars.json)                    | true     |
| terraform-plan-file   | file where terraform will put the proposed plan                                | true     |
| destroy-mode          | Plans a destroy action. false(default value)=>normal flow, true=>destroy mode. | false    |
Example:
````
- uses: ohpensource/platform-cicd/actions/terraform/tfm-plan@2.0.1.0
  with:
      region: <your-input>
      access-key: <your-input>
      secret-key: <your-input>
      account: <your-input>
      terraform-folder: <your-input>
      backend-configuration: <your-input>
      terraform-var-file: <your-input>
      terraform-plan-file: <your-input>
      destroy-mode: <your-input>

````
  
- - -

## terraform-validate
validates a terraform configuration
| name             | description                                                                                      | required |
| ---------------- | ------------------------------------------------------------------------------------------------ | -------- |
| terraform-folder | folder where your terraform configuration is                                                     | true     |
| use-backend      | boolean to specify if backend configuration needs to be considered. Accepted values: true, false | true     |
Example:
````
- uses: ohpensource/platform-cicd/actions/terraform/tfm-validate@2.0.1.0
  with:
      terraform-folder: <your-input>
      use-backend: <your-input>

````
  
- - -

## run-dotnet-tests
runs dotnet tests inside a .sln recursively
| name       | description                         | required |
| ---------- | ----------------------------------- | -------- |
| sln-folder | path where the .sln file is located | true     |
Example:
````
- uses: ohpensource/platform-cicd/actions/tests/dotnet/run-dotnet-tests@2.0.1.0
  with:
      sln-folder: <your-input>

````
  
- - -

