import boto3

class BookmarksTableHandler:
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
    
    def update_user_data(self, email, config_json=None, last_modified=None):
        try:
            update_expression = "SET"
            expression_attribute_values = {}
            expression_attribute_names = {}
        
            if config_json is not None:
                update_expression += " #F = :f,"
                expression_attribute_values[":f"] = config_json
                expression_attribute_names["#F"] = "config_json"
        
            if last_modified is not None:
                update_expression += " #L1 = :l1,"
                expression_attribute_values[":l1"] = last_modified
                expression_attribute_names["#L1"] = "last_modified"

            
            if update_expression == "SET":
                # No fields provided for update
                return False
            
            # Remove the trailing comma from the update expression
            update_expression = update_expression.rstrip(",")
            
            self.table.update_item(
                Key={'email': email},
                UpdateExpression=update_expression,
                ExpressionAttributeValues=expression_attribute_values,
                ExpressionAttributeNames=expression_attribute_names
            )
            
            return True
        except Exception as e:
            print(f"Error updating user data in DynamoDB: {e}")
            raise Exception("Error: " + str(e))
