#!/usr/bin/fish

bat cache --build

# on OS X with GPGTools, comment out the next line:

# Ensure that GPG Agent is used as the SSH agent
set -e SSH_AUTH_SOCK
set -U -x SSH_AUTH_SOCK ~/.gnupg/S.gpg-agent.ssh
set GPG_TTY $(tty)
export GPG_TTY
if [ -f "$HOME/.gpg-agent-info" ]; then
    . "$HOME/.gpg-agent-info"
    export GPG_AGENT_INFO
    export SSH_AUTH_SOCK
end

set -gx EDITOR micro
git config --global core.editor micro
