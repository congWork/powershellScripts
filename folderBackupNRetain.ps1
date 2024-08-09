
# Define source and backup directories
$sourceDirectory = "C:\Users\cchen2\Desktop\congbox\temp\test\Source"
$backupDirectory = "C:\Users\cchen2\Desktop\congbox\temp\test\Backup"
# Specify the number of latest folders to keep
$numberOfFoldersToKeep = 2

$currentDateTime = Get-Date
$formattedDt = $currentDateTime.ToString("MMddyyyy-HHmmss")

$newFolderName = $("bk"+ $formattedDt )

# Check if source directory exists
if (-not (Test-Path -Path $sourceDirectory -PathType Container)) {
    Write-Host "Source directory does not exist."
    exit
}

# Check if backup directory exists, create if not
if (-not (Test-Path -Path $backupDirectory -PathType Container)) {
    Write-Host "Creating backup directory..."
    New-Item -ItemType Directory -Path $backupDirectory -ErrorAction Stop
}

# Try to copy files from source to backup directory
try {
    Write-Host "Copying files from '$sourceDirectory' to '$backupDirectory'..."


# Construct the full path for the destination folder
$newFolderPath = Join-Path -Path $backupDirectory -ChildPath $newFolderName

    # Copy files and folders recursively
    Copy-Item -Path $sourceDirectory -Destination $newFolderPath -Recurse -Force -ErrorAction Stop

    Write-Host "Backup completed successfully."
} 
catch {
    Write-Host "Error occurred during backup: $_"
}


# Specify the directory path
$directory = $backupDirectory;


# Get all folders in the directory
$folders = Get-ChildItem -Path $directory -Directory

# Sort folders by creation time (or LastWriteTime for modification time)
$sortedFolders = $folders | Sort-Object CreationTime -Descending

# Keep the last $numberOfFoldersToKeep folders
$foldersToDelete = $sortedFolders | Select-Object -Skip $numberOfFoldersToKeep

# Delete folders except for the last $numberOfFoldersToKeep folders
foreach ($folder in $foldersToDelete) {
    Write-Host "Deleting folder $($folder.FullName)..."
    Remove-Item -Path $folder.FullName -Recurse -Force
}
