import json
import boto3
import os
from decimal import Decimal

dynamodb = boto3.resource('dynamodb')
sns = boto3.client('sns')

table = dynamodb.Table('stability-results')

TOPIC_ARN = os.environ['TOPIC_ARN']


def lambda_handler(event, context):

    print("Function started")
    print(event)

    body = json.loads(event['body'])

    batch_id = body['batch_id']
    timepoint = body['timepoint']
    condition = body['condition']
    assay = body['assay']
    zinc = body['zinc']
    ph = body['ph']

    print(f"Batch: {batch_id}")

    status = "PASS"

    if zinc == "FAIL":

        status = "OOS"

        sns.publish(
            TopicArn=TOPIC_ARN,
            Subject="Stability OOS Alert",
            Message=f"""Batch ID: {batch_id}
Timepoint: {timepoint}
Condition: {condition}
Assay: {assay}
pH: {ph}
Status: {status}"""
        )

        print("SNS notification sent")

    table.put_item(
        Item={
            'batch_id': batch_id,
            'timepoint': timepoint,
            'condition': condition,
            'assay': Decimal(str(assay)),
            'zinc': zinc,
            'ph': Decimal(str(ph)),
            'status': status
        }
    )

    print("Item stored successfully")

    return {
        'statusCode': 200,
        'body': json.dumps({
            'message': 'Result Stored',
            'status': status
        })
    }