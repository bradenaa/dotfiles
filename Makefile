# Creates symbolic links.
.PHONY: link
link:
#	ln -sf ${PWD}/shell.sh ~/.shell.sh
#	ln -sf ${PWD}/shell.d ~/.shell.d
	ln -sf ${PWD}/tmux/.tmux.conf ~/.tmux.conf
	ln -sf ${PWD}/zsh/.zshrc ~/.zshrc
	ln -sf ${PWD}/vim/.vimrc ~/.vimrc

.PHONY: setup
setup:
	./setup.sh
