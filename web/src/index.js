"use strict";

require("normalize.css");

var Elm = require("./Main");

var app = Elm.Main.fullscreen(); //.embed(document.getElementById("app"));

console.log("following...");
console.log(app);

// bind web speech API to Elm Module
app.ports.speak.subscribe(function(text) {
  window.speechSynthesis.speak(new SpeechSynthesisUtterance(text));
});
