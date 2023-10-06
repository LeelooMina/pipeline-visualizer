aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 840916924042.dkr.ecr.us-east-1.amazonaws.com
docker build -t project-heliodor-beta-ecr .
docker tag project-heliodor-beta-ecr:latest 840916924042.dkr.ecr.us-east-1.amazonaws.com/project-heliodor-beta-ecr:pipeline-api-latest
docker push 840916924042.dkr.ecr.us-east-1.amazonaws.com/project-heliodor-beta-ecr:pipeline-api-latest

aws ecs update-service --region us-east-1 --cluster project-heliodor-beta-services --service pipeline-api-service --force-new-deployment
