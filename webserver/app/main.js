const express = require('express');
const AWS = require('aws-sdk');
const app = express();

const kinesis = new AWS.Kinesis({ region: 'ap-northeast-1' });
const streamName = process.env.KINESIS_STREAM_NAME || 'my-kinesis-stream';
const usernames = ["John Smith", "Emma Brown", "David Lee", "john_doe", "jane_doe"];

// Kinesisにデータを送信する関数
function sendDataToKinesis(data) {
    const params = {
        Data: JSON.stringify(data),
        PartitionKey: 'partitionKey', // 任意のパーティションキーを設定
        StreamName: streamName
    };

    kinesis.putRecord(params, (err, data) => {
        if (err) {
            console.error('Error sending data to Kinesis:', err);
        } else {
            console.log('Successfully sent data to Kinesis:', data);
        }
    });
}

// 各ルートの設定
const routes = [
    { path: '/', action: 'index', message: 'ホーム画面です\n' },
    { path: '/about', action: 'about', message: 'これはAboutページです\n' },
    { path: '/contact', action: 'contact', message: 'これはContactページです\n' },
    { path: '/products', action: 'products', message: 'これはProductsページです\n' },
    { path: '/services', action: 'services', message: 'これはServicesページです\n' },
    { path: '/blog', action: 'blog', message: 'これはBlogページです\n' },
    { path: '/faq', action: 'faq', message: 'これはFAQページです\n' },
    { path: '/portfolio', action: 'portfolio', message: 'これはPortfolioページです\n' }
];

// 各ルートでKinesisにデータを送信
routes.forEach(route => {
    app.get(route.path, (req, res) => {
        const randomIndex = Math.floor(Math.random() * usernames.length);

        // Kinesisに送信するデータ
        const data = {
            name: usernames[randomIndex],
            path: route.path,
            action: route.action,
            timestamp: new Date().toISOString()
        };

        // Kinesisにデータを送信
        sendDataToKinesis(data);

        // 画面送信
        res.send(route.message);
    });
});

app.listen(3000, () => {
    console.log('Server is running on port 3000');
});
