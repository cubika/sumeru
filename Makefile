TESTS = test/*.js
REPORTER = spec
TIMEOUT = 10000
MOCHA_OPTS =
G = 


uname := $(shell uname)

#JSCOVERAGE = ./node_modules/jscover/bin/jscover
JSCOVERAGE = ./test/tools/jscoverage.exe

ifneq (,$(findstring Linux, $(uname)))
	JSCOVERAGE = ./jscoverage-0.5.1/jscoverage
endif

test:
	@NODE_ENV=test ./node_modules/mocha/bin/mocha \
		--reporter $(REPORTER) \
		--timeout $(TIMEOUT) $(MOCHA_OPTS) \
		$(TESTS)

test-g:
	@NODE_ENV=test ./node_modules/mocha/bin/mocha \
		--reporter $(REPORTER) \
		--timeout $(TIMEOUT) -g "$(G)" \
		$(TESTS)

test-cov: sumeru-cov
	@SUMERU_COV=1 $(MAKE) test REPORTER=dot
	@SUMERU_COV=1 $(MAKE) test REPORTER=html-cov > coverage.html
	@SUMERU_COV=1 $(MAKE) test REPORTER=mocha-lcov-reporter | sed "s/SF:/&sumeru-cov\//g" | COVERALLS_REPO_TOKEN="6YyJ50r3e5E5oF4YJuxu0ovibailVDARn" ./node_modules/coveralls/bin/coveralls.js
	@rm -rf sumeru-cov

sumeru-cov:
	@rm -rf $@
	@$(JSCOVERAGE) sumeru $@ --no-highlight --encoding=UTF-8

.PHONY: test test-g test-cov sumeru-cov 