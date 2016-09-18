var title = document.querySelector("#title");
var image = document.querySelector("#image");
var artpage = document.querySelector("#artpage");
var artist = document.querySelector("#artist");
var tags = document.querySelector("#tags");

var submit = document.querySelector("#submitimg");

var opts = function (optlist) {
  var v = '';
  Object.keys(optlist).forEach(function (name) {
    if (optlist[name].checked) v = name;
  });
  return v;
};

submit.onclick = function () {
  var xhr = new XMLHttpRequest();
  xhr.onload = function () {
    var resbits = xhr.responseText.split(/=(.+)?/);
    if (resbits[0] === "EXISTS") alert("A submission already exists with this image!");
    else if (resbits[0] !== "DONE") alert("Something is wrong with your input data!");
    else window.location.href = "/s/" + resbits[1];
  };
  xhr.open("get", "/submit/add?title=" + encodeURIComponent(title.value)
                    + "&image=" + encodeURIComponent(image.value)
                  + "&artpage=" + encodeURIComponent(artpage.value)
                   + "&artist=" + encodeURIComponent(artist.value)
                     + "&tags=" + encodeURIComponent(tags.value));
  console.log("Sending...");
  xhr.send();
};
