S3_BUCKET="my-s3-bucket"
S3_PREFIX="my-s3-prefix"
STACK_NAME=aws-simple-sam-example

BUILDDIR=.aws-sam

install:
	sudo env PATH=$(PATH) pip install --upgrade pip
	sudo env PATH=$(PATH) pip install --upgrade setuptools
	sudo env PATH=$(PATH) pip install --upgrade awscli
	sudo env PATH=$(PATH) pip install --upgrade aws-sam-cli

build:
	sam build --use-container --debug

.ONESHELL:
package:
	cd $(BUILDDIR)/build
	sam package --debug \
	--template template.yml \
	--s3-bucket $(S3_BUCKET) \
	--s3-prefix $(S3_PREFIX) \
	--output-template packaged.yml

.ONESHELL:
deploy:
	cd $(BUILDDIR)/build
	sam deploy --debug \
    --template-file packaged.yml \
    --stack-name $(STACK_NAME) \
    --capabilities CAPABILITY_IAM \
    --region eu-west-1

invoke:
	sam local invoke --debug --event Resources/Lambda/test/event.json Lambda

clean:
	rm -rf $(BUILDDIR)
	yes | docker image prune -a
	yes | docker container prune
