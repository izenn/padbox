const express = require('express');
const app = express();
const port = process.env.PORT || 3000;
const fs = require('fs');
const StreamArray = require('stream-json/streamers/StreamArray');

function getCardById(id) {
  let resolver;
  const promise = new Promise((res, rej) => {
    resolver = res;
  });
  const pipeline = fs.createReadStream('paddata_processed_na_cards.json').pipe(StreamArray.withParser());
  let ret = null;
  pipeline.on('data', data => {
    if(data.value.card.card_id === id){
      ret = data.value;
    }
  });
  pipeline.on('end', () => {
    resolver(ret);
  })
  return promise;
}

app.get('/', (req, res) => {
  res.send('API List:\nGET /cards/:cardId');
});

app.get('/cards/:cardId', (req, res) => {
  getCardById(Number.parseInt(req.params.cardId)).then(cardData => {
    res.send(cardData);
  })
});

app.listen(port, () => console.log(`Card Service listening on port ${port}!`));
