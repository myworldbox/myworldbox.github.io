const _0x4e3e = [
  "a.word",
  "css",
  "517180FzykLq",
  "scale(0.97)",
  ".menu",
  ".dropdown",
  "15359ZIcMjm",
  "scale(1)",
  ".mp3",
  "970397ynmdsg",
  "slideToggle",
  "html",
  "135QRQbXL",
  "1371094AtMYtn",
  "&#9776;",
  "play",
  "1653856jQbcsi",
  "music",
  "white",
  "src",
  "165240AoOuHn",
  "0.1vw\x20dashed\x20yellow",
  "onload",
  "click",
  "468835raejnT",
];
function _0x1c97(_0x582dde, _0x175c6c) {
  _0x582dde = _0x582dde - 0x17c;
  let _0x4e3e21 = _0x4e3e[_0x582dde];
  return _0x4e3e21;
}
const _0x4b07d2 = _0x1c97;
(function (_0x50de86, _0xc9da28) {
  const _0x148ba4 = _0x1c97;
  while (!![]) {
    try {
      const _0x41db90 =
        -parseInt(_0x148ba4(0x193)) +
        -parseInt(_0x148ba4(0x17e)) +
        parseInt(_0x148ba4(0x18c)) +
        parseInt(_0x148ba4(0x185)) +
        -parseInt(_0x148ba4(0x190)) +
        parseInt(_0x148ba4(0x182)) +
        parseInt(_0x148ba4(0x189)) * parseInt(_0x148ba4(0x18f));
      if (_0x41db90 === _0xc9da28) break;
      else _0x50de86["push"](_0x50de86["shift"]());
    } catch (_0x4b8224) {
      _0x50de86["push"](_0x50de86["shift"]());
    }
  }
})(_0x4e3e, 0xcd007),
  (window[_0x4b07d2(0x180)] = function () {
    const _0x226bf9 = _0x4b07d2;
    (random = Math["floor"](Math["random"]() * 0x9) + 0x1),
      (music = document["getElementById"](_0x226bf9(0x194))),
      (music[_0x226bf9(0x17d)] = "raw/music" + random + _0x226bf9(0x18b)),
      music[_0x226bf9(0x192)](),
      $(".menu")
        ["animate"]({ right: 0x0 }, 0x1388)
        [_0x226bf9(0x18d)](0x1f4)
        ["queue"](function () {
          const _0x432dcf = _0x226bf9;
          $(this)[_0x432dcf(0x184)]({
            background: "rgba(0,\x200,\x200,\x200.5)",
            border: _0x432dcf(0x17f),
          }),
            $(this)["dequeue"](),
            $(_0x432dcf(0x183))[_0x432dcf(0x18e)](_0x432dcf(0x191)),
            $(_0x432dcf(0x187))[_0x432dcf(0x18d)](0x1f4);
        }),
      $(function () {
        const _0x167fd8 = _0x226bf9;
        $(".menu")[_0x167fd8(0x181)](function () {
          const _0x13824a = _0x167fd8;
          $(_0x13824a(0x188))[_0x13824a(0x18d)](0x1f4);
        });
      }),
      $(function () {
        const _0x281c99 = _0x226bf9;
        let _0xc584e8 = 0x0;
        $(".contents")[_0x281c99(0x181)](function () {
          const _0xdd1dd1 = _0x281c99;
          _0xc584e8 == 0x0
            ? ($(this)[_0xdd1dd1(0x184)]({
                color: _0xdd1dd1(0x17c),
                transition: "transform\x201s",
                transform: _0xdd1dd1(0x18a),
              }),
              (_0xc584e8 = 0x1))
            : ($(this)["css"]({
                color: "lightgreen",
                transition: "transform\x201s",
                transform: _0xdd1dd1(0x186),
              }),
              (_0xc584e8 = 0x0));
        });
      });
  });
