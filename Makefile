S3_BUCKET=
S3_PREFIX=
STACK_NAME=aws-simple-sam-example

BUILDDIR=.aws-sam

install:
	sudo env PATH=$(PATH) pip install --upgrade pip
	sudo env PATH=$(PATH) pip install --upgrade setuptools
	sudo env PATH=$(PATH) pip install --upgrade awscli
	sudo env PATH=$(PATH) pip install --upgrade aws-sam-cli

build:
	sam build --use-container --debug

package: build
	sam package --debug \
	--template $(BUILDDIR)/build/template.yaml \
	--s3-bucket $(S3_BUCKET) \
	--s3-prefix $(S3_PREFIX) \
	--output-template $(BUILDDIR)/build/packaged.yaml

deploy: package
	sam deploy --debug \
    --template-file $(BUILDDIR)/build/packaged.yaml \
    --stack-name $(STACK_NAME) \
    --capabilities CAPABILITY_IAM \
    --region eu-west-1

invoke:
	sam local invoke --debug --event Resources/Lambda/test/event.json Lambda

clean:
	rm -rf $(BUILDDIR)
	yes | docker image prune -a
	yes | docker container prune
