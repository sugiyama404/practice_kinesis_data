const express = require('express');
const app = express();

const routes = [
    { path: '/', message: 'ホーム画面です\n' },
    { path: '/about', message: 'これはAboutページです\n' },
    { path: '/contact', message: 'これはContactページです\n' },
    { path: '/user/:id', message: 'ユーザーID: :id のプロフィールページです\n', dynamic: true },
    { path: '/products', message: 'これはProductsページです\n' },
    { path: '/services', message: 'これはServicesページです\n' },
    { path: '/blog', message: 'これはBlogページです\n' },
    { path: '/faq', message: 'これはFAQページです\n' },
    { path: '/portfolio', message: 'これはPortfolioページです\n' }
];

routes.forEach(route => {
    if (route.dynamic) {
        app.get(route.path, (req, res) => {
            const message = route.message.replace(':id', req.params.id);
            res.send(message);
        });
    } else {
        app.get(route.path, (req, res) => {
            res.send(route.message);
        });
    }
});

app.listen(3000, () => {
    console.log('サーバーがポート3000で起動しました');
});
