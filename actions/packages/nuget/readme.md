You can use this to build, pack and publish your application's nuGet packages to the GitHub Packages feed easily.

The usage is like
```
- uses: ohpensource/platform-cicd/actions/packages/nuget/nuget-pack-push@2.5.0.0
    with:
        nuget-feed-source: "shared-pkg-dotnet"
        nuget-feed-url: "https://nuget.pkg.github.com/ohpen/index.json"
        username: ohp-github-svc
        password: ${{ secrets.CICD_GITHUB_PACKAGES_TOKEN }}
        package-project: "Ohpen.BusinessConfig.Client.csproj"
        package-folder: "src/Ohpen.BusinessConfig.Client"
        version-suffix: "preview"
```
The "**version-suffix**" parameter is optional, (_you can use it to generate preview packages in your branches like in the example. For stable packages just omit the parameter_)

The action will:
 - authenticate with GitHub Packages
 - add the nuGet source
 - dotnet restore
 - dotnet build -c release
 - dotnet pack
 - dotnet push it into the GitHub Packages feed.

The package version control must be done from the .csproj file using the following settings:
```
<PropertyGroup>
    <VersionPrefix>1.4.1</VersionPrefix>
    <VersionSuffix>$(VersionSuffix)</VersionSuffix>
    <RepositoryUrl>https://github.com/ohpen/shared-pkg-dotnet</RepositoryUrl>
</PropertyGroup>
```

If you don't specify "**RepositoryUrl**" in your project file, the action will fail.
If you don't specify "**VersionSuffix**" in your project file, the action will ignore the version suffix.

When you change anything in your package source code, you should manually change "**VersionPrefix**" to the new package version you want. If you don't do that, the package won't be uploaded to the feed (the action will skip existing packages, check the workflow log to check wether it went well or not)
 