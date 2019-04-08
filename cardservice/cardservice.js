const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

const cardData = require("./paddata_processed_na_cards.json");
const cardDataById = {};
Object.values(cardData).forEach(element => {
  cardDataById[element.card.card_id] = element;
});

app.get('/cards/:cardId', (req, res) => {
  res.send(cardDataById[req.params.cardId]);
});

app.listen(port, () => console.log(`Card Service listening on port ${port}!`));