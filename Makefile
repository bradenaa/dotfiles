# Creates symbolic links.
.PHONY: link
link:
#	ln -sf ${PWD}/shell.sh ~/.shell.sh
#	ln -sf ${PWD}/shell.d ~/.shell.d
	ln -sf ${PWD}/tmux/tmux.conf ~/.tmux.conf

.PHONY: setup
setup:
	./setup.sh
