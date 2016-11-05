# Franck’s dotfiles

## Install

The installation step and may overwrite existing dotfiles in your HOME
(macOS: requires the [XCode Command Line Tools](https://developer.apple.com/downloads)).

```bash
$ bash -c "$(curl -fsSL raw.github.com/flombardi/dotfiles/master/bootstrap.sh)"
```

N.B. If you wish to fork this project and maintain your own dotfiles, you must
substitute my username for your own in the above command and the 2 variables
found at the top of the `bootstrap.sh` script.

## Update

You should run the update when:

* You make a change to `~/.dotfiles/gitconfig` (the only file that is
  copied rather than symlinked).
* You want to pull changes from the remote repository.

Run the bootstrap.sh command:

```bash
$ ~/.dotfiles/bootstrap.sh
```

| Options |  |
| --- | ---- |
| `-h`, `--help` | Help |
| `--no-sync` | Suppress pulling from the remote repository |

### Add custom commands without creating a new fork

If `~/.bash_extra` exists, it will be sourced along with the other files. You can use this to add a few custom commands without the need to fork this entire repository, or to add commands you don’t want to commit to a public repository.

My `~/.bash_extra` looks something like this:

```bash
# Git credentials
# Not in the repository, to prevent people from accidentally committing under my name
GIT_AUTHOR_NAME="Franck Lombardi"
GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
git config --global user.name "$GIT_AUTHOR_NAME"
GIT_AUTHOR_EMAIL="franck@fakemail.com"
GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
git config --global user.email "$GIT_AUTHOR_EMAIL"
```

### Sensible macOS defaults

When setting up a new Mac, you may want to set some sensible macOS defaults:

```bash
./macos-init/macos.sh
```

### Install Homebrew formulae

When setting up a new Mac, you may want to install some common [Homebrew](http://brew.sh/) formulae (after installing Homebrew, of course):

```bash
./macos-init/brew.sh
```

## Feedback

Suggestions/improvements
[welcome](https://github.com/flombardi/dotfiles/issues)!

## Thanks to…

* [Mathias Bynens](https://mathiasbynens.be/) and his [dotfiles repository] (https://github.com/mathiasbynens/dotfiles)
* [Nicolas Gallagher](http://nicolasgallagher.com/) and his [dotfiles repository](https://github.com/necolas/dotfiles)
