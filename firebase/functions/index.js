/* eslint-disable max-len */
// eslint-disable
// firebase deploy --only functions

const functions = require("firebase-functions");
const got = require("got");
const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);

exports.scheduledGetCoinData = functions.pubsub.schedule("*/10 * * * *")
  .timeZone("America/New_York") // Users can choose timezone -
  .onRun(async (context) => {
    url = "https://api.nomics.com/v1/currencies/ticker?key=34655af3a497ec68f8bfbeec35bb8139a6ab92b4&ids=BTC,ETH,LTC&interval=1h&convert=USD&per-page=50&page=1"
    const currencies = await got(url, { responseType: 'json', resolveBodyOnly: true });
    var wait = []
    for (const currency of currencies) {
      temp = admin.firestore().collection("cryptos").doc(currency.name).set(currency);
      wait.push(temp)
      console.log(`updated ${currency.name} with new price ${currency.price}$`);
    }
    await Promise.all(wait)
    return null;
  });

