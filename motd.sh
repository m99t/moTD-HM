#!/bin/bash
#clear
#
#                                             [HM-NETWORK]
#
#                                Title   [      MoTD.sh               ]
#                                Date    [ 21 - Jan - 2018            ]
#                                Authors [ Sean Murphy,               ]

#Ram

hw_mem=0
free_mem=0
human=1024

mem_info=$(</proc/meminfo)
mem_info=$(echo $(echo $(mem_info=${mem_info// /}; echo ${mem_info//kB/})))
for m in $mem_info; do
        if [[ ${m//:*} = MemTotal ]]; then
                memtotal=${m//*:}
        fi

        if [[ ${m//:*} = MemFree ]]; then
                memfree=${m//*:}
        fi

        if [[ ${m//:*} = Buffers ]]; then
                membuffer=${m//*:}
        fi

        if [[ ${m//:*} = Cached ]]; then
                memcached=${m//*:}
        fi
done

usedmem="$(((($memtotal - $memfree) - $membuffer - $memcached) / $human))"
totalmem="$(($memtotal / $human))"

mem="${usedmem}MB / ${totalmem}MB"

#Hostname
hostname=$hostname

#Disk Useages
totaldisk=$(df -h --total 2>/dev/null | tail -1)
diskusedper=$(awk '{print $5}' <<< "${totaldisk}")

#ANSI colours
White="\033[01;37m"
Blue="\033[1;34m"
Green="\033[0;32m"

# Echo message.

echo -e "
\a

$Blue
                  NNmmmmmmmmmmmNN
             NNNdhhhhhhhhhhhhhhhhdmdN
          NmmmmmmhhhhhhhhhhhhhhhhyyyyydN
        Nmmmmmmmmdhhhhhdmhhhhhhhyyyyyyyyym
      Nmmmmmmmmmmmdhhhhhhhhhhhhyyyyyyyyyyyym
    NmmmmmmNmmmmmmmdhddmmmmddhyyyyyyyyyyyyyyhN
   NmmmmmmmmmmmmmmN           mdyyyyyyyyyyyyyyN
  mhdmmmmmmmmmmmN                myyyyyyyyyyyyyN
 m+++osydmmmmmN                   Nyyyyyyyyyyyyh
 s+++++++osyhm                     Nyyyhhyyyyyyym
N+++++++++++o                       myyyyyyyyyyyh
m+++++++++++y                        yyyyyyyyyyys
h++++++ys+++h                        yyyyyyyyyyhh
m+++++++++++s                       Nyyyyyyyyyyyy
N+++++++++++/d                      hyyyyyyyyyyyd
 y++++//:-...-N                    myysyyhyyyyysN
 Nh:-.........-h                  dyyyyyyyyyyyyd
  m-............:h             Nh++syyyyyyyyyyd
   m:.............-oydmNNNNmdyo+////+syyyyyyyd
     o............-:::::::::::////////+syyyym
      my-........-::::::::::::://///////ydd
        do-.....-:::::::o:::::::///////oh
           ho:--::::::::+:::::::///+ohN
               dso/:::::::::::/+hmm
                     NNdddmNn

                                      HM-Network

$White
                    HM-Network

              UID:$HOSTNAME
                  UsedSpace: $diskusedper
            Free RAM: $mem
"
sleep 1
tput bel

#Reset term colour

echo -e $White
echo

