# IDSSR
An Efficient Pipeline for identify Polymorphic SSRs with INDEL Features
This pipeline contains three parts. The function, usage and parameters of all the steps in every part were showed as following: 

Part one: Find out the simple sequence repeats in the genome and design the primer for them in ten steps.

s1.Find_PotentialSSR: Search for simple sequence repeats in FASTA-formatted DNA sequences.

USAGE: ./s1.Find_PotentialSSR [options] <sequences.fa> <ssr.out>
     --flank    set the flank length of ssr, default=150
     --ssr2	set the repeat numbers of motif two,default 4 times
     --ssr3	set the repeat numbers of motif three,default 4 times
     --ssr4     set the repeat numbers of motif four,default 4 times
     --ssr5     set the repeat numbers of motif five,default 4 times
     --ssr6     set the repeat numbers of motif six,default 4 times
Example:   ./s1.Find_PotentialSSR --flank 150 --ssr2 6 --ssr3 4 --ssr4 4 --ssr5 4 --ssr6 4  genome.sequences.fa ssr.out


s2.Designer_Primer: Using primer3 design primers that are targeted to amplify an SSR containing sequence region

Usage:./s2.Designer_Primer <ssrout_file> <raw_primer_file> <primer_results_file> 

s3.Primer_Filter: remove the primers with ssr.

Usage:./s3.Primer_Filter <primer_results_file> <rescreen_file> <blastin_file>


s4.Formatdb_Blast: alignment the primer sequences and the genome with Blast inorder to prevent the primer containing multi-mapping.

formatdb -i prefix.genome.fa -p F -o T

blastall -i prefix.blastin  -d genome.fa -p blastn -o prefix.blast.out -F F -b 10000 -v 10000

s5.Blast_Parse: extract the blast result as the 3` permit at most 1 mismatch.

Usage:perl ./s5.Blast_Parse <blast.out> <query_sbjct.out> <stac.out> <mis_match> 


s6.Primer_Pair_Generater: Get all the pair primers out of genome which match the same positon.

Usage:perl ./s6.Primer_Pair_Generater <query_sbjct_file> <primer.tab>


s7.Intermediate_Primer_Finder: Get the intermediate primer.

Usage: ./s7.Intermediate_Primer_Finder <primer.out> <rescreen_out> <inter_primer.out> 2000

if you want to find only position primers in the genome,please set the fourth parameter 0,else you can set the parameter other values default value is 2000.


s8.SSR_Product: Get the product with intermediate primer in the genome.

Usage: ./s8.SSR_Product <genome.fa> <inter_primer.out> <product.out>


s1.Find_PotentialSSR: Run s1.Find_PotentialSSR again to make sure the product and the repeat numbers of motif are consistent.


s9.SSR_Filter: Filter the results that contain more than one ssr to make sure one pair primer only producing one ssr.

Usage:./s9.SSR_Filter  <product_ssr.out> <inter_primer.out> <only_primer.out>


s10.Final_Primer_SSRs: Perform the final primer and ssr results.

Usage: ./S10.Final_Primer_SSRs <Only_scaffold.out> <product_ssr.out>  <rescreen.out> <final_primer.out>



Part two: Perform the indels calling.
I1.sh: Alignment for the sequenced reads and the genome squences with the soap2.

./2bwt-builder prefix.genome.fa

./soap2.21 -a cleanData_1.fq.gz -b cleanData_2.fq.gz  -D prefix.genome.fa.index -l 32 -p 6 -g 10 -o cleanData.soap.pe -2 cleanData.soap.se 2> soap.log


I2.sh: Call the indels from the genome with the soap results.

./soapInDel -s soap.result.list  -f genome.fa -o indel-result.list

less indel-result.list  | awk '$7>19  &&  $8>3' > indel-result.filter



Part one and part two can be concurrent execution.


Part three: Combine the final result.

SSR_INDEL.Combine: combining the results of part one and part two for identify polymorphic SSRs with INDEL features

USAGE:./SSR_INDEL.Combine <SSR final result file> <INDEL final result file>
