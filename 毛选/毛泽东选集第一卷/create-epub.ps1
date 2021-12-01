function GetBookFiles {
    param ($dir)

    $files = ''
    Get-ChildItem $dir -File -Filter '*.md' | ForEach-Object -Process {
        $files += ' ' + (Join-Path $dir $_.Name)
    }

    Get-ChildItem $dir -Directory | ForEach-Object -Process {
        $files += GetBookFiles (Join-Path $dir $_.Name)
    }

    $files
}

$bookFiles = GetBookFiles '.\'
Write-Output "Get all book files: $bookFiles"
Write-Output 'Create EPUB'
pandoc -o 毛泽东选集第一卷.epub .\title.yaml $bookFiles
Write-Output 'Success!'