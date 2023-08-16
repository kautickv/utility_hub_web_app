import boto3
import json
import uuid
from datetime import datetime, timedelta

class TradingTableManager:
    def __init__(self, table_name):
        self.dynamodb = boto3.resource('dynamodb')
        self.table_name = table_name
        self.table = self.dynamodb.Table(table_name)

    
    def add_item(self, item):
        """
            PURPOSE: Add a new item to the table.
            INPUT: A dict containing all fields
            OUTPUT: The response from DB
        """
        # Generate a unique ID and add a timestamp
        item['key'] = str(uuid.uuid4())
        item['last_fetch'] = datetime.now().isoformat()
        try:
            response = self.table.put_item(Item=item)
            return response
        except Exception as e:
            print(f"Error adding item: {e}")
            return None
        
    
    def get_items(self, numDays=5):
        '''
            PURPOSE: This funtion will return all the crypto data within the number of days specified.
            INPUT: The number of days
            OUTPUT: A list of all the crypto data
        '''

        try:
            # Define a datetime threshold of 5 days ago
            threshold = (datetime.now() - timedelta(days=numDays)).isoformat()

            # Query the table using the GSI on 'last_fetch'
            response = self.table.query(
                IndexName='LastFetch',
                KeyConditionExpression= "last_fetch >= :threshold",
                ExpressionAttributeValues= {":threshold": threshold}
            )

            items = response.get('Items', [])
            return items
        except Exception as e:
            print(f"get_items(): {e}")
            raise Exception(f"Failed to read from DB: {e}")