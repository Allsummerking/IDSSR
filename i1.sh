./2bwt-builder prefix.genome.fa
./soap2.21 -a cleanData_1.fq.gz -b cleanData_2.fq.gz  -D prefix.genome.fa.index -l 32 -p 6 -g 10 -o cleanData.soap.pe -2 cleanData.soap.se 2> soap.log
