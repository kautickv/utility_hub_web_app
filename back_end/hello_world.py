import os
import boto3

def lambda_handler(event, context):
    dynamodb = boto3.resource('dynamodb')
    # Retrieve table name from environment variable
    table_name = os.environ.get('DYNAMO_TABLE_NAME')
    
    table = dynamodb.Table(table_name)
    
    # Item to be added to the table
    item = {
        'email': 'john@example.com',
        'first_name': 'John',
        'last_name': 'Doe',
        'jwtToken': 'abc123',
        'lastLogout': '2022-01-01'
    }
    
    # Put item into the table
    response = table.put_item(Item=item)
    
    return {
        'statusCode': 200,
        'body': 'Item added to DynamoDB table.'
    }

