.PHONY: install doctor

install:
	./install.sh

doctor:
	./.local/bin/syncbin-doctor
