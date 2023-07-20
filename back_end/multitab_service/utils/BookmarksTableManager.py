import boto3
import json

class BookmarksTableManager:
    def __init__(self, table_name):
        self.dynamodb = boto3.resource('dynamodb')
        self.table_name = table_name
        self.table = self.dynamodb.Table(table_name)

    
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
        ## If email does not exists, this function will create a new record.
        try:
            update_expression = "SET"
            expression_attribute_values = {}
            expression_attribute_names = {}

            if config_json is not None:
                for i, config_item in enumerate(config_json):
                    # Use the index to create a unique attribute name for each config item
                    attr_name = f"#F{i}"
                    attr_value = f":f{i}"
                    update_expression += f" {attr_name} = {attr_value},"
                    expression_attribute_values[attr_value] = json.dumps(config_item)
                    expression_attribute_names[attr_name] = f"tile_{i}"

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

