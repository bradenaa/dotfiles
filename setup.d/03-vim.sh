if [[ "$os" == "osx" ]]; then
    echo "$os: Installing vim..."
    brew install vim
elif [[ "$os" == "ubuntu" ]] || [[ "$os" == "linux" ]]; then
    echo "$os: Installing vim..."
    sudo apt-get install -y vim
fi

ensure_symlink "$(pwd)/vim/.vimrc" "$HOME/.vimrc"

