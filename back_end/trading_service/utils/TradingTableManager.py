import boto3
import json
import uuid
from datetime import datetime

class TradingTableManager:
    def __init__(self, table_name):
        self.dynamodb = boto3.resource('dynamodb')
        self.table_name = table_name
        self.table = self.dynamodb.Table(table_name)

    
    def add_item(self, item):
        """
        Add a new item to the table.
        
        Args:
        - item (dict): The item to be added.
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