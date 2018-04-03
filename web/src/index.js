"use strict";

require("normalize.css");

var Elm = require("./Main");

var app = Elm.Main.embed(document.getElementById("app"));

// bind web speech API to Elm Module
app.ports.speak.subscribe(function (text) {
  window.speechSynthesis.speak(new SpeechSynthesisUtterance(text));
});

// bind localStorage API to Elm Module
var storage = window.localStorage || {
  setItem(k, v) {
    this[k] = v;
  },
  getItem(k) {
    return this[k];
  }
};

function storeObject(key, object) {
  storage.setItem(key, JSON.stringify(object));
}
function retrieveObject(key) {
  const value = storage.getItem(key);
  return value ? JSON.parse(value) : null;
}

app.ports.storeObject.subscribe(function ([key, state]) {
  storeObject(key, state);
});
app.ports.retrieveObject.subscribe(function (key) {
  const o = retrieveObject(key);
  app.ports.objectRetrieved.send([key, o]);
});
