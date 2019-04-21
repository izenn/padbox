const express = require('express');
const app = express();
const port = process.env.PORT || 3000;
const fs = require('fs');
const StreamArray = require('stream-json/streamers/StreamArray');
const {Datastore} = require('@google-cloud/datastore');

const datastore = new Datastore();

app.use((req, res, next) => {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  next();
});

app.get('/', (req, res) => {
  res.send('API List:\nGET /cards/:cardId');
});

app.get('/cards/:cardId', (req, res) => {
  const query = datastore.createQuery('card').filter("card.card_id", Number.parseInt(req.params.cardId)).limit(1);
  datastore.runQuery(query, (err, entities) => {
    if(err) {
      res.send(err);
    } else { 
      res.json(entities);
    }
  });
});

app.get('/import', (req, res) => {
  const pipeline = fs.createReadStream('paddata_processed_na_cards.json').pipe(StreamArray.withParser());
  pipeline.on('data', data => {
    if(data.value) {
      datastore.save({
        key: datastore.key(["card"]),
        data: data.value
      }).catch(err => {
        console.error(`Insert error: ${err}`)
      });
    }
  });
  pipeline.on('end', () => {
    res.send("All data imported");
  });
});

app.listen(port, () => console.log(`Card Service listening on port ${port}!`));
