# Makefile.ps1

# Show help message
if ($args.Count -eq 0) {
    Write-Output "Insufficient option(s) provided!",
                  "Should be: .\Makefile.ps1 [option]"
    exit
}

# Parse command line arguments
$target = $args[0]

# Execute targets
switch ($target) {
    "install" {
        Write-Output "Installing bctl on Windows not supported!"
        #.\scripts\install.ps1
    }
    "docs" {
        Write-Output "Running the documentation website locally"
        hugo server --source website/ --disableFastRender
    }
    default {
        Write-Output "Unknown target: $target"
    }
}
