with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "gnome-keyring-yubikey-unlock-${version}";
  version = "git-2022-07-12";

  src = fetchFromGitHub {
    owner = "recolic";
    repo = "gnome-keyring-yubikey-unlock";
    rev = "6b91a1e95d10e2385e3d7dc852edf5a1f92dc849";
    sha256 = "1xryjkpliihwc7k6hif5c3ggdz37wxwxhgmqs0vycdbg09mcb6i2";
    fetchSubmodules = true;
    leaveDotGit = false;
  };

  buildInputs = [ autoconf automake libgnome-keyring gnumake pkg-config ];
  patchPhase = ''
    substituteInPlace src/Makefile --replace "../bin/" "./"
  '';
  buildPhase = ''
  	cd src/
  	make
  '';
  installPhase = ''
  	mkdir -p $out/bin
  	mkdir -p $out/bin/bin
  	ls -lah /build/source/src/
  	mv $NIX_BUILD_TOP/${src.name}/src/unlock_keyrings $out/bin/bin/
  	mv $NIX_BUILD_TOP/${src.name}/create_secret_file.sh $out/bin
  	mv $NIX_BUILD_TOP/${src.name}//unlock_keyrings.sh $out/bin
  '';
  #dontInstall = true;
}
