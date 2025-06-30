const express = require('express');
const app = express();
const port = 3000;

app.get('/health', (req, res) => res.send('OK'));
app.get('/', (req, res) => res.send('Hello from App!'));

app.listen(port, () => console.log(`App running on port ${port}`));
