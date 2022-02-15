build:
	docker build -t itinance/php-8.1-dev:latest -t itinance/php-8.1-dev:v1.0.0 .

push: build
	docker push itinance/php-8.1-dev:latest
	docker push itinance/php-8.1-dev:v1.0.0
