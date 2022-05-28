include .env

build:
	docker build . -t atforestry/$(IMAGE_NAME)

run:
	docker-compose up -d --build
	docker-compose logs -f --tail=20

stop:
	docker-compose down

bash:
	docker run -it atforestry/$(IMAGE_NAME) /bin/bash

logs:
	docker-compose logs -f service

deploy:
	time=$$(date +'%Y%m%d-%H%M%S') && \
	docker tag atforestry/$(IMAGE_NAME) us-central1-docker.pkg.dev/mlops-3/atforestry/$(IMAGE_NAME):$$time && \
	docker tag atforestry/$(IMAGE_NAME) us-central1-docker.pkg.dev/mlops-3/atforestry/$(IMAGE_NAME):latest && \
	docker push us-central1-docker.pkg.dev/mlops-3/atforestry/$(IMAGE_NAME):$$time && \
	docker push us-central1-docker.pkg.dev/mlops-3/atforestry/$(IMAGE_NAME):latest && \
	kubectl set image deployment $(IMAGE_NAME) $(IMAGE_NAME)=us-central1-docker.pkg.dev/mlops-3/atforestry/$(IMAGE_NAME):$$time

auth:
	gcloud -q components update
	gcloud auth login
	gcloud -q config set project mlops-3
	gcloud auth configure-docker us-central1-docker.pkg.dev
	gcloud container clusters get-credentials atforestry-cluster --region us-central1

