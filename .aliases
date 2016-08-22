#!/usr/bin/env bash

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
	eval "$(dircolors -b)"
	colorflag="--color"
else # macOS `ls`
	export LSCOLORS=ExFxBxDxCxegedabagacad
	colorflag="-G"
fi

# List all files colorized
alias l="ls -Fh ${colorflag}"

# List all files colorized in long format
alias ll="ls -lFh ${colorflag}"

# List all files colorized in long format, including dot files
alias la="ls -alFh ${colorflag}"

# Always use color output for `ls`
alias ls="command ls ${colorflag}"

# Always enable colored `grep` output
# Note: `GREP_OPTIONS="--color=auto"` is deprecated, hence the alias usage.
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Enable aliases to be sudo’ed
alias sudo='sudo '

# Get week number
alias week='date +%V'

# IP addresses
alias publicip="dig +short myip.opendns.com @resolver1.opendns.com"

# Canonical hex dump; some systems have this symlinked
command -v hd > /dev/null || alias hd="hexdump -C"

# Recursively delete `.DS_Store` files
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

# One of @janmoesen’s ProTip™s
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
	command -v $method > /dev/null || alias "$method"="lwp-request -m '$method'"
done

if [[ "$OSTYPE" == "darwin"* ]]; then
	# Update installed Homebrew packages
	alias brewupdate='brew update; brew upgrade --all; brew cleanup'

	# macOS has no `md5sum`, so use `md5` as a fallback
	command -v md5sum > /dev/null || alias md5sum="md5"

	# macOS has no `sha1sum`, so use `shasum` as a fallback
	command -v sha1sum > /dev/null || alias sha1sum="shasum"

	# Merge PDF files
	# Usage: `mergepdf -o output.pdf input{1,2,3}.pdf`
	alias mergepdf='/System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py'

	# Lock the screen
	alias lock="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"
fi
