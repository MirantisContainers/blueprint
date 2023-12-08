# Makefile.ps1
# Windows alternative to a makefile to allow easier editing of the hugo based documentation on Windows

# Show help message
function Show-Help {
    Write-Output "help                  Show this help message",
                 "install               Install bctl on your system",
                 "docs                  Run the documentation website locally"
}

# Function to perform actions based on provided flag
function Execute-Target {
    param (
        [string]$target
    )

    switch ($target) {
        "install" {
            Write-Output "Installing bctl on Windows not supported!"
            #.\scripts\install.sh
        }
        "docs" {
            hugo server --source website/ --disableFastRender
        }
        "help" {
            Show-Help
        }
        default {
            Write-Output "Unknown target: $target"
        }
    }
}

# Show help message
if ($args.Count -eq 0) {
    Show-Help
    exit
}

# Parse command line arguments
$target = $args[0]

# Execute targets
Execute-Target -target $target