import json
import gzip
import base64
from common.Logger import Logger


# Compress and encode
def compress_json(data):
    try:
        json_str = json.dumps(data)
        json_bytes = json_str.encode('utf-8')
        compressed_data = gzip.compress(json_bytes)
        encoded_data = base64.b64encode(compressed_data)
        return encoded_data.decode('utf-8')  # Convert bytes to string for storing in DynamoDB
    except Exception as e:
        #Initialise Logging instance
        logging_instance = Logger()
        logging_instance.log_exception(e, 'compress_json')


# Decode and decompress
def decompress_json(data):
    try:
        decoded_data = base64.b64decode(data)
        decompressed_data = gzip.decompress(decoded_data)
        json_str = decompressed_data.decode('utf-8')
        return json.loads(json_str)
    except Exception as e:
        #Initialise Logging instance
        logging_instance = Logger()
        logging_instance.log_exception(e, 'decompress_json')