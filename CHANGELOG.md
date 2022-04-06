# :confetti_ball: 3.0.0.0 (2022-04-06T12:09:58.523Z)
- - -
## :boom: BREAKING CHANGES
* LANZ-2212 remove cloudformation actions (#82)
- - -
- - -
# :confetti_ball: 2.16.0.0 (2022-03-30T13:14:28.174Z)
- - -
## :hammer: Features
* LANZ-2154 add action to process cfn json conf files (#80)
- - -
- - -
# :confetti_ball: 2.15.0.1 (2022-03-21T12:12:15.616Z)
- - -
## :newspaper: Others
* update tfplan (#79)
- - -
- - -
# :confetti_ball: 2.15.0.0 (2022-03-15T08:27:31.855Z)
- - -
## :hammer: Features
* GMP-471 added support for setting github token, enhanced some default parameters\
- - -
- - -
# :confetti_ball: 2.14.0.3 (2022-03-08T16:15:40.006Z)
- - -
## :newspaper: Others
* refactor: LANZ-1576 enhance terraform scripts to better manage inputs (#77)
- - -
- - -
# :confetti_ball: 2.14.0.2 (2022-03-07T12:44:10.043Z)
- - -
## :newspaper: Others
* docs: LANZ-1775 include terraform actions documentation (#76)
- - -
- - -
# :confetti_ball: 2.14.0.1 (2022-03-07T12:00:08.835Z)
- - -
## :newspaper: Others
* ci: LANZ-1775 include token during cloning for semver step in cd workflow
* docs: LANZ-1775 fix table-of-contents for java-actions section
* ci: LANZ-1775 reset semver to latest tag 2.14.0.0
- - -
- - -
# :confetti_ball: 2.13.3.0 (2022-02-17T16:25:07.759Z)
- - -
## :bug: Fixes
* SPT-1 - order of params (#71)
- - -
- - -
# :confetti_ball: 2.13.2.0 (2022-02-17T16:05:49.602Z)
- - -
## :bug: Fixes
* SPT-1 - send github context parameters to bash script (#70)
- - -
- - -
# :confetti_ball: 2.13.1.0 (2022-02-17T11:43:43.462Z)
- - -
## :bug: Fixes
* SPT-1 - made file executable (#69)
- - -
- - -
# :confetti_ball: 2.13.0.0 (2022-02-15T15:51:02.587Z)
- - -
## :hammer: Features
* SPT-1 - added new action for creating deployment info file
* SPT-1 - added new action for creating deployment info file
* SPT-1 - make service group optional
* SPT-1 - added output
## :newspaper: Others
* docs: SPT-1 - action for creating deploy.info files
- - -
- - -
# :confetti_ball: 2.12.0.1 (2022-02-09T15:27:01.607Z)
- - -
## :newspaper: Others
* ci: LANZ-1664 remove version-prefix from current repo versioning (#67)
- - -
- - -
# :confetti_ball: 2.12.0.0 (2022-02-09T15:24:08.239Z)
- - -
## :hammer: Features
* LANZ-1664 add versionPrefix input to semver (#66)
- - -
- - -
# :confetti_ball: 2.11.0.6 (2022-02-07T11:49:49.923Z)
- - -
## :newspaper: Others
* docs: SPT-1 - updated documentation for the semver action
- - -
- - -
# :confetti_ball: 2.11.0.5 (2022-02-04T07:37:34.966Z)
- - -
## :newspaper: Others
* docs: LANZ-1622 include boy scout rule link in README.md file (#64)
- - -
- - -
# :confetti_ball: 2.11.0.4 (2022-02-03T20:32:21.079Z)
- - -
## :newspaper: Others
* ci: LANZ-1622 force cd workflow (#63)
- - -
- - -
# :confetti_ball: 2.11.0.1 (2022-02-03T15:08:41.520Z)
- - -
## :newspaper: Others
* SPT-1 - generate only three number versions to adhere to semantic: MAJOR.MINOR.PATCH (#58)
- - -
- - -
# :confetti_ball: 2.11.0.0 (2022-02-01T09:10:59.573Z)
- - -
## :hammer: Features
* SPT-1 - only generate version and change version.json file - do not yet commit as we want to change multiple files in one commit (#57)
- - -
- - -
# :confetti_ball: 2.10.1.4 (2022-01-26T14:42:33.325Z)
- - -
## :newspaper: Others
* test: LANZ-1518 forcing cd workflow (#56)
- - -
- - -
# :confetti_ball: 2.10.1.3 (2022-01-26T11:29:02.947Z)
- - -
## :newspaper: Others
* docs: LANZ-1518 add check-conventional-commits in README.md (#54)
- - -
- - -
# :confetti_ball: 2.10.1.2 (2022-01-26T10:07:30.164Z)
- - -
## :newspaper: Others
* docs: LANZ-1518 add semver-and-changelog in README.md (#51)
- - -
- - -
# :confetti_ball: 2.10.1.1 (2022-01-26T10:02:52.907Z)
- - -
## :newspaper: Others
* docs: LANZ-1518 add semver-and-changelog in README.md (#50)
- - -
- - -
# :confetti_ball: 2.10.1.0 (2022-01-21T13:08:54.156Z)
- - -
## :bug: Fixes
* INT-1368 Handle the credentials file properly to avoid clashing between different actions
- - -
- - -
# :confetti_ball: 2.10.0.0 (2022-01-20T12:56:04.774Z)
- - -
## :hammer: Features
* SPT-1 - fixed tfm plan (#48)
- - -
- - -
# :confetti_ball: 2.9.1.0 (2022-01-13T16:04:39.719Z)
- - -
## :bug: Fixes
* INT-1365 Put the content of temp.zip dir into archive, not the dir itself (#46)
- - -
- - -
# :confetti_ball: 2.9.0.0 (2022-01-13T12:30:28.134Z)
- - -
## :hammer: Features
* INT-1365 Add s3-destination-key and s3-object-key outputs to upload-zip-artifact action
## :bug: Fixes
* INT-1365 Fix typos in upload-zip-artifact
- - -
- - -
# :confetti_ball: 2.8.0.0 (2022-01-12T21:01:34.165Z)
- - -
## :hammer: Features
* LANZ-1454 add generic zip artifact up/download (#40)
## :bug: Fixes
* GMP-393 - improve and fix some scripts and provide some output custom actions parameters
* GMP-393 - improve and fix some scripts and provide some output custom actions parameters
## :newspaper: Others
* style: GMP-393 - reformat assume_role function in scripts
- - -
- - -
# :confetti_ball: 2.7.0.1 (2022-01-12T10:49:52.426Z)
- - -
## :newspaper: Others
* ci: INT-1367 Allow overriding nuget package version in nuget-pack-push (#44)
- - -
- - -
# :confetti_ball: 2.7.0.0 (2022-01-10T10:10:17.097Z)
- - -
## :hammer: Features
* SPT-148 Added new action nuget-pack-push
## :newspaper: Others
* chore: SPT-148 action minimal documentation
* chore: SPT-148 Moved action documentation to the right place.
- - -
- - -
# :confetti_ball: 2.6.0.0 (2021-12-23T11:06:17.680Z)
- - -
## :hammer: Features
* LANZ-1454 add generic zip artifact up/download (#40)
- - -
- - -
# :confetti_ball: 2.5.0.0 (2021-12-16T10:51:44.566Z)
- - -
## :hammer: Features
* SPT-148 Added new action nuget-pack-push (#38)
- - -
- - -
# :confetti_ball: 2.4.0.0 (2021-12-15T15:57:40.824Z)
- - -
## :hammer: Features
* GMP-392 omit merges in pull requests (#37)
- - -
- - -
# :confetti_ball: 2.3.7.0 (2021-12-08T21:02:19.664Z)
- - -
## :bug: Fixes
* GMP-366 tfm plan action (#35)
- - -
- - -
# :confetti_ball: 2.3.6.0 (2021-12-08T18:58:16.609Z)
- - -
## :bug: Fixes
* GMP-366 readme md syntax (#34)
- - -
- - -
# :confetti_ball: 2.3.5.0 (2021-12-08T18:51:57.016Z)
- - -
## :bug: Fixes
* GMP-366 var name, action input name (#33)
- - -
- - -
# :confetti_ball: 2.3.4.1 (2021-11-10T12:10:01.727Z)
- - -
## :newspaper: Others
* ci: GMP-336 autogenerate readme.md (#32)
- - -
- - -
# :confetti_ball: 2.3.4.0 (2021-11-02T14:15:33.296Z)
- - -
## :bug: Fixes
* GMP-323 improve feedback on ensure-commits-message-jira-ticket script (#30)
- - -
- - -
# :confetti_ball: 2.3.3.0 (2021-11-02T10:29:35.600Z)
- - -
## :bug: Fixes
* GMP-323 improve feedback on ensure-commits-message-jira-ticket script (#29)
- - -
- - -
# :confetti_ball: 2.3.2.0 (2021-11-02T09:09:23.960Z)
- - -
## :bug: Fixes
* GMP-323 improve feedback on ensure-conventional-commits script (#28)
- - -
- - -
# :confetti_ball: 2.3.1.0 (2021-10-29T11:51:14.275Z)
- - -
## :bug: Fixes
* GMP-320 specify artifacts prefix path (#27)
- - -
- - -
# :confetti_ball: 2.3.0.1 (2021-10-29T08:37:03.024Z)
- - -
## :newspaper: Others
* refactor: GMP-322 remove unused function inside tfm-apply.sh (#26)
- - -
- - -
# :confetti_ball: 2.3.0.0 (2021-10-28T10:45:25.455Z)
- - -
## :hammer: Features
* GMP-315 include -destroy option in terraform plan action (#24)
- - -
- - -
# :confetti_ball: 2.2.3.0 (2021-10-27T13:30:36.451Z)
- - -
## :bug: Fixes
* GMP-315 expose outputs after tfm-apply (#23)
- - -
- - -
# :confetti_ball: 2.2.2.0 (2021-10-27T13:05:28.341Z)
- - -
## :bug: Fixes
* GMP-315 terraform plan+apply (#22)
- - -
- - -
# :confetti_ball: 2.2.1.0 (2021-10-27T12:21:59.397Z)
- - -
## :bug: Fixes
* GMP-315 use absolute paths in tfm-plan (#21)
- - -
- - -
# :confetti_ball: 2.2.0.0 (2021-10-27T08:33:40.485Z)
- - -
## :hammer: Features
* GMP-315 include terraform validate action (#20)
- - -
- - -
# :confetti_ball: 2.1.0.0 (2021-10-21T16:05:32.907Z)
- - -
## :hammer: Features
* GMP-303 include tfm-plan and tfm-apply actions (#19)
- - -
- - -
# :confetti_ball: 2.0.1.0 (2021-10-21T08:23:49.941Z)
- - -
## :bug: Fixes
* GMP-304 SKIP CI => skip ci. To avoid recursive calls in main branches (#17)
- - -
- - -
# :confetti_ball: 2.0.0.0 (2021-10-21T08:11:23.649Z)
- - -
## :boom: BREAKING CHANGES
* GMP-304 incude user-name and user-email as mandatory parameters in semver action (#16)
- - -
- - -
# :confetti_ball: 1.0.0.0 (2021-10-20T11:59:01.267Z)
- - -
## :boom: BREAKING CHANGES
* GMP-304 include PAT as required argument into generate-version-and-release-notes action (#15)
- - -
- - -
# :confetti_ball: 0.6.0.0 (2021-09-23T13:09:01.350Z)
- - -
## :hammer: Features
* GMP-158 include generate-version-and-release-notes action (#14)
- - -
- - -
# :confetti_ball: 0.5.4.0 (2021-09-23T09:16:59.365Z)
- - -
## :bug: Fixes
* GMP-158 massive refactor and fixes (#13)
- - -
- - -
# :confetti_ball: 0.5.3.0 (2021-09-22T10:54:35.741Z)
- - -
## :bug: Fixes
* GMP-158 typo (#12)
- - -
- - -
# :confetti_ball: 0.5.2.0 (2021-09-22T10:33:05.467Z)
- - -
## :bug: Fixes
* GMP-158 correct .js extensions in javascript files (#11)
- - -
- - -
# :confetti_ball: 0.5.1.0 (2021-09-22T10:28:52.325Z)
- - -
## :bug: Fixes
* GMP-158 add shell property to action.yml (s) (#10)
- - -
- - -
# :confetti_ball: 0.5.0.0 (2021-09-22T10:18:07.935Z)
- - -
## :hammer: Features
* GMP-158 introduce actions for each script (#9)
- - -
- - -
# :confetti_ball: 0.4.2.1 (2021-09-22T09:09:22.943Z)
- - -
## :newspaper: Others
* refactor: GMP-158 action next to script (#8)
- - -
- - -
# :confetti_ball: 0.4.2.0 (2021-09-21T16:20:37.406Z)
- - -
## :bug: Fixes
* GMP-188 remove _common folder dependency (#7)
- - -
- - -
# :confetti_ball: 0.4.1.0 (2021-09-21T16:15:22.599Z)
- - -
## :bug: Fixes
* GMP-188 rename gh action (#6)
- - -
- - -
# :confetti_ball: 0.4.0.0 (2021-09-21T16:11:04.690Z)
- - -
## :hammer: Features
* GMP-188 adding build-dotnet-app folder (#5)
- - -
- - -
# :confetti_ball: 0.2.0.0 (2021-09-21T15:29:24.643Z)
- - -
## :hammer: Features
* GMP-188 hello world action (#3)
- - -
- - -
# :confetti_ball: 0.1.0.0 (2021-09-21T14:18:46.930Z)
- - -
## :hammer: Features
* GMP-188 initial setup
- - -
- - -
