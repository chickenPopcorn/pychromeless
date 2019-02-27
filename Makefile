clean:
	rm -rf build build.zip
	rm -rf __pycache__

fetch-dependencies:
	mkdir -p bin/

	# Get chromedriver
	test -f bin/chromedriver || curl -SL https://chromedriver.storage.googleapis.com/2.32/chromedriver_linux64.zip > chromedriver.zip
	!(test -f chromedriver.zip && unzip chromedriver.zip -d bin/)

	# Get Headless-chrome
	test -f bin/headless-chromium || curl -SL https://github.com/adieuadieu/serverless-chrome/releases/download/v1.0.0-29/stable-headless-chromium-amazonlinux-2017-03.zip > headless-chromium.zip
	!(test -f bin/headless-chromium.zip && unzip headless-chromium.zip -d bin/)

	# Clean
	!(test -f bin/headless-chromium.zip && rm headless-chromium.zip)
	!(test -f bin/headless-chromium.zip && rm chromedriver.zip)

docker-build:
	docker-compose build

docker-run:
	docker-compose run lambda src.lambda_function.lambda_handler

build-lambda-package: clean fetch-dependencies
	!(test -f build && rm -rf build)
	./pip_config.sh
	mkdir build
	cp -r src build/.
	cp -r bin build/.
	cp -r lib build/.
	pip3 install -r requirements.txt -t build/lib/.
	chmod -R 0777 build/*
	cd build; zip -9qr build.zip .
	cp build/build.zip .
	rm -rf build

