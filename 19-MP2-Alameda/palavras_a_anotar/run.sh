#!/bin/bash

# Grupo 19
# 80967, Daniel Correia
# 81151, Pedro Orvalho

cp */*.out .

# converter ficheiros .out para .final
./convert_out_to_final.py vimosAnotado.out vimos
./convert_out_to_final.py cobreAnotado.out cobre

# gerar ficheiros dos unigrams e bigramas
./calculate_ngrams.py vimosAnotado.final vimos
./calculate_ngrams.py cobreAnotado.final cobre

# ordernar bigramas por ordem alfabetica (opcional)
cat cobreBigramas.txt | sort > cobreBigramas-sorted.txt
cat vimosBigramas.txt | sort > vimosBigramas-sorted.txt

mv cobreBigramas-sorted.txt cobreBigramas.txt
mv vimosBigramas-sorted.txt vimosBigramas.txt

./lemmaDealer.py vimosUnigramas.txt vimosBigramas.txt vimosParametrizacao.txt vimosFrases.txt

echo "\n\n\n\n"

./lemmaDealer.py cobreUnigramas.txt cobreBigramas.txt cobreParametrizacao.txt cobreFrases.txt