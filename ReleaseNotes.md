# Release Notes
## Version 0.7.0.4:
- Fix a bug where the Fabric API didn't have a result URI

## Version 0.7.0.3:
- Fixed the functions related to checking, pausing and activating Fabric capacities in Azure

## Version 0.7.0.2:
- Fixed a bug that made the the module return an error on the first attempt to get data from the Rest API.

## Version 0.7.0.1:
- Removed the parameter outfile in the function Invoke-FabricAPIRequest, as it led to an error in PowerShell version 7.4

## Version 0.7.0:
- The official Rest API for Microsoft Fabric is now Public. This means that there are a lot of new possibilities for this module.
- After a great talk with Rui Romano, he's graciously allowed us to integrate the functions from his project: fabricps-pbip ([GitHub Repository](https://github.com/RuiRomano/fabricps-pbip)) into Fabtools.
- Lots of new functions to make it easier to work with Microsoft Fabric.
- It is now possible to export and import items from a workspace. Currently that includes reports (pbip), semantic models (datasets), spark jobs, and notebooks (ipynb).
- It is now possible to register and unregister a workspace to/from a capacity.
- Several functions have been rewritten to use the new fabric API endpoint rather than the old PowerBI API endpoint.

## Version 0.6.0:
- Added Get-AllFabricCapacities function to get all capacities in a tenant.
- Added Invoke-FabricDatasetRefresh function to refresh a dataset.
- Changed the main functions to be with the Fabric prefix instead of Fab, and added Fab as aliases.
- Added IconUri to the manifest.
