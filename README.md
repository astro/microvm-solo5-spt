# Run a Solo5-SPT Unikernel on a microvm.nix host

This satisfies [the microvm.nix
conventions](https://astro.github.io/microvm.nix/conventions.html) in
order to run on a microvm.nix host.

```
$ sudo microvm -c test_net -f github:astro/microvm-solo5-spt
Created MicroVM test_net. Start with: systemctl start microvm@test_net.service
$ sudo systemctl start microvm@test_net.service
$ sudo systemctl status microvm@test_net.service
● microvm@test_net.service - MicroVM 'test_net'
     Loaded: loaded (/etc/systemd/system/microvm@.service; static)
     Active: active (running) since Thu 2024-04-04 01:41:20 CEST; 3s ago
    Process: 3833815 ExecStartPre=/nix/store/wakrd36r9dqirk0yczya7ahj2ml4zpx3-unit-script-microv>
   Main PID: 3833821 (solo5-spt)
         IP: 0B in, 0B out
         IO: 44.0K read, 0B written
      Tasks: 1 (limit: 33376)
     Memory: 300.0K
        CPU: 13ms
     CGroup: /system.slice/system-microvm.slice/microvm@test_net.service
             └─3833821 microvm@solo5-spt --mem=8 --net:service0=tap0 --net-mac:service0=02:00:00>

Apr 04 01:41:20 hare microvm@test_net[3833821]: ____/\___/ _|\___/____/
Apr 04 01:41:20 hare microvm@test_net[3833821]: Solo5: Bindings version v0.8.0
Apr 04 01:41:20 hare microvm@test_net[3833821]: Solo5: Memory map: 8 MB addressable:
Apr 04 01:41:20 hare microvm@test_net[3833821]: Solo5:   reserved @ (0x0 - 0xfffff)
Apr 04 01:41:20 hare microvm@test_net[3833821]: Solo5:       text @ (0x100000 - 0x103fff)
Apr 04 01:41:20 hare microvm@test_net[3833821]: Solo5:     rodata @ (0x104000 - 0x105fff)
Apr 04 01:41:20 hare microvm@test_net[3833821]: Solo5:       data @ (0x106000 - 0x107fff)
Apr 04 01:41:20 hare microvm@test_net[3833821]: Solo5:       heap >= 0x108000 < stack < 0x800000
Apr 04 01:41:20 hare microvm@test_net[3833821]: **** Solo5 standalone test_net ****
Apr 04 01:41:20 hare microvm@test_net[3833821]: [service0] Serving ping on 10.0.0.2, with MAC: 0>
```
