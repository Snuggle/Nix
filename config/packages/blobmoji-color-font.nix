{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation rec {
  pname = "blobmoji-color-font";
  version = "14.0.1";

  # We fetch the prebuilt font because building it takes 1.5 hours on hydra.
  # Relevant issue: https://github.com/NixOS/nixpkgs/issues/97871
  src = fetchurl {
    url = "https://github.com/C1710/blobmoji/releases/download/v${version}/Blobmoji.ttf";
    sha256 = "sha256-w9s7uF6E6nomdDmeKB4ATcGB/5A4sTwDvwHT3YGXz8g=";
  };

  dontUnpack = true;

  dontBuild = true;

  installPhase = ''
    install -Dm755 $src $out/share/fonts/truetype/Blobmoji.ttf
  '';

  meta = with lib; {
    description = "Color emoji SVGinOT font using Twitter Unicode 10 emoji with diversity and country flags";
    longDescription = ''
      A color and B&W emoji SVGinOT font built from the Twitter Emoji for
      Everyone artwork with support for ZWJ, skin tone diversity and country
      flags.

      The font works in all operating systems, but will currently only show
      color emoji in Firefox, Thunderbird, Photoshop CC 2017, and Windows Edge
      V38.14393+. This is not a limitation of the font, but of the operating
      systems and applications. Regular B&W outline emoji are included for
      backwards/fallback compatibility.
    '';
    homepage = "https://github.com/C1710/blobmoji/";
    downloadPage = "https://github.com/C1710/blobmoji/releases";
    license = with licenses; [ cc-by-40 mit ];
    maintainers = [ maintainers.snuggle ];
  };
}
