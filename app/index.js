const express = require('express');
const app = express();

app.get('/health', (req, res) => res.send('OK'));

app.listen(3001, '0.0.0.0', () => {
  console.log('Server running on port 3000');
});
