function chezmtree
    tree -L 2 (chezmoi source-path)
end

function task --description "Manage and prioritize academic tasks"
    ~/Scripts/bin/task-manager/check_tasks.py $argv
end
