import boto3

class DynamoDBManager:
    def __init__(self, table_name):
        self.dynamodb = boto3.resource('dynamodb')
        self.table_name = table_name
        self.table = self.dynamodb.Table(table_name)

    def add_item(self, item):
        try:
            self.table.put_item(Item=item)
            return True
        except Exception as e:
            print(f"Error adding item to DynamoDB: {e}")
            return False

    def remove_item(self, key):
        try:

            print("Key")
            print(key)
            self.table.delete_item(Key=key)
            print("Item has been added")
            return True
        except Exception as e:
            print(f"Error removing item from DynamoDB: {e}")
            return False

    def check_item_exists(self, key):
        try:
            response = self.table.get_item(Key=key)
            return 'Item' in response
        except Exception as e:
            print(f"Error checking item existence in DynamoDB: {e}")
            return False
        
    def get_all_attributes(self, key):

        try:
            response = self.table.get_item(Key={'email': key})
            item = response.get('Item')
            if (item):
                return item
            else:
                return None
        except Exception as e:
            print(f"Error retrieving all fields from dynamo table")
            raise Exception("Error: " + str(e))
