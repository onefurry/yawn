javascript:(function(){
  var i = document.querySelector("#submissionImg").src,
  t = document.querySelector(".submission-title").innerHTML,
  u = document.querySelector(".flex-submission-item-1 a").href,
  d = document.querySelectorAll(".tags-row .tags a"),
  s = window.location.href;
  a = [];
  d.forEach(function (g) {
    a.push(g.innerHTML);
  });
  window.location.href = "http://yawn.herokuapp.com/submit/add?redirect=true&image=" + encodeURIComponent(i)
  + "&title=" + encodeURIComponent(t) + "&artist=" + encodeURIComponent(u)
  + "&artpage=" + encodeURIComponent(s) + "&tags=" + encodeURIComponent(a.join(","));
})();
