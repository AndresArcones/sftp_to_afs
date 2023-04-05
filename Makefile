DIR_SRC := ./sftp_to_afs/
DIR_TESTS := ./tests/

ENV := poetry
PYTHON := $(ENV) run python3
DOCKER := docker

IMAGE_NAME := sftp_to_afs

.PHONY: install-deps-dev install-devs install-typing-stubs format check-format check-typing test test-coverage clean build

install-deps-dev:
	$(ENV) install

install-deps:
	$(ENV) install --no-root

install-typing-stubs: 
	$(PYTHON) -m mypy --install-types --non-interactive

format:
	$(PYTHON) -m autopep8 -i -a -a -a -r $(DIR_SRC)

check-format:
	$(PYTHON) -m flake8 $(DIR_SRC)

check-typing:
	$(PYTHON) -m mypy --no-warn-return-any $(DIR_SRC)

test:
	$(PYTHON) -m unittest

test-coverage:
	$(PYTHON) -m coverage run -m unittest
	$(PYTHON) -m coverage report
	$(PYTHON) -m coverage xml

clean:
	rm -rf .mypy_cache

build:
	$(MAKE) clean
	$(DOCKER) rmi -f $(IMAGE_NAME)
	$(DOCKER) build -t $(IMAGE_NAME) .

run:
	$(PYTHON) -m sftp_to_afs
