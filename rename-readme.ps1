# Navigate to your project root
Set-Location "C:\Users\moham\OneDrive\Documents\GitHub\100-Days-Of-DevOps-KodeKloud-Solutions-Explanation"

# Find all files exactly named README.MD (case-sensitive)
Get-ChildItem -Recurse -File | Where-Object { $_.Name -ceq "README.MD" } | ForEach-Object {
    $folder = $_.Directory.FullName
    $oldName = $_.Name
    $newName = "README.md"

    Write-Host "Found README.MD in folder: ${folder}"

    # Change to the folder and use git mv
    Push-Location $folder

    try {
        git mv "$oldName" "$newName"
        Write-Host "  Renamed to README.md" -ForegroundColor Green
    }
    catch {
        Write-Host "  Error renaming file in ${folder}: $($_.Exception.Message)" -ForegroundColor Red
    }

    Pop-Location
}

Write-Host "`nDone! All README.MD files have been renamed to README.md"
