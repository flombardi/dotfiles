#!/bin/bash

DOTFILES_DIRECTORY="${HOME}/.dotfiles"
DOTFILES_TARBALL_PATH="https://github.com/flombardi/dotfiles/tarball/master"
DOTFILES_GIT_REMOTE="git@github.com:flombardi/dotfiles.git"

# If missing, download and extract the dotfiles repository
if [[ ! -d ${DOTFILES_DIRECTORY} ]]; then
    printf "$(tput setaf 7)Downloading dotfiles...\033[m\n"
    mkdir ${DOTFILES_DIRECTORY}
    # Get the tarball
    curl -fsSLo ${HOME}/dotfiles.tar.gz ${DOTFILES_TARBALL_PATH}
    # Extract to the dotfiles directory
    tar -zxf ${HOME}/dotfiles.tar.gz --strip-components 1 -C ${DOTFILES_DIRECTORY}
    # Remove the tarball
    rm -rf ${HOME}/dotfiles.tar.gz
fi

cd ${DOTFILES_DIRECTORY}

# Test for known flags
for opt in $@
do
    case $opt in
        --no-sync) no_sync=true ;;
        -*|--*) printf "Warning: invalid option $opt" ;;
    esac
done

# Initialize the git repository if it's missing
if ! $(git rev-parse --is-inside-work-tree &> /dev/null); then
    printf "Initializing git repository..."
    git init
    git remote add origin ${DOTFILES_GIT_REMOTE}
    git fetch origin master
    # Reset the index and working tree to the fetched HEAD
    # (submodules are cloned in the subsequent sync step)
    git reset --hard FETCH_HEAD
    # Remove any untracked files
    git clean -fd
fi

# Conditionally sync with the remote repository
if [[ $no_sync ]]; then
    printf "Skipped dotfiles sync.\n"
else
    printf "Syncing dotfiles..."
    # Pull down the latest changes
    git pull --rebase origin master
    # Update submodules
    git submodule update --recursive --init --quiet
fi

link() {
    # Force create/replace the symlink.
    ln -fs "${DOTFILES_DIRECTORY}/${1}" "${HOME}/${2}"
}

mirrorfiles() {
    # Copy `.gitconfig`.
    # Any global git commands in `~/.bash_profile.local` will be written to
    # `.gitconfig`. This prevents them being committed to the repository.
    rsync -avz --quiet ${DOTFILES_DIRECTORY}/.gitconfig  ${HOME}/.gitconfig

    # Force remove the vim directory if it's already there.
    if [ -e "${HOME}/.vim" ]; then
        rm -rf "${HOME}/.vim"
    fi

    # Create the necessary symbolic links between the `.dotfiles` and `HOME`
    # directory. The `bash_profile` sources other files directly from the
    # `.dotfiles` repository.
    link ".bashrc"       ".bashrc"
    link ".bash_profile" ".bash_profile"
    link ".curlrc"       ".curlrc"
    link ".inputrc"      ".inputrc"
    link ".gitignore"    ".gitignore"

    printf "Dotfiles update complete!"
}

# Ask before potentially overwriting files
printf "Warning: This step may overwrite your existing dotfiles."
read -p "Continue? (y/n) " -n 1
printf "\n"

if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    mirrorfiles
    source ${HOME}/.bash_profile
else
    printf "Aborting...\n"
    exit 1
fi
