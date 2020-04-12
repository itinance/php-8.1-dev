build:
	docker build -t itinance/php-7.4-dev:latest -t itinance/php-7.4-dev:v1.0.0 .

push:
	docker push itinance/php-7.4-dev:latest
	docker push itinance/itinance/php-7.4-dev:v1.0.0
