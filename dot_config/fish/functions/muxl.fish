function _muxl_get_projects --description "internal: gets available tmuxinator projects for completion"
    set -l projects (
tmuxinator list | tail -n +2 | tr ' ' '\n' | awk 'NF')
    for proj in $projects
        if test -n "$proj"
            echo $proj
        end
    end
end

function muxl --description "Simplified wrapper for tmuxinator with completion"
    if test (count $argv) -eq 0 -o "$argv[1]" = list -o "$argv[1]" = ls -o "$argv[1]" = l
        _muxl_get_projects
        return
    end

    switch "$argv[1]"
        case start s
            if test (count $argv) -ge 2
                tmuxinator start "$argv[2]"
            else
                echo "Usage: muxl start <project_name>"
                return 1
            end

        case new open edit n o e
            if test (count $argv) -ge 2
                tmuxinator open "$argv[2]"
            else
                echo "Usage: muxl new <project_name>"
                return 1
            end

        case stop
            if test (count $argv) -ge 2
                tmuxinator stop "$argv[2]"
            else
                echo "Usage: muxl stop <project_name>"
                return 1
            end

        case delete del rm d
            if test (count $argv) -ge 2
                tmuxinator delete "$argv[2]"
            else
                echo "Usage: muxl delete <project_name>"
                return 1
            end

        case doctor
            tmuxinator doctor

        case help -h --help
            tmuxinator help

        case '*'
            if test (count $argv) -ge 1
                tmuxinator start "$argv[1]"
            else
                echo "Error: No project name specified."
                echo "Try 'muxl help' for more information."
                return 1
            end
    end
end

complete -c muxl -e

complete -c muxl -n __fish_use_subcommand -a "start s" -d "Start a tmuxinator project"
complete -c muxl -n __fish_use_subcommand -a "new open edit n o e" -d "Create or edit a tmuxinator project"
complete -c muxl -n __fish_use_subcommand -a stop -d "Stop a tmuxinator project"
complete -c muxl -n __fish_use_subcommand -a "delete del rm d" -d "Delete a tmuxinator project configuration"
complete -c muxl -n __fish_use_subcommand -a doctor -d "Diagnose tmuxinator configuration issues"
complete -c muxl -n __fish_use_subcommand -a "list ls l" -d "List all tmuxinator projects"
complete -c muxl -n __fish_use_subcommand -a "help -h --help" -d "Show tmuxinator help"

complete -c muxl -f \
    -n '__fish_seen_subcommand_from start s new open edit n o e stop delete del rm d' \
    -a '(_muxl_get_projects)' \
    -d "tmuxinator project name"

complete -c muxl -f \
    -n __fish_use_subcommand \
    -a '(_muxl_get_projects)' \
    -d "Project to start"
