{ config, pkgs, lib, ... }:

let
  microvmConfig = config.microvm;
  command = builtins.concatStringsSep " " (
    [
      (lib.meta.getExe' pkgs.solo5 "solo5-spt")
      "--mem=${toString microvmConfig.mem}"
    ]
    ++
    (builtins.concatMap ({ type, id, mac, ... }:
      assert type == "tap";
      let
        guestId = microvmConfig.guestInterfaces.${id} or id;
      in [
        "--net:${guestId}=${id}"
        "--net-mac:${guestId}=${mac}"
      ]) microvmConfig.interfaces)

    ++ (map ({ label, image, ... }:
      assert label != null;
      "--block:${label}=${image}") microvmConfig.volumes)

    ++ [ microvmConfig.kernel ]);

  execArg = lib.optionalString microvmConfig.prettyProcnames
    ''-a "microvm@solo5-spt"'';

  runScriptBin = pkgs.buildPackages.writeScriptBin "microvm-run" ''
    #! ${pkgs.runtimeShell} -e

    ${microvmConfig.preStart}

    exec ${execArg} ${command}
  '';

in {
  options.microvm.guestInterfaces = lib.mkOption {
    type = with lib.types; attrsOf str;
    default = {};
  };

  config.microvm = {
    declaredRunner = lib.mkForce config.microvm.runner.solo5-spt;
    runner.solo5-spt = pkgs.runCommand "runner" {
      # for `nix run`
      meta.mainProgram = "microvm-run";
      passthru = {
        canShutdown = false;
        supportsNotifySocket = false;
        hypervisor = config.microvm.hypervisor;
      };
    } ''
      mkdir -p $out/bin
      ln -s ${runScriptBin}/bin/microvm-run $out/bin/microvm-run

      mkdir -p $out/share/microvm
      ln -s ${microvmConfig.kernel} $out/share/microvm/system

      echo vnet_hdr > $out/share/microvm/tap-flags
      ${lib.concatMapStringsSep " " (interface:
        lib.optionalString (interface.type == "tap" && interface ? id) ''
          echo "${interface.id}" >> $out/share/microvm/tap-interfaces
        '') microvmConfig.interfaces}
    '';
  };
}
