const express = require('express');
const app = express();
const port = process.env.PORT || 3000;
const fs = require('fs');
const StreamArray = require('stream-json/streamers/StreamArray');

const pipeline = fs.createReadStream('paddata_processed_na_cards.json').pipe(StreamArray.withParser());
const cardData = {};

pipeline.on('data', data => {
  cardData[data.value.card.card_id] = data.value;
});
pipeline.on('end', () => {
  app.get('/', (req, res) => {
    res.send('API List:\nGET /cards/:cardId');
  });
  
  app.get('/cards/:cardId', (req, res) => {
    res.send(cardData[req.params.cardId]);
  });
  
  app.listen(port, () => console.log(`Card Service listening on port ${port}!`));
});
