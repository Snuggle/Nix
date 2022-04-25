final: prev:
let
  vscode-insider = prev.vscode.override {
    isInsiders = true;  };
in
{
  vscode = vscode-insider.overrideAttrs (oldAttrs: rec {
    src = (builtins.fetchTarball {
      url = "https://update.code.visualstudio.com/latest/linux-x64/insider";
      sha256 = "1l5z8nm9g41ikszlmdziq79aivxglq7xpf2bgc4dq981cjp6vbcx";
    });
    version = "latest";
  });
}
