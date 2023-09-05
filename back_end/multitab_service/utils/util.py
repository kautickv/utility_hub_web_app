import json
import gzip
import base64


# Compress and encode
def compress_json(data):
    json_str = json.dumps(data)
    json_bytes = json_str.encode('utf-8')
    compressed_data = gzip.compress(json_bytes)
    encoded_data = base64.b64encode(compressed_data)
    return encoded_data.decode('utf-8')  # Convert bytes to string for storing in DynamoDB

# Decode and decompress
def decompress_json(data):
    decoded_data = base64.b64decode(data)
    decompressed_data = gzip.decompress(decoded_data)
    json_str = decompressed_data.decode('utf-8')
    return json.loads(json_str)