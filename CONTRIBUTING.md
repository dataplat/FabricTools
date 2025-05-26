# Contributing

## Welcome

Before we go any further, thanks for being here. Thanks for using the module and especially thanks for being here and looking into how you can help!

## Important resources

- docs TODO: link to docs
- bugs TODO: link to issues issue template
- communicate via issues, PRs, and discussions as well as the project

## Develop & Build

We are using the [Sampler](https://github.com/gaelcolas/Sampler) Powershell Module to structure our module. This makes it easier to develop and test the module locally.

The workflow for using this and developing the code is shown below.

1. Download or clone the repo locally and create a new branch to develop on

   ```PowerShell
   git checkout -b newStuff # give it a proper name!
   ```

2. Make sure you have the latest Microsoft.PowerShell.PSResourceGet module

   ```PowerShell
   -- Find the latest version on the gallery
   Find-Module Microsoft.PowerShell.PSResourceGet

   -- Install side-by-side
   Install-Module Microsoft.PowerShell.PSResourceGet -Force
   ```

3. Develop your updates in the source directory

   You should also resolve all dependencies before you start developing. This will ensure that you have all the required modules installed and loaded into your session.

   ```PowerShell
   .\build.ps1 -ResolveDependency -Tasks noop -UsePSResourceGet
   ```

   | :heavy_exclamation_mark: **Important**        |
   | :-------------------------------------------- |
   | **YOU MUST DEVELOP IN THE SOURCE DIRECTORY.** |

   This is important because the build process will create a new folder in the root of the repository called `output` and this is where the module will be built and loaded from.

   If you change the code in the output folder and then build the module again, it will overwrite the changes you made.

   Ask Rob how he knows this!

4. Use GitHub CoPilot to write your commit messages by clicking on the sparkles in the commit message box. This will generate a commit message based on the changes you made. You can then edit the message to make it more descriptive if you want. This uses the prompt in the `.github\copilot-commit-message-instructions.md` file.

   Add this to your VS Code settings to enable it:

   ```json
   "github.copilot.chat.commitMessageGeneration.instructions": [
           {
               "file": ".github/copilot-commit-message-instructions.md"
           }
   ],
   ```

5. Build the module. From the root of the repository run the following command:

   ```PowerShell
   ./build.ps1 -Tasks build
   ```

   This will build the module and create a new folder in the root of the repository called `output`. It will also load the new module into your current session.

6. **AFTER** building, you can then run the Pester tests to ensure that everything is working as expected. The tests are located in the `tests` folder and can be run using the following command:

   ```PowerShell
   Invoke-Pester ./tests/
   ```

   This will run all the tests in the `tests` folder and output the results to the console. You can also run specific tags such as `FunctionalQuality`, `TestQuality`, `HelpQuality`.

7. You can also simulate the deployment testing by running the following command:

   ```PowerShell
   ./build.ps1 -Tasks build,test
   ```
8. Once you are ready to submit your changes for review please ensure that you update the `CHANGELOG.md` file with a summary of your changes. This is important as it helps us keep track of what has changed in the module and makes it easier for users to see what has been added or changed.

   You can use the [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) format for this.
   
   Please add your changes under the `Unreleased` section and then create a new section for the next release. PLease use human readable titles for the changes, such as `Added`, `Changed`, `Fixed`, `Deprecated`, `Removed`, and `Security`.
   For example:

   ```markdown
   ## [Unreleased]
   ### Added
   - Added new function to manage Fabric workspaces.
   ### Changed
   - Updated documentation for `Get-FabricAPIClusterURI`.
   ### Fixed
   - Fixed issue with `New-FabricDataPipeline` not working correctly.
   ```
9. Once you are happy with your code and you have updated the changelog, push your branch to GitHub and create a PR against the repo.

## Thanks!

We will review your PR and get back to you as soon as we can. We are all volunteers and do this in our spare time, so please be patient with us. We will try to get back to you within a week, but it may take longer if we are busy.

If you have any questions or need help, please feel free to reach out to us on the [GitHub Discussions](https://github.com/dataplat/FabricTools/discussions)

## How to submit changes

TODO:
Pull Request protocol etc. You might also include what response they'll get back from the team on submission, or any caveats about the speed of response.

## How to report a bug

TODO:
Bugs are problems in code, in the functionality of an application or in its UI design; you can submit them through "bug trackers" and most projects invite you to do so, so that they may "debug" with more efficiency and the input of a contributor. Take a look at Atom's example for how to teach people to report bugs to your project.

## Templates

TODO:
in this section of your file, you might also want to link to a bug report "template" like this one here which contributors can copy and add context to; this will keep your bugs tidy and relevant.

## Style Guide

TODO:
include extensions and vscode settings we use to keep things neat

## Code of Conduct

This project follows a Code of Conduct to ensure a welcoming, respectful, and inclusive environment for all contributors, regardless of background or identity. Contributors are expected to use inclusive language, respect differing viewpoints, and respond to feedback constructively. Unacceptable behaviors, such as harassment, discrimination, or publishing others' private information, will not be tolerated. Project maintainers are responsible for enforcing these standards fairly and may remove or ban individuals who violate them. This Code applies in all project spaces and in any public context where someone represents the project. Reports of misconduct will be handled confidentially and seriously. You can read the full code of conduct [here](https://github.com/dataplat/FabricTools/blob/sampler/CODE_OF_CONDUCT.md).

| :heavy_exclamation_mark: **Important** |
| :------------------------------------- |
| **BE EXCELLENT TO EACH OTHER**         |

Do I need to say more? If your behaviour or communication does not fit into this statement, we do not wish for you to help us.
