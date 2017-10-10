#!env python3

examples = [
	"3513_",
	"3513_XX_",
	"bXtXtX_332111_",
	"Vr_tX79m_",
	"Xs_21_pm_32111_d9_d9z97r0_3332111_3412_312_n_13_32111_31_0_",
	"3332111_3412_321_n_13_2111_321_0_3311_d9_jXn9Vr0_p9lXs_312_h_"
]
for example in examples:
	with open("examples_decod/" + example + ".txt", "w") as numberfile:
		for i,c in enumerate(example):	
			numberfile.write("%d %d %s %s\n" % (i, i+1, c, c) )
		numberfile.write(str(i+1)+"\n")
