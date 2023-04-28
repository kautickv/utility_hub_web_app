from faker import Faker
import numpy as py
import pandas as pd
import matplotlib.pyplot as plt

def lambda_handler(event, context):
    fake = Faker()
    name = fake.name()
    print(f'Hello, {name}!')
    return {
        'statusCode': 200,
        'body': f'Hello, {name}!'
    }
