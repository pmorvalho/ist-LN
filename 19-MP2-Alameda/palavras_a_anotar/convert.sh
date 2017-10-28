#!/bin/bash

cp */*.out .

python convert_out_to_final.py vimosVerVir.out vimos
python convert_out_to_final.py cobreCobrarCobrir.out cobre
