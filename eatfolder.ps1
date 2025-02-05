

# ╔═══════════════════════════════════════════════════════════════════════╗
# ║                                                                       ║
# ║                     _             ___       _      _                  ║
# ║       /\/\    __ _ | | __ ___    / __\___  | |  __| |  ___  _ __      ║
# ║      /    \  / _` || |/ // _ \  / _\ / _ \ | | / _` | / _ \| '__|     ║
# ║     / /\/\ \| (_| ||   <|  __/ / /  | (_) || || (_| ||  __/| |        ║
# ║     \/    \/ \__,_||_|\_\\___| \/    \___/ |_| \__,_| \___||_|        ║
# ║                                                                       ║
# ╚═══════════════════════════════════════════════════════════════════════╝


# ╔════════════════════════════════════════════════════════════════════════════════════════╗
# ║                                                                                        ║
# ║     Run this script and it takes all the files and creates a folder with the year,     ║
# ║     month and day and then moves the files made on that day into the appropriate       ║
# ║     folders.                                                                           ║
# ║                                                                                        ║
# ║     Usage: ./makefolder.sh                                                             ║
# ║         creates a folder for each date the files were made                             ║
# ║         Moves each file into it's appropriate folder                                   ║
# ║         Doesn't move the script into a folder, leaves it in it's current folder        ║
# ║     for use later                                                                      ║
# ║                                                                                        ║
# ╚════════════════════════════════════════════════════════════════════════════════════════╝



# ┌───────────────────────────────┐
# │     Timestamp a log entry     │
# └───────────────────────────────┘
function Write-Log {
    $timestamp = Get-Date -Format "HH:mm:ss"
    Write-Host "[$timestamp] - $args"
}



# ┌──────────────────────────────────┐
# │     Defining some variables      │
# └──────────────────────────────────┘
$s = 1  # You can adjust this value as needed
$files = Get-ChildItem -File | Where-Object { $_.Name -ne 'makefolder.ps1' }




# ┌───────────────────────────┐
# │     Starting the loop     │
# └───────────────────────────┘
foreach ($file in $files) {
    # Get the 'Date Modified' property and format it as 'yyyy-MM-dd'
    $dateModified = $file.LastWriteTime.ToString('yyyy-MM-dd')

    # Define the folder name based on the date modified
    $folderName = Join-Path -Path (Get-Location) -ChildPath $dateModified

    # Check if the folder exists, create it if it does not
    if (-not (Test-Path -Path $folderName)) {
        Write-Log "Creating folder '$folderName'"
        New-Item -ItemType Directory -Path $folderName
    }

    # Define the destination path for the file
    $destinationPath = Join-Path -Path $folderName -ChildPath $file.Name

    # Move the file to the new folder, overwriting if the file already exists
    Write-Log "Moving file '$($file.Name)' to folder '$folderName'"
    Move-Item -Path $file.FullName -Destination $destinationPath -Force

    # Delay for $s seconds
    Start-Sleep -Seconds $s
}



# ┌──────────────────┐
# │     All done     │
# └──────────────────┘
Write-Log "Files have been organized by their 'Date Modified'. The script itself was not moved."
