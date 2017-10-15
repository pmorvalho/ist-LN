#!/bin/bash

rm *.fst

# ----------------------------------- TRANSDUTOR ROMANOS -----------------------------------

fstcompile --isymbols=syms.txt --osymbols=syms.txt roman2arab.txt  > roman2arab.fst

fstinvert	roman2arab.fst  transdutorRomanos.fst

fstrmepsilon transdutorRomanos.fst transdutorRomanos.fst

fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait  transdutorRomanos.fst | dot -Tpdf  >  transdutorRomanos.pdf


# ------------------------------------- TRANSDUTOR 1 ---------------------------------------

# transdutor que le um '_'

fstcompile --isymbols=syms.txt --osymbols=syms.txt transdutorTraco.txt  > transdutorTraco.fst

# cria um transdutor que transforma os numeros arabaes em romanos e le um '_' no final

fstconcat  transdutorRomanos.fst transdutorTraco.fst transdutorArabTraco.fst

python scripts/compact2fst.py compact-a-z.txt > transdutor-a-z.txt # descompacta o transdutor que le a-z e um _ no fim

fstcompile --isymbols=syms.txt --osymbols=syms.txt transdutor-a-z.txt  > transdutor-a-z.fst

fstunion transdutorArabTraco.fst transdutor-a-z.fst transdutor1.fst

fstclosure	transdutor1.fst transdutor1.fst

fstrmepsilon transdutor1.fst transdutor1.fst # necessario para os testes nao terem ramos diferentes para eps's 

fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait transdutor1.fst | dot -Tpdf  > transdutor1.pdf


# ------------------------------------- TRANSDUTOR 2 ---------------------------------------

python scripts/compact2fst.py compact2.txt > transdutor2.txt

fstcompile --isymbols=syms.txt --osymbols=syms.txt transdutor2.txt  > transdutor2.fst

fstclosure	transdutor2.fst transdutor2.fst

fstrmepsilon transdutor2.fst transdutor2.fst

fstarcsort transdutor2.fst transdutor2.fst

fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait transdutor2.fst | dot -Tpdf  > transdutor2.pdf

# ------------------------------------- TRANSDUTOR 3 ---------------------------------------

python scripts/compact2fst.py compact3.txt > transdutor3.txt

fstcompile --isymbols=syms.txt --osymbols=syms.txt transdutor3.txt  > transdutor3.fst

fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait transdutor3.fst | dot -Tpdf  > transdutor3.pdf


# ------------------------------------- CODIFICADOR ----------------------------------------

fstarcsort transdutor2.fst transdutor2.fst

fstcompose transdutor1.fst transdutor2.fst transdutor21.fst

fstarcsort transdutor3.fst transdutor3.fst

fstcompose transdutor21.fst transdutor3.fst codificador.fst

fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait codificador.fst | dot -Tpdf  > codificador.pdf


# ------------------------------------ DESCODIFICADOR --------------------------------------

fstinvert codificador.fst descodificador.fst

fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait descodificador.fst | dot -Tpdf  > descodificador.pdf

rm transdutorTraco.fst transdutorArabTraco.fst transdutor-a-z.fst transdutor2.txt transdutor3.txt 
rm roman2arab.fst transdutor21.fst transdutor-a-z.txt


# ------------------------------------ Email para codificar----------------------------------

filename=$(basename biblioteca_do_palacio_de_monserrate_na_estante_a_esquerda_no_dia_14_de_novembro_pelas_10_23_de_maio_ .txt)
fstcompile --isymbols=syms.txt --osymbols=syms.txt tests/examples/$filename".txt" | fstarcsort > $filename.fst


fstcompose $filename.fst transdutor1.fst | fstshortestpath | fstproject --project_output | fstrmepsilon > email_codificado_transdutor1_$filename.fst
fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait email_codificado_transdutor1_$filename.fst | dot -Tpdf > emails/email_codificado_transdutor1_$filename.pdf
	

fstcompose email_codificado_transdutor1_$filename.fst transdutor2.fst | fstshortestpath | fstproject --project_output | fstrmepsilon > email_codificado_transdutor2_$filename.fst
fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait email_codificado_transdutor2_$filename.fst | dot -Tpdf > emails/email_codificado_transdutor2_$filename.pdf


fstcompose email_codificado_transdutor2_$filename.fst transdutor3.fst | fstshortestpath | fstproject --project_output | fstrmepsilon > email_codificado_transdutor3_$filename.fst
fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait email_codificado_transdutor3_$filename.fst | dot -Tpdf > emails/email_codificado_transdutor3_$filename.pdf
		
fstcompose $filename.fst codificador.fst | fstshortestpath | fstproject --project_output | fstrmepsilon > email_codificado_codificador_$filename.fst
fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait email_codificado_codificador_$filename.fst | dot -Tpdf > emails/email_codificado_codificador_$filename.pdf

rm $filename.fst email_codificado_transdutor1_$filename.fst email_codificado_transdutor2_$filename.fst email_codificado_transdutor3_$filename.fst email_codificado_codificador_$filename.fst

# ------------------------------------ Emails para descodificar---------------------------------

fstinvert transdutor3.fst transdutor3inv.fst
fstinvert transdutor2.fst transdutor2inv.fst
fstinvert transdutor1.fst transdutor1inv.fst

function descodificar_email(){
	
filename=$1

fstcompile --isymbols=syms.txt --osymbols=syms.txt tests/examples/$filename".txt" | fstarcsort > $filename.fst

fstcompose $filename.fst transdutor3inv.fst | fstshortestpath | fstproject --project_output | fstrmepsilon > email_descodificado_transdutor3inv_$filename.fst
fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait email_descodificado_transdutor3inv_$filename.fst | dot -Tpdf > emails/email_descodificado_transdutor3inv_$filename.pdf

fstcompose email_descodificado_transdutor3inv_$filename.fst transdutor2inv.fst | fstshortestpath | fstproject --project_output | fstrmepsilon > email_descodificado_transdutor2inv_$filename.fst
fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait email_descodificado_transdutor2inv_$filename.fst | dot -Tpdf > emails/email_descodificado_transdutor2inv_$filename.pdf

fstcompose email_descodificado_transdutor2inv_$filename.fst transdutor1inv.fst | fstshortestpath | fstproject --project_output | fstrmepsilon > email_descodificado_transdutor1inv_$filename.fst
fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait email_descodificado_transdutor1inv_$filename.fst | dot -Tpdf > emails/email_descodificado_transdutor1inv_$filename.pdf	
	
fstcompose $filename.fst descodificador.fst | fstshortestpath | fstproject --project_output | fstrmepsilon > email_descodificado_descodificador_$filename.fst
fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait email_descodificado_descodificador_$filename.fst | dot -Tpdf > emails/email_descodificado_descodificador_$filename.pdf

rm $filename.fst email_descodificado_transdutor1inv_$filename.fst email_descodificado_transdutor2inv_$filename.fst email_descodificado_transdutor3inv_$filename.fst email_descodificado_descodificador_$filename.fst

}

descodificar_email $(basename Xs_21_pm_32111_d9_d9z97r0_3332111_3412_312_n_13_32111_31_0_ .txt)

descodificar_email $(basename 3332111_3412_321_n_13_2111_321_0_3311_d9_jXn9Vr0_p9lXs_312_h_ .txt)

rm transdutor3inv.fst transdutor2inv.fst transdutor1inv.fst
