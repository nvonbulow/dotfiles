status is-interactive; or return 0

if functions -q __mise_env_eval
    return
end

if command -q mise
    command mise activate fish | source
else if test -x "$HOME/.local/bin/mise"
    "$HOME/.local/bin/mise" activate fish | source
end
