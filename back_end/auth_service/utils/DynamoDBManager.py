import boto3
from common.Logger import Logger

class DynamoDBManager:
    def __init__(self, table_name):
        self.dynamodb = boto3.resource('dynamodb')
        self.table_name = table_name
        self.table = self.dynamodb.Table(table_name)
        #Initialise Logging instance
        self.logging_instance = Logger()


    def add_item(self, item):
        try:
            self.table.put_item(Item=item)
            return True
        except Exception as e:
            self.logging_instance.log_exception(e, 'add_item')
            return False

    def remove_item(self, key):
        try:
            self.table.delete_item(Key=key)
            return True
        except Exception as e:
            self.logging_instance.log_exception(e, 'remove_item')
            return False

    def check_item_exists(self, key):
        try:
            response = self.table.get_item(Key=key)
            return 'Item' in response
        except Exception as e:
            self.logging_instance.log_exception(e, 'check_item_exists')
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
            self.logging_instance.log_exception(e, 'get_all_attributes')
            raise Exception("Error: " + str(e))
    
    def update_user_data(self, email, first_name=None, last_name=None, jwt_token=None, last_login=None ,last_logout=None, login_status=None, refresh_token=None):
        try:
            update_expression = "SET"
            expression_attribute_values = {}
            expression_attribute_names = {}
        
            if first_name is not None:
                update_expression += " #F = :f,"
                expression_attribute_values[":f"] = first_name
                expression_attribute_names["#F"] = "first_name"
        
            if last_name is not None:
                update_expression += " #L = :l,"
                expression_attribute_values[":l"] = last_name
                expression_attribute_names["#L"] = "last_name"
        
            if jwt_token is not None:
                update_expression += " #T = :t,"
                expression_attribute_values[":t"] = jwt_token
                expression_attribute_names["#T"] = "jwt_token"
        
            if last_login is not None:
                update_expression += " #L1 = :l1,"
                expression_attribute_values[":l1"] = last_login
                expression_attribute_names["#L1"] = "last_login"

            if last_logout is not None:
                update_expression += " #L2 = :l2,"
                expression_attribute_values[":l2"] = last_logout
                expression_attribute_names["#L2"] = "last_logout"

            if login_status is not None:
                update_expression += " #S = :s,"
                expression_attribute_values[":s"] = login_status
                expression_attribute_names["#S"] = "login_status"

            if refresh_token is not None:
                update_expression += " #R = :r,"
                expression_attribute_values[":r"] = refresh_token
                expression_attribute_names["#R"] = "refresh_token"
            
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
            self.logging_instance.log_exception(e, 'update_user_data')
            raise Exception("Error: " + str(e))
