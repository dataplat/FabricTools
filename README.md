<img src="Fabtools.png" alt="drawing" width="200"/>

# Fabtools PowerShell Module

Fabtools is a PowerShell module to be able to able to do more with Microsoft Fabric and Power BI.
It allows for various administrative tasks to be automated and integrated into workflows.

## Features

- Manage PowerBI workspaces and datasets.
- Assign PowerBI workspaces to capacities.
- Retrieve and manipulate PowerBI tenant settings.
- Handle PowerBI access tokens for authentication.
- Suspend and resume Azure capacities.
- Fabric-friendly aliases for lots of the old PowerBI cmdlets

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

- PowerShell 5.1 or higher
- Access to PowerBI service and Azure subscription (for certain functions)
- Necessary permissions to manage PowerBI workspaces and Fabric capacities
- The following PowerShell modules: MicrosoftPowerBIMgmt, Az.Accounts, Az.Resources

### Installing

To install the Fabtools module, you can install it from the PowerShell Gallery:

```powershell
Install-Module Fabtools 
```

Or clone the repository to your local machine and import the module:

```powershell
# Clone the repository
git clone https://github.com/Jojobit/fabtools.git

# Import the module
Import-Module ./Fabtools/Fabtools.psm1
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


## [Release Notes](ReleaseNotes.md)
### Version 0.7.0.3:
- Fixed the functions related to checking, pausing and activating Fabric capacities in Azure

### Version 0.7.0.2:
- Fixed a bug that made the the module return an error on the first attempt to get data from the Rest API.

### Version 0.7.0.1:
- Removed the parameter outfile in the function Invoke-FabricAPIRequest, as it led to an error in PowerShell version 7.4

### Version 0.7.0:
- The official Rest API for Microsoft Fabric is now Public. This means that there are a lot of new possibilities for this module.
- After a great talk with Rui Romano, he's graciously allowed us to integrate the functions from his project: fabricps-pbip ([GitHub Repository](https://github.com/RuiRomano/fabricps-pbip)) into Fabtools.
- Lots of new functions to make it easier to work with Microsoft Fabric.
- It is now possible to export and import items from a workspace. Currently that includes reports (pbip), semantic models (datasets), spark jobs, and notebooks (ipynb).
- It is now possible to register and unregister a workspace to/from a capacity.
- Several functions have been rewritten to use the new fabric API endpoint rather than the old PowerBI API endpoint.


## Contributing

Contributions to Fabtools are welcome. Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, 
and the process for submitting pull requests to us.

## Authors

- **Ioana Bouariu** - *Initial work* - [Jojobit](https://github.com/Jojobit)


See also the list of [contributors](https://github.com/Jojobit/fabtools/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## Acknowledgments

- GitHub Copilot and ChatGPT for helping with the documentation
- [**Rui Romano**](https://github.com/RuiRomano) - His work on a [Fabric PowerShell module](https://github.com/RuiRomano/fabricps-pbip) has been included into this module with his permission. Thanks, Rui!
