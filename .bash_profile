# Add `~/.local/bin` to the `$PATH`
export PATH="$HOME/.local/bin:/usr/local/sbin:$PATH"

# Load the shell dotfiles, and then some:
# * ~/.bash_extra can be used for other settings you don’t want to commit.
for file in ~/.dotfiles/.{bash_prompt,bash_exports,bash_aliases,bash_functions} ~/.bash_extra; do
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

# Add tab completion for many Bash commands
if which brew &> /dev/null && [ -f "$(brew --prefix)/etc/bash_completion" ]; then
  source "$(brew --prefix)/etc/bash_completion"
elif [ -f /etc/bash_completion ]; then
  source /etc/bash_completion
fi

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh
