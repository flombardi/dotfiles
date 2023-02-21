# Set HOMEBREW_PREFIX and PATH
if [ -e "/opt/homebrew/bin/brew" ]; then
  eval $(/opt/homebrew/bin/brew shellenv)
elif [ -e "/usr/local/bin/brew" ]; then
  eval $(/usr/local/bin/brew shellenv)
fi
if type brew &>/dev/null; then
  # Add Homebrew gnubin to `$PATH`
  for dir in ${HOMEBREW_PREFIX}/opt/{coreutils,gnu-sed,grep}/libexec; do
    test -d "${dir}/gnubin" && export PATH="${dir}/gnubin${PATH+:$PATH}"
    test -d "${dir}/gnuman" && export MANPATH="${dir}/gnuman${MANPATH+:$MANPATH}"
  done
  unset dir

  # Add Homebrew tab completion for many Bash commands
  test -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" && source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
fi

# pyenv
export PYENV_ROOT="${HOME}/.pyenv"
test -d "${HOME}/.pyenv/bin" && export PATH="${PYENV_ROOT}/bin${PATH+:$PATH}"
type pyenv &>/dev/null && eval "$(pyenv init -)"

# Node Version Manager
export NVM_DIR="${HOME}/.nvm"
test -f "${NVM_DIR}/nvm.sh" && source "${NVM_DIR}/nvm.sh"
test -f "{$NVM_DIR}/bash_completion" && source "${NVM_DIR}/bash_completion"

# Add `~/.local/bin` to the `$PATH`
test -d "${HOME}/.local/bin" && export PATH="${HOME}/.local/bin${PATH+:$PATH}"

# Load the shell dotfiles, and then some:
# * ~/.bash_extra can be used for other settings you don’t want to commit.
for file in ${HOME}/.dotfiles/.{bash_exports,bash_aliases,bash_functions} ${HOME}/.bash_extra; do
  test -f "${file}" && source "${file}"
done
unset file

# Enable some Bash features:
# * checkwinsize : Check the window size after each command and, if necessary,
#                  update the values of LINES and COLUMNS.
# * nocaseglob : Case-insensitive globbing (used in pathname expansion)
# * histappend : Append to the Bash history file, rather than overwriting it
# * cdspell : Autocorrect typos in path names when using `cd`
OPTIONS="checkwinsize nocaseglob histappend cdspell"
# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
[[ $BASH_VERSION == "4."* ]] && OPTIONS="${OPTIONS} autocd globstar"
for option in $OPTIONS; do shopt -s $option; done

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
test -f "${HOME}/.ssh/config" && complete -o "default" -o "nospace" -W "$(grep "^Host" "${HOME}/.ssh/config" | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh

# Load prompt dotfile
test -f "${HOME}/.dotfiles/.bash_prompt" && source "${HOME}/.dotfiles/.bash_prompt"

# iTerm2 intergration
test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
