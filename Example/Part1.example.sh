./s1.Find_PotentialSSR  --flank 150 --ssr2 6 --ssr3 4 --ssr4 4 --ssr5 4 --ssr6 4 short.fa ssr.out
./s2.Designer_Primer ssr.out raw_primer_file primer_results_file 
./s3.Primer_Filter primer_results_file rescreen_file blastin_file
formatdb  -i short.fa -p F -o T
blastall -i blastin_file  -d short.fa -p blastn -o prefix.blast.out -F F -b 10000 -v 10000
 ./s5.Blast_Parse prefix.blast.out query_sbjct.out  stac.out  1
 ./s6.Primer_Pair_Generater query_sbjct.out primer.tab
./s7.Intermediate_Primer_Finder primer.tab rescreen_file  inter_primer.out 2000
./s8.SSR_Product short.fa inter_primer.out product.out
./s1.Find_PotentialSSR  --flank 150 --ssr2 6 --ssr3 4 --ssr4 4 --ssr5 4 --ssr6 4 product.out product.ssr.out
./s9.SSR_Filter product.ssr.out  inter_primer.out  only_primer.out
./s10.Final_Primer_SSRs only_primer.out product.ssr.out rescreen_file final_primer.out
