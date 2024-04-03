{ pkgs, ... }:

let
  unikernel = pkgs.stdenv.mkDerivation {
    pname = "test_net.spt";
    buildInputs = [ pkgs.solo5 ];
    inherit (pkgs.solo5) version src;
    dontConfigure = true;
    dontInstall = true;
    dontFixup = true;
    buildPhase = ''
      cd tests/test_net
      solo5-elftool gen-manifest manifest.json manifest.c
      x86_64-solo5-none-static-cc -c manifest.c -o manifest.o
      x86_64-solo5-none-static-cc -c test_net.c -o test.o
      x86_64-solo5-none-static-ld -z solo5-abi=spt *.o -o $out
    '';
    passthru.kernelName = "test_net.spt";
  };
in {
  microvm = {
    kernel = unikernel;
    mem = 8;
    interfaces = [{
      type = "tap";
      id = "tap0";
      mac = "02:00:00:01:01:01";
    }];
    guestInterfaces.tap0 = "service0";
  };
}
