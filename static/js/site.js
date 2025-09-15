window.createPlayer = function (src, container, opts) {
  document.fonts.load("1em JetBrains Mono").then(() => {
    return AsciinemaPlayer.create(src, container, {
      terminalFontFamily: "'JetBrains Mono', monospace",
      ...opts
    });
  }).catch(error => {
    return AsciinemaPlayer.create(src, container, opts);
  });
}
