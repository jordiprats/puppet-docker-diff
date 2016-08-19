# puppet-docker-diff

```
[root@puppet2 ~]# bash aperture.science.sh apache uat ABCDEFG secret 8142 8150

              .,-:;//;:=,
          . :H@@@MM@M#H/.,+%;,
       ,/X+ +M@@M@MM%=,-%HMMM@X/,
     -+@MM; $M@@MH+-,;XMMMM@MMMM@+-
    ;@M@@M- XM@X;. -+XXXXXHHH@M@M#@/.
  ,%MM@@MH ,@%=             .---=-=:=,.
  =@#@@@MX.,                -%HX$$%%%:;
 =-./@M@M$                   .;@MMMM@MM:
 X@/ -$MM/                    . +MM@@@M$
,@M@H: :@:                    . =X#@@@@-
,@@@MMX, .                    /H- ;@M@M=
.H@@@@M@+,                    %MM+..%#$.
 /MMMM@MMH/.                  XM@MH; =;
  /%+%$XHH@$=              , .H@@@@MX,
   .=--------.           -%H.,@@@@@MX,
   .%MM@@@HHHXX$$$%+- .:$MMX =M@@MM%.
     =XMMM@MM@MM#H;,-+HMM@M+ /MMMX=
       =%@M@M#@$-.=$@MM@@@M; %M%=
         ,:+$+-,/H#MMMMMMM@= =,
               =++%%%%+/:-.

TEST CHAMBER: 201608171827


pas 1 d69a383a8df6525c977353f61ff9483d5d0812928d0ecbb5b14a81c65d360767 
.......................................................................... [ OK ]

new base image: c6759198441df81471da6d706de775875f476056b361ee24de7955b41a81dccf

pas 2 ce8c34b2265d4dc6c10820b4280a5c172610ad97ec4a932841914780abf8171a 
.............. [ OK ]

new base image: edf17b328203fb0208b00a42c663a9a86eb56206e28918d2c8a332f5dae22ba6

diff -Nur -x '*.dockertestinglog' -x '__db.00[1-4]' /root/diff.aperture/a.2NiK3AwYyugb6UFpsdBMLBgcSvi7Ft/rootfs/etc/audit/audit.rules /root/diff.aperture/b.H9ANYq5XuXna5mmZGJYpsSwV6veUD2/rootfs/etc/audit/audit.rules
--- /root/diff.aperture/a.2NiK3AwYyugb6UFpsdBMLBgcSvi7Ft/rootfs/etc/audit/audit.rules	2016-08-17 18:28:51.000000000 +0200
+++ /root/diff.aperture/b.H9ANYq5XuXna5mmZGJYpsSwV6veUD2/rootfs/etc/audit/audit.rules	2016-08-17 18:35:19.000000000 +0200
@@ -1,14 +1,62 @@
-# This file contains the auditctl rules that are loaded
-# whenever the audit daemon is started via the initscripts.
(...)
```
