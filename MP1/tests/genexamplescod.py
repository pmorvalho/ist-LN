#!env python3

examples = [
	"99_",
	"99_aa_",
	"batata_28_",
	"ir_tambem_",
	"biblioteca_do_palacio_de_monserrate_na_estante_a_esquerda_no_dia_14_de_novembro_pelas_10_23_de_maio_"
]
for example in examples:
	with open("examples_cod/" + example + ".txt", "w") as numberfile:
		for i,c in enumerate(example):	
			numberfile.write("%d %d %s %s\n" % (i, i+1, c, c) )
		numberfile.write(str(i+1)+"\n")
