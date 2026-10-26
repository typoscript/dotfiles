# ==============================================================================
# PowerShell Shared Aliases & Functions (Windows)
# ==============================================================================

function wd {
    Set-Location ([System.IO.Path]::Combine($env:USERPROFILE, "Desktop"))
}

function vrc {
    vim "$env:USERPROFILE\.vimrc"
}

function gpm {
    git push origin main @args
}

function ll {
    Get-ChildItem -Force @args
}

function py {
    python @args
}
