if [[ "$os" == "osx" ]]; then
    echo "$os: Installing fzf..."
    brew install fzf
    $(brew --prefix)/opt/fzf/install
    source ~/.zshrc
elif [[ "$os" == "ubuntu" ]] || [[ "$os" == "linux" ]]; then
    echo "$os: Installing fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install
fi

