"use strict";

require("normalize.css");

var Elm = require("./Main");

var app = Elm.Main.embed(document.getElementById("app"));

// bind web speech API to Elm Module
app.ports.speak.subscribe(function(text) {
  window.speechSynthesis.speak(new SpeechSynthesisUtterance(text));
});
