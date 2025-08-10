# Batch Pattern Replacement for NAV to BC Conversion
param($SourcePath, $TargetPath)

# Common pattern replacements for 2018 NAV to BC conversion
$patterns = @{
    "if(" = "if ("
    "then(" = "then ("  
    "while(" = "while ("
    "TableData " = "TableData"
    "  CustDataExport" = " CustDataExport"
    "77000..77999" = "50900..50999"
    "Object 77" = "Object 50"
    "Codeunit 77" = "Codeunit 50"
    "Page 77" = "Page 50"
    "Report 77" = "Report 50"
}

Write-Host "POWERSHELL BATCH OPERATIONS STARTING"
Get-ChildItem -Path "$TargetPath\src" -Recurse -Filter "*.al" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    $originalContent = $content
    
    foreach ($pattern in $patterns.GetEnumerator()) {
        $content = $content -replace [regex]::Escape($pattern.Key), $pattern.Value
    }
    
    if ($content -ne $originalContent) {
        Set-Content -Path $_.FullName -Value $content
        Write-Host "Updated: $($_.Name)"
    }
}
Write-Host "BATCH OPERATIONS COMPLETE"
