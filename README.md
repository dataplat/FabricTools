<img src="images/FabricToolsLogo.png" alt="drawing" width="297"/>

# FabricTools PowerShell Module

**FabricTools** is a PowerShell module to able to do more with Microsoft Fabric and Power BI.
It allows for various administrative tasks to be automated and integrated into workflows.

> We are at an early stage of development and the module is in its **Public PREVIEW**.  
> Do NOT use it with Production environments.

## Features

- Manage Microsoft Fabric workspaces and datasets.
- Assign Microsoft Fabric workspaces to capacities.
- Retrieve and manipulate Microsoft Fabric tenant settings.
- Handle Microsoft Fabric access tokens for authentication.
- Suspend and resume Microsoft Fabric capacities.
- Fabric-friendly aliases for lots of the old PowerBI cmdlets

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

- PowerShell 5.1 or higher
- Access to PowerBI service and Azure subscription (for certain functions)
- Necessary permissions to manage PowerBI workspaces and Fabric capacities
- The following PowerShell modules: MicrosoftPowerBIMgmt, Az.Accounts, Az.Resources

### Installing

To install the FabricTools module, you can install it from the PowerShell Gallery:

```powershell
Install-Module FabricTools 
```

Or clone the repository to your local machine and import the module:

```powershell
# Clone the repository
git clone https://github.com/dataplat/FabricTools.git

# Import the module
Import-Module ./FabricTools/FabricTools.psm1
```



## Usage

Once imported, you can call any of the functions provided by the module. For example:

```powershell
# Assign a workspace to a capacity
Register-FabricWorkspaceToCapacity -WorkspaceId "Workspace-GUID" -CapacityId "Capacity-GUID"
```

Refer to the individual function documentation for detailed usage instructions.

Every now and again the authentication token might time out. Run this to get a new one:
```powershell
Set-FabricAuthToken
```

If you want to change user context run this:
```powershell
Set-FabricAuthToken -reset
```


## Release Notes

The entire history of changes to this module can be find here: [Release Notes](ReleaseNotes.md)


## Contributing

Contributions to FabricTools are welcome.  

> Note: In this early stage of development, we are working hard to build strong foundations for this module and further contribution guidance to ensure the quality of this code. **Therefore, please get in touch with us before you commit any code and create a PR.**

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Authors

- **Ioana Bouariu** - *Initial work* - [Jojobit](https://github.com/Jojobit)
- **Frank Geisler** - *Author of RTI functions* - [Frank Geisler](https://github.com/Frank-Geisler)
- **Kamil Nowinski** - *Refactoring, unification, further commands* - [NowinskiK](https://github.com/NowinskiK)

See also the list of [contributors](https://github.com/dataplat/FabricTools/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- GitHub Copilot and ChatGPT for helping with the documentation
- [**Rui Romano**](https://github.com/RuiRomano) - His work on a [Fabric PowerShell module](https://github.com/RuiRomano/fabricps-pbip) has been included into this module with his permission. Thanks, Rui!
