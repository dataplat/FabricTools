# Cmdlet maturity manifest. See docs/maturity-model.md.
#
# Levels 1-4 are computed from the source by .build/helpers/Get-CommandMaturity.ps1.
# This file holds only the judgement calls that cannot be computed.
@{
    # Cmdlets forced to level 0 whatever they score, e.g. because they wrap a preview API
    # or their parameters are expected to change. Value: the reason.
    Experimental    = @{
    }

    # Maintainer sign-off that lifts a level 4 (Integration Tested) cmdlet to level 5.
    # Value: who approved it and when, e.g. 'Approved by <maintainer>, 2026-12-01'.
    ProductionReady = @{
    }

    # Checks that do not apply to a cmdlet; they count as passed. Value: check names.
    Exemptions      = @{
        # Invoke-FabricRestMethod is the REST layer itself, so it calls Invoke-RestMethod directly.
        'Invoke-FabricRestMethod' = @('UsesFabricRestMethod', 'HandleResponse')
    }
}
