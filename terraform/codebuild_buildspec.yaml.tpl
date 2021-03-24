version: 0.2
phases:
  pre_build:
    commands:
      - REPOSITORY_URI=${repository_uri}
      - $$(aws ecr get-login --region $AWS_DEFAULT_REGION --no-include-email)
      - nohup /usr/local/bin/dockerd --host=unix:///var/run/docker.sock --host=tcp://127.0.0.1:2375 --storage-driver=overlay2&
  build:
    commands:
      - git checkout main
      - COMMIT_HASH=$$(echo $$CODEBUILD_RESOLVED_SOURCE_VERSION | cut -c 1-7)
      - IMAGE_TAG=$${COMMIT_HASH:=latest}
      - docker build -t ${repository_uri}:latest .
      - docker tag ${repository_uri}:latest ${repository_uri}:$$IMAGE_TAG
      - docker push ${repository_uri}:latest
      - docker push ${repository_uri}:$$IMAGE_TAG