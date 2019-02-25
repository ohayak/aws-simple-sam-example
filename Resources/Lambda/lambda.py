import json
import boto3
import logging
import os
import sys

log = logging.getLogger(__name__)
log.setLevel(logging.INFO)
log.info('Loading function')

REGION = os.environ['REGION']


def respond(err, res=None, head=None):
    res = {
        'statusCode': '400' if err else '200',
        'body': err.message if err else res,
        'headers': head if head else {
            'Content-Type': 'application/json'
        }
    }
    return res

def handler(event, context):
    log.info('Running handler')
    operations = {
        '/hello/GET': respond(None, "hello World!"),
    }

    if event['queryStringParameters'] is None:
        event['queryStringParameters'] = {}

    path = event['requestContext']['resourcePath']
    method = event['requestContext']['httpMethod']
    operation = "{}/{}".format(path, method)

    if operation in operations:
        log.info("starting operation: {}".format(operation))
        return operations[operation](event, context)
    else:
        return respond(ValueError('Unsupported path or method"{}"'.format(operation)))
