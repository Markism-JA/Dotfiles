function l
{
    eza -la --icons @args
}

function ls
{
    if (Get-Command eza -ErrorAction SilentlyContinue)
    {
        eza --icons @args
    } else
    {
        Get-ChildItem @args
    }
}
