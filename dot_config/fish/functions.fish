function chezmtree
    tree -L 2 (chezmoi source-path)
end

function task --description "Manage and prioritize academic tasks"
    python3 ~/Scripts/bin/check_tasks.py $argv
end
