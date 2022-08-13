{ stdenv
, lib
, fetchFromGitHub
, bash
, subversion
, makeWrapper
, installShellFiles
}:
  stdenv.mkDerivation {
    name = "kubens";
    src = fetchFromGitHub {
      owner = "ahmetb";
      repo = "kubectx";
      rev = "v0.9.4";
      sha256 = "WY0zFt76mvdzk/s2Rzqys8n+DVw6qg7V6Y8JncOUVCM=";
    };
    buildInputs = [ bash subversion ];
    nativeBuildInputs = [ makeWrapper installShellFiles ];
    installPhase = ''
      mkdir -p $out/bin
      cp kubens $out/bin/kubens
      wrapProgram $out/bin/kubens \
        --prefix PATH : ${lib.makeBinPath [ bash subversion ]}

      runHook postInstall
    '';
    postInstall = ''
      installShellCompletion --cmd kubens --zsh completion/kubens.zsh
    '';
  }
