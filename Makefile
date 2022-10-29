# TODO:
#	- test-watch
#	- run-watch

.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

install: ## Install python dependencies via Poetry
	poetry install

run: ## Runs the cli entry point
	poetry run python -c 'import loadout.cli; loadout.cli.hello_world()'

run-debug: ## Starts a debug run of the cli. Process waits until debugger client connects on localhost:5678
	poetry run python -c 'import loadout.cli; import debugpy; debugpy.listen(5678); debugpy.wait_for_client(); loadout.cli.hello_world()'

test: ## Run tests
	poetry run python -m pytest tests

test-debug: ## Starts a debug test run
	poetry run python -c 'import pytest; import debugpy; debugpy.listen(5678); debugpy.wait_for_client(); pytest.main(["tests"])'

test-coverage: ## Generate test coverage
	poetry run coverage run -m pytest tests

test-coverage-report-text: ## Print a text coverage report to stdout
	poetry run coverage report -m

test-coverage-report-html: ## Generate an html coverage report
	poetry run coverage html

test-coverage-report-serve: ## Serve the html coverage report at localhost:8080
	cd htmlcov && python -m http.server 8080

bandit: ## Run bandit security static analysis
	poetry run python -m bandit -r -c pyproject.toml .

types: ## Run mypy type-checking
	poetry run mypy loadout tests

isort: ## Sort imports with isort
	poetry run isort .

isort-check: ## Just runs an isort check, but doesn't write files. We use this in CI
	poetry run isort -c .

lint: ## Lint the codebase with flake8 & pylint
	poetry run flake8 tests loadout && poetry run pylint tests loadout

init-workspace: ## Sets up the workspace
	poetry install && pre-commit install

validate-conventional-commit:
	git log -1 --pretty=%B | poetry run cz check

format:
	poetry run black .

format-check:
	poetry run black --check .