from faker import Faker

def lambda_handler(event, context):
    fake = Faker()
    name = fake.name()
    print(f'Hello, {name}!')
    return {
        'statusCode': 200,
        'body': f'Hello, {name}!'
    }
