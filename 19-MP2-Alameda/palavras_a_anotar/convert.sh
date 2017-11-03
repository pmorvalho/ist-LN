#!/bin/bash

cp */*.out .

# converter ficheiros .out para .final
./convert_out_to_final.py vimosVerVir.out vimos
./convert_out_to_final.py cobreCobrarCobrir.out cobre

# gerar ficheiros dos unigrams e bigramas
./calculate_ngrams.py vimosVerVir.final vimos
./calculate_ngrams.py cobreCobrarCobrir.final cobre

# ordernar bigramas por ordem alfabetica (opcional)
cat bigrams_cobre.txt | sort > bigrams_sorted_cobre.txt
cat bigrams_vimos.txt | sort > bigrams_sorted_vimos.txt
