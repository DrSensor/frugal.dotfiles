{
  # https://nixos.org/manual/nixpkgs/stable/#sec-declarative-package-management
  packageOverrides = pkgs: with pkgs; {
    myIDE = pkgs.buildEnv {
      name = "myIDE";
      paths = let
        code-editor = [
          micro # normal editor
          kak # modal editor
        ];
        language-support = [
          # nix
          rnix-lsp
          nixpkgs-fmt
        ];
      in
        code-editor ++ language-support;
    };
  };
}
