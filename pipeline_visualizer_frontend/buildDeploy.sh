set -e

npm ci
npm run build --production

export HELIODOR_WEBAPP_SOURCE=project-heliodor-beta-webapp
aws s3 cp dist/ s3://${HELIODOR_WEBAPP_SOURCE}/ --recursive
aws s3 cp s3://${HELIODOR_WEBAPP_SOURCE}/index.html s3://${HELIODOR_WEBAPP_SOURCE}/index.html --metadata-directive REPLACE --cache-control max-age=0 --content-type 'text/html'
