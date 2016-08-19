#!/bin/bash

#
# loading config
#

BASEDIR_THIS=$(dirname $0)
BASENAME_THIS=$(basename $0)

. $BASEDIR_THIS/${BASENAME_THIS%%.*}.config 2>/dev/null

BASEDIFF=${BASEDIFF-/tmp/diff.aperture}
IDDIRNAME=${IDDIRNAME-/tmp}


#
# code
#

TEST_CHAMBER=$(date +%Y%m%d%H%M)

cat <<"EOF"

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

EOF
echo -e "TEST CHAMBER: ${TEST_CHAMBER}\n\n"

mkdir -p $BASEDIFF

find $BASEDIFF -empty -type f -delete

DIFF_A=$(mktemp -d ${BASEDIFF}/a.XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX)
DIFF_B=$(mktemp -d ${BASEDIFF}/b.XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX)

if [ -z "$1" ];
then
	echo "usage: <type> <env> <customer> <magic hash> <source puppetinstance> <dest puppetinstance>"
	exit 1
fi

SOURCE_INSTANCE_NAME=$(docker ps | grep ":$5->" | grep puppetmaster | awk '{ print $NF }')
DESTIN_INSTANCE_NAME=$(docker ps | grep ":$6->" | grep puppetmaster | awk '{ print $NF }')

IP_SOURCE_INSTANCE_NAME=$(docker inspect ${SOURCE_INSTANCE_NAME} | grep -E '\bIPAddress\b' | cut -f2 -d: | cut -f2 -d\")
IP_DESTIN_INSTANCE_NAME=$(docker inspect ${DESTIN_INSTANCE_NAME} | grep -E '\bIPAddress\b' | cut -f2 -d: | cut -f2 -d\")

ID_RUN1=$(docker run -h $1.${TEST_CHAMBER}.eypdockertesting.run1 -d -e EYP_PUPPET_RUNID=1 -e EYP_CUSTOMER=$3 -e EYP_CUSTOMERHASH=$4 -e EYP_PUPPET_HOST_IP=${IP_SOURCE_INSTANCE_NAME} -e EYP_PUPPET_PORT=8140 -e EYP_ENV=$2 -e EYP_IDDIR=${IDDIRNAME} -t eyp/templatecentos6 bash /usr/local/bin/runme.sh)

echo "pas 1 ${ID_RUN1} "
while [ $(docker ps -a --filter="id=${ID_RUN1}" --filter status=running | wc -l) -gt 1 ];
do
	sleep 5;
	echo -n .
done
echo " [ OK ]"

echo -e "\nnew base image: $(docker commit ${ID_RUN1} aperture/${TEST_CHAMBER}.1)\n"

ID_RUN2=$(docker run -h $1.${TEST_CHAMBER}.eypdockertesting.run2 -d -e EYP_PUPPET_RUNID=2 -e EYP_CUSTOMER=$3 -e EYP_CUSTOMERHASH=$4 -e EYP_PUPPET_HOST_IP=${IP_DESTIN_INSTANCE_NAME} -e EYP_PUPPET_PORT=8140 -e EYP_ENV=$2 -e EYP_IDDIR=${IDDIRNAME} -t aperture/${TEST_CHAMBER}.1 bash /usr/local/bin/runme.sh)

echo "pas 2 ${ID_RUN2} "
while [ $(docker ps -a --filter="id=${ID_RUN2}" --filter status=running | wc -l) -gt 1 ];
do
        sleep 5;
	echo -n .
done
echo " [ OK ]"

echo -e "\nnew base image: $(docker commit ${ID_RUN2} aperture/${TEST_CHAMBER}.2)\n"

ID_BASE=$(docker run -d -t aperture/${TEST_CHAMBER}.1 bash /usr/local/bin/loop.sh)
ID_CHANGES=$(docker run -d -t aperture/${TEST_CHAMBER}.2 bash /usr/local/bin/loop.sh)

mount /dev/mapper/*-${ID_BASE} $DIFF_A
mount /dev/mapper/*-${ID_CHANGES} $DIFF_B

diff -Nur -x "*.dockertestinglog" -x "__db.00[1-4]" $DIFF_A/rootfs $DIFF_B/rootfs 2>/dev/null

umount /dev/mapper/*-${ID_BASE}
umount /dev/mapper/*-${ID_CHANGES}

docker stop ${ID_BASE} ${ID_CHANGES}
