info: menu select

menu:
	echo "1  make reset            - flutter clean && flutter pub get"
	echo "2  make format           - dart format lib/ test/"
	echo "3  make test             - run all tests"
	echo "4  make test_unit        - run unit tests (notifier tests)"
	echo "5  make test_widget      - run widget tests"
	echo "6  make test_golden      - run golden tests"
	echo "7  make golden_update    - update golden files"
	echo "8  make coverage         - run tests with coverage"
	echo "9  make analyze          - flutter analyze"
	echo "10 make fix              - dart fix --apply"
	echo "11 make lint             - analyze + fix"
	echo "12 make build_apk        - build Android APK"
	echo "13 make build_ios        - build iOS app"
	echo "14 make build_web        - build web app"
	echo "15 make run              - run app on default device"
	echo "16 make run_chrome       - run app on Chrome"
	echo "17 make clean            - flutter clean"
	echo "18 make update_phony     - update .PHONY in Makefile"

select:
	read -p ">>> " P ; make menu | grep "^$$P " | cut -d ' ' -f2-3 ; make menu | grep "^$$P " | cut -d ' ' -f2-3 | bash

.SILENT:

.PHONY: info menu select reset format test test_unit test_widget test_golden golden_update coverage analyze fix lint build_apk build_ios build_web run run_chrome clean update_phony 

reset:
	flutter clean && flutter pub get

format:
	dart format lib/ test/

test:
	flutter test

test_unit:
	flutter test test/counter_notifier_test.dart test/theme_notifier_test.dart

test_widget:
	flutter test test/count_text_test.dart test/settings_screen_test.dart test/routing_test.dart

test_golden:
	flutter test test/golden/

golden_update:
	flutter test --update-goldens

coverage:
	flutter test --coverage
	@echo "Coverage report generated in coverage/lcov.info"

analyze:
	flutter analyze

fix:
	dart fix --apply

lint: analyze fix

build_apk:
	flutter build apk

build_ios:
	flutter build ios

build_web:
	flutter build web

run:
	flutter run

run_chrome:
	flutter run -d chrome

clean:
	flutter clean

update_phony:
	@echo "##### Updating .PHONY targets #####"
	@targets=$$(grep -E '^[a-zA-Z_][a-zA-Z0-9_-]*:' Makefile | grep -v '=' | cut -d: -f1 | tr '\n' ' '); \
	sed -i.bak "s/^\.PHONY:.*/.PHONY: $$targets/" Makefile && \
	echo "Updated .PHONY: $$targets" && \
	rm -f Makefile.bak
