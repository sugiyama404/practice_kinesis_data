import csv
import boto3
import base64
import os
import io

s3 = boto3.client('s3')
bucket_name = os.environ['BUCKET_NAME']

def lambda_function(event, context):
    # Kinesisストリームからのイベントデータを処理する
    for record in event['Records']:
        # KinesisのデータはBase64でエンコードされているため、デコードする
        payload = base64.b64decode(record['kinesis']['data']).decode('utf-8')
        print("Decoded payload: " + payload)

        # payloadをCSVフォーマットに変換する
        # ここでは簡単な例として、payloadがカンマ区切りの値であることを想定します
        csv_buffer = io.StringIO()
        csv_writer = csv.writer(csv_buffer)

        # デコードされたpayloadをリストとして渡します（ここでは簡単なカンマ区切りを想定）
        csv_writer.writerow(payload.split(','))

        # S3にアップロードするためのオブジェクトキーを作成
        object_key = 'data_from_kinesis/record_{}.csv'.format(record['eventID'])

        # S3にデータをアップロードする
        s3.put_object(
            Bucket=bucket_name,
            Key=object_key,
            Body=csv_buffer.getvalue()
        )

    return {
        'statusCode': 200,
        'body': 'Data processed successfully!'
    }
