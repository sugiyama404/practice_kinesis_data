import csv
import boto3
import base64
import os
import io
import datetime

s3 = boto3.client('s3')
bucket_name = os.environ['BUCKET_NAME']

today = datetime.date.today()
formatted_date = today.strftime("%Y-%m-%d")

def lambda_handler(event, context):
    object_key = 'data_from_kinesis/record_{}.csv'.format(formatted_date)

    # S3に既存のファイルがあるか確認する
    try:
        existing_object = s3.get_object(Bucket=bucket_name, Key=object_key)
        existing_data = existing_object['Body'].read().decode('utf-8')
        print("Existing data in S3:")
        print(existing_data)
    except s3.exceptions.NoSuchKey:
        existing_data = ''

    # Kinesisストリームからのイベントデータを処理する
    for record in event['Records']:
        # KinesisのデータはBase64でエンコードされているため、デコードする
        payload = base64.b64decode(record['kinesis']['data']).decode('utf-8')
        print("Decoded payload: " + payload)

        # payloadをCSVフォーマットに変換する
        # ここでは簡単な例として、payloadがカンマ区切りの値であることを想定します
        new_row = payload.split(',')

        # 既存のデータに新しい行を追加する
        existing_data += ','.join(new_row) + '\n'

    # 更新したデータをS3に保存する
    s3.put_object(
        Bucket=bucket_name,
        Key=object_key,
        Body=existing_data.encode('utf-8')
    )

    return {
        'statusCode': 200,
        'body': 'Data processed successfully!'
    }
