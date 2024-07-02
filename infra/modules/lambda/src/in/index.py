import json
import boto3
import base64
import os

s3 = boto3.client('s3')
buket_name = os.environ['BUKET_NAME']

def lambda_handler(event, context):
    # Kinesisストリームからのイベントデータを処理する
    for record in event['Records']:
        # KinesisのデータはBase64でエンコードされているため、デコードする
        payload = base64.b64decode(record['kinesis']['data'])
        print("Decoded payload: " + str(payload))

        # S3にアップロードするためのオブジェクトキーを作成
        object_key = 'data_from_kinesis/record_{}.json'.format(record['eventID'])

        # S3にデータをアップロードする
        s3.put_object(
            Bucket=buket_name,  # ここにあなたのS3バケット名を指定
            Key=object_key,
            Body=payload
        )

    return {
        'statusCode': 200,
        'body': json.dumps('Data processed successfully!')
    }
