function muxl
    tmuxinator list | tail -n +2 | tr ' ' '\n' | awk 'NF'
end
