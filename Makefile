.PHONY: lint
lint:
	@selene .

.PHONY: update
update:
	@scripts/update.sh

.PHONY: test
test:
	@scripts/test.sh