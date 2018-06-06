./soapInDel -s soap.result.list  -f genome.fa -o indel-result.list
less indel-result.list  | awk '$7>19  &&  $8>3' > indel-result.filter
