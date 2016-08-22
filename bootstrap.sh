#!/bin/bash

DOTFILES_DIRECTORY="${HOME}/.dotfiles"
DOTFILES_TARBALL_PATH="https://github.com/flombardi/dotfiles/tarball/master"
DOTFILES_GIT_REMOTE="git@github.com:flombardi/dotfiles.git"

# If missing, download and extract the dotfiles repository
if [[ ! -d ${DOTFILES_DIRECTORY} ]]; then
    echo "Downloading dotfiles..."
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
        -*|--*) echo "Warning: invalid option $opt" ;;
    esac
done

# Initialize the git repository if it's missing
if ! $(git rev-parse --is-inside-work-tree &> /dev/null); then
    echo -n "Initializing git repository..."
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
    echo "Skipped dotfiles sync."
else
    echo -n "Syncing dotfiles..."
    # Pull down the latest changes
    git pull --rebase origin master
    # Update submodules
    git submodule update --recursive --init --quiet
fi

# Ask before potentially overwriting files
read -p "Warning: This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
echo "";

if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    # Copy `.gitconfig`.
    # Any global git commands will be written to `.gitconfig`.
    # This prevents them being committed to the repository.
    rsync -avz --quiet ${DOTFILES_DIRECTORY}/.gitconfig  ${HOME}/.gitconfig

    # Force remove the vim directory if it's already there.
    test -e "${HOME}/.vim" && rm -rf "${HOME}/.vim"

    # Create the necessary symbolic links between the `.dotfiles` and `HOME`
    # directory. The `bash_profile` sources other files directly from the
    # `.dotfiles` repository.
    for file in .bashrc .bash_profile .curlrc .inputrc .gitignore; do
      ln -fs "${DOTFILES_DIRECTORY}/${file}" "${HOME}/${file}"
    done
    echo "Dotfiles update complete!"

    source ${HOME}/.bash_profile
else
    echo "Aborting..."
    exit 1
fi
