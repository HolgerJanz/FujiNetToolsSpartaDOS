# FujiNetToolsSpartaDOS
Native SpartaDOS Tools for FujiNet

This repository provides native [FujiNet](https://fujinet.online) tools for all SpartaDOS 3 compatible Atari 8-bit disk operation systems. For full support the command line interface must support upper and lower case because paths and file names on FujiNet are case-sensitive.  The assembler sources are compatible with [FastAssembler](https://github.com/HolgerJanz/FastAssembler) and [MADS](https://mads.atari8.info).

These tools are based on the SIO commands implemented by FujiNet. Current issues and limitations can be found in the official [tools](https://github.com/FujiNetWIFI/fujinet-config-tools/issues) and [firmware](https://github.com/FujiNetWIFI/fujinet-platformio/issues) repositories.


The current version of the tools is: 06-03-23 ($06,$03,$17)

The version can be found at byte offset 9 of every tool. The command DUMP can be use to retrieve it e.g.:

~~~
DUMP <tool>.COM 9 3
~~~

holgerjanz@abbuc.social
