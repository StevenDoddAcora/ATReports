# Advanced PowerShell Bulk Restoration Script
param($SourcePath, $TargetPath)

Write-Host "ADVANCED POWERSHELL BULK OPERATIONS STARTING"

# Function to copy entire files when gap is significant
function Copy-HighGapFiles {
    param($sourceDir, $targetDir, $gapThreshold)
    
    Get-ChildItem -Path $targetDir -Recurse -Filter "*.al" | ForEach-Object {
        $relativePath = $_.FullName.Replace($targetDir, "").TrimStart("\")
        $sourcePath = Join-Path $sourceDir $relativePath
        
        if (Test-Path $sourcePath) {
            $ref = Get-Content $sourcePath
            $current = Get-Content $_.FullName
            $missing = Compare-Object $ref $current | Where-Object {$_.SideIndicator -eq "<="}
            $percentage = [math]::Round(($missing.Count / $ref.Count) * 100, 1)
            
            if ($percentage -ge $gapThreshold) {
                Write-Host "BULK COPYING: $($_.Name) - $percentage% missing (above $gapThreshold% threshold)"
                Copy-Item $sourcePath $_.FullName -Force
            }
        }
    }
}

# Copy files with >15% missing content
Copy-HighGapFiles -sourceDir $SourcePath -targetDir $TargetPath -gapThreshold 15

Write-Host "ADVANCED BULK OPERATIONS COMPLETE"
