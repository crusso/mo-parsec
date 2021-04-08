.PHONY: check docs test example

check:
	find src -type f -name '*.mo' -print0 | xargs -0 $(shell vessel bin)/moc $(shell vessel sources) --check

all: check-strict docs test example

check-strict:
	find src -type f -name '*.mo' -print0 | xargs -0 $(shell vessel bin)/moc $(shell vessel sources) -Werror --check

docs:
	$(shell vessel bin)/mo-doc

test:
	make -C test

example:
	make -C example
