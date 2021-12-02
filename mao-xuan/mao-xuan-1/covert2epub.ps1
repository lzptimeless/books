$outputName = '"毛泽东选集 第一卷.epub"'
$metaFile = '".\title.yaml"'

function GetBookFiles {
    param ($dir)

    $files = ''
    Get-ChildItem $dir -File -Filter '*.md' | ForEach-Object -Process {
        if ($files.Length -gt 0) {
            $files += ' '
        }
        $files += '"' + (Join-Path $dir $_.Name) + '"'
    }

    Get-ChildItem $dir -Directory | ForEach-Object -Process {
        if ($files.Length -gt 0) {
            $files += ' '
        }
        $files += GetBookFiles (Join-Path $dir $_.Name)
    }

    $files
}

$bookFiles = GetBookFiles '.\'
Write-Output "Create EPUB: pandoc -o $outputName $metaFile $bookFiles"
Start-Process -NoNewWindow -FilePath 'pandoc' -ArgumentList "-o $outputName $metaFile $bookFiles"
Write-Output 'Success!'