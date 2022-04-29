final: prev:
let
  vscode-insider = prev.vscode.override {
    isInsiders = true;  };
in
{
  vscode = vscode-insider.overrideAttrs (oldAttrs: rec {
    src = (builtins.fetchTarball {
      url = "https://update.code.visualstudio.com/latest/linux-x64/insider";
      sha256 = "0znlzj20yvps80irnivsmqm785rgbp9f8snz0wyh79slzrpj5r30";
    });
    version = "latest";
  });
}
