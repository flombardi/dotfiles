if type brew &>/dev/null; then
  HOMEBREW_PREFIX="$(brew --prefix)"

  # Add Homebrew bin to `$PATH`
  export PATH="$HOME/Library/Python/3.9/bin:/usr/local/sbin:$PATH"
  for pkg in coreutils gnu-sed grep; do
    if [[ -d "${HOMEBREW_PREFIX}/opt/${pkg}/libexec" ]]; then
      export PATH="${HOMEBREW_PREFIX}/opt/${pkg}/libexec/gnubin:$PATH"
      export MANPATH="${HOMEBREW_PREFIX}/opt/${pkg}/libexec/gnuman:$MANPATH"
    fi
  done

  # Add Homebrew tab completion for many Bash commands
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  fi
fi

# Add `~/.local/bin` to the `$PATH`
export PATH="$HOME/.local/bin:$PATH"

# Load the shell dotfiles, and then some:
# * ~/.bash_extra can be used for other settings you don’t want to commit.
for file in ~/.dotfiles/.{bash_exports,bash_aliases,bash_functions} ~/.bash_extra; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
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
[[ $BASH_VERSION == "4."* ]] && OPTIONS="$OPTIONS autocd globstar"

for option in $OPTIONS; do shopt -s $option; done

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh

# Load prompt dotfile
[ -r ~/.dotfiles/.bash_prompt ] && [ -f ~/.dotfiles/.bash_prompt ] && source ~/.dotfiles/.bash_prompt
