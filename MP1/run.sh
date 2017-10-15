#!/bin/bash

rm fsts/*.fst
rm pdfs/*.pdf
rm emails/*.pdf


# ----------------------------------- TRANSDUTOR ROMANOS -----------------------------------

fstcompile --isymbols=syms.txt --osymbols=syms.txt txts/roman2arab.txt  > roman2arab.fst

fstinvert	roman2arab.fst  fsts/transdutorRomanos.fst

fstrmepsilon fsts/transdutorRomanos.fst fsts/transdutorRomanos.fst

fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait  fsts/transdutorRomanos.fst | dot -Tpdf  >  pdfs/transdutorRomanos.pdf


# ------------------------------------- TRANSDUTOR 1 ---------------------------------------

# transdutor que le um '_'

fstcompile --isymbols=syms.txt --osymbols=syms.txt txts/transdutorTraco.txt  > transdutorTraco.fst

# cria um transdutor que transforma os numeros arabaes em romanos e le um '_' no final

fstconcat  fsts/transdutorRomanos.fst transdutorTraco.fst transdutorArabTraco.fst

python scripts/compact2fst.py txts/compact-a-z.txt > transdutor-a-z.txt # descompacta o transdutor que le a-z e um _ no fim

fstcompile --isymbols=syms.txt --osymbols=syms.txt transdutor-a-z.txt  > transdutor-a-z.fst

fstunion transdutorArabTraco.fst transdutor-a-z.fst fsts/transdutor1.fst

fstclosure	fsts/transdutor1.fst fsts/transdutor1.fst

fstrmepsilon fsts/transdutor1.fst fsts/transdutor1.fst # necessario para os testes nao terem ramos diferentes para eps's 

fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait fsts/transdutor1.fst | dot -Tpdf  > pdfs/transdutor1.pdf

rm transdutor-a-z.txt

# ------------------------------------- TRANSDUTOR 2 ---------------------------------------

python scripts/compact2fst.py txts/compact2.txt > transdutor2.txt

fstcompile --isymbols=syms.txt --osymbols=syms.txt transdutor2.txt  > fsts/transdutor2.fst

fstclosure	fsts/transdutor2.fst fsts/transdutor2.fst

fstrmepsilon fsts/transdutor2.fst fsts/transdutor2.fst

fstarcsort fsts/transdutor2.fst fsts/transdutor2.fst

fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait fsts/transdutor2.fst | dot -Tpdf  > pdfs/transdutor2.pdf

rm transdutor2.txt

# ------------------------------------- TRANSDUTOR 3 ---------------------------------------

python scripts/compact2fst.py txts/compact3.txt > transdutor3.txt

fstcompile --isymbols=syms.txt --osymbols=syms.txt transdutor3.txt  > fsts/transdutor3.fst

fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait fsts/transdutor3.fst | dot -Tpdf  > pdfs/transdutor3.pdf

rm transdutor3.txt 

# ------------------------------------- CODIFICADOR ----------------------------------------

fstarcsort fsts/transdutor2.fst fsts/transdutor2.fst

fstcompose fsts/transdutor1.fst fsts/transdutor2.fst transdutor21.fst

fstarcsort fsts/transdutor3.fst fsts/transdutor3.fst

fstcompose transdutor21.fst fsts/transdutor3.fst fsts/codificador.fst

fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait fsts/codificador.fst | dot -Tpdf  > pdfs/codificador.pdf


# ------------------------------------ DESCODIFICADOR --------------------------------------

fstinvert fsts/codificador.fst fsts/descodificador.fst

fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait fsts/descodificador.fst | dot -Tpdf  > pdfs/descodificador.pdf


# ------------------------------------ Email para codificar----------------------------------

filename=$(basename biblioteca_do_palacio_de_monserrate_na_estante_a_esquerda_no_dia_14_de_novembro_pelas_10_23_de_maio_ .txt)
fstcompile --isymbols=syms.txt --osymbols=syms.txt tests/examples/$filename".txt" | fstarcsort > $filename.fst


fstcompose $filename.fst fsts/transdutor1.fst | fstshortestpath | fstproject --project_output | fstrmepsilon > email_codificado_transdutor1_$filename.fst
fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait email_codificado_transdutor1_$filename.fst | dot -Tpdf > emails/email_codificado_transdutor1_$filename.pdf
	

fstcompose email_codificado_transdutor1_$filename.fst fsts/transdutor2.fst | fstshortestpath | fstproject --project_output | fstrmepsilon > email_codificado_transdutor2_$filename.fst
fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait email_codificado_transdutor2_$filename.fst | dot -Tpdf > emails/email_codificado_transdutor2_$filename.pdf


fstcompose email_codificado_transdutor2_$filename.fst fsts/transdutor3.fst | fstshortestpath | fstproject --project_output | fstrmepsilon > email_codificado_transdutor3_$filename.fst
fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait email_codificado_transdutor3_$filename.fst | dot -Tpdf > emails/email_codificado_transdutor3_$filename.pdf
		
fstcompose $filename.fst fsts/codificador.fst | fstshortestpath | fstproject --project_output | fstrmepsilon > email_codificado_codificador_$filename.fst
fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait email_codificado_codificador_$filename.fst | dot -Tpdf > emails/email_codificado_codificador_$filename.pdf

# ------------------------------------ Emails para descodificar---------------------------------

fstinvert fsts/transdutor3.fst transdutor3inv.fst
fstinvert fsts/transdutor2.fst transdutor2inv.fst
fstinvert fsts/transdutor1.fst transdutor1inv.fst

function descodificar_email(){
	
filename=$1

fstcompile --isymbols=syms.txt --osymbols=syms.txt tests/examples/$filename".txt" | fstarcsort > $filename.fst

fstcompose $filename.fst transdutor3inv.fst | fstshortestpath | fstproject --project_output | fstrmepsilon > email_descodificado_transdutor3inv_$filename.fst
fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait email_descodificado_transdutor3inv_$filename.fst | dot -Tpdf > emails/email_descodificado_transdutor3inv_$filename.pdf

fstcompose email_descodificado_transdutor3inv_$filename.fst transdutor2inv.fst | fstshortestpath | fstproject --project_output | fstrmepsilon > email_descodificado_transdutor2inv_$filename.fst
fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait email_descodificado_transdutor2inv_$filename.fst | dot -Tpdf > emails/email_descodificado_transdutor2inv_$filename.pdf

fstcompose email_descodificado_transdutor2inv_$filename.fst transdutor1inv.fst | fstshortestpath | fstproject --project_output | fstrmepsilon > email_descodificado_transdutor1inv_$filename.fst
fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait email_descodificado_transdutor1inv_$filename.fst | dot -Tpdf > emails/email_descodificado_transdutor1inv_$filename.pdf	
	
fstcompose $filename.fst fsts/descodificador.fst | fstshortestpath | fstproject --project_output | fstrmepsilon > email_descodificado_descodificador_$filename.fst
fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait email_descodificado_descodificador_$filename.fst | dot -Tpdf > emails/email_descodificado_descodificador_$filename.pdf

}

descodificar_email $(basename Xs_21_pm_32111_d9_d9z97r0_3332111_3412_312_n_13_32111_31_0_ .txt)

descodificar_email $(basename 3332111_3412_321_n_13_2111_321_0_3311_d9_jXn9Vr0_p9lXs_312_h_ .txt)

rm *.fst