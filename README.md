# askr-casel-extract

This serverless deployment example with serverless application Lambda + ApiGateway

```bash
.
├── README.md                   <-- This instructions file
├── Resources                   <-- Source files
│   └── Lambda                  <-- Source directory for lambda function
│       ├── lambda.py           <-- handler code for lambda function
│       ├── test                <-- test folder
│       │   └── event.json      <-- event example to test function
│       └── requirements.txt    <-- Python dependencies
├── buildspec.yaml              <-- Build specification used by AWS CodeBuild
├── Makefile                    <-- Makefile
└── template.yaml               <-- SAM Template
```

## Requirements

* AWS CLI already configured with at least PowerUser permission
* [Python 3 installed](https://www.python.org/downloads/)
* [Docker installed](https://www.docker.com/community-edition)
* [AWS CLI](https://aws.amazon.com/fr/cli/)
* [SAM CLI](https://github.com/awslabs/aws-sam-cli)

## Setup process

### Define project

Go to Makefile and make sure that following variables are wll defined:
    - `S3_BUCKET` where lambda packaged code will be stored
    - `S3_PREFIX` prefix within S3 bucket
    - `STACK_NAME` CloudFormation stack name
**NOTE**: You have to create a stack first using `packaged.yaml` generated with package command.

### Building the project

[AWS Lambda requires a flat folder](https://docs.aws.amazon.com/lambda/latest/dg/lambda-python-how-to-create-deployment-package.html) with the application as well as its dependencies. When you make changes to your source code or dependency manifest,
run the following command to build your project local testing and deployment:
 
```bash
make build
```
 
By default, this command writes built artifacts to `.aws-sam/build` folder.

**Invoking function locally**

```bash
make invoke
```

**SAM CLI** can be used to emulate both Lambda and API Gateway locally and uses our `template.yaml` to understand how to bootstrap this environment (runtime, where the source code is, etc.)

### Packaging (optional)

AWS Lambda Python runtime requires a flat folder with all dependencies including the application. SAM will use `CodeUri` property to know where to look up for both application and dependencies:

```yaml
...
    Lambda:
        Type: AWS::Serverless::Function
        Properties:
            CodeUri: Resources/Lambda
            ...
```

Next, run the following command to package our Lambda function to S3: (destination bucket and prefix are defined within Makefile)

```bash
make package
```
Then, go to `.aws-sam/build/packaged.yaml` and get upload location.

```yaml
...
    Lambda:
        Type: AWS::Serverless::Function
        Properties:
            CodeUri: s3://my-bucket-name/my-prefix/fjjdfhsdhfjdsjfdfdfsdfds
            ...
```
You can use this CodeUri to run Lambda via AWS Lambda Console.

### Deployment

Next, the following command will deploy your SAM resources on the stack.

```bash
make deploy
```

> **See [Serverless Application Model (SAM) HOWTO Guide](https://github.com/awslabs/serverless-application-model/blob/master/HOWTO.md) for more details in how to get started.**
