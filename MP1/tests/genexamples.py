#!env python3

examples = [
	"XCIX_",
	"XCIX_aa_",
	"batata_XXVIII_",
	"3513_aa_",
	"batata_332111_",
	"ir_tambem_",
	"3513_",
	"3513_XX_",
	"bXtXtX_332111_",
	"Vr_tX79m_",
	"Xs_21_pm_32111_d9_d9z97r0_3332111_3412_312_n_13_32111_31_0_",
	"3332111_3412_321_n_13_2111_321_0_3311_d9_jXn9Vr0_p9lXs_312_h_",
	"99_",
	"99_aa_",
	"batata_28_",
	"biblioteca_do_palacio_de_monserrate_na_estante_a_esquerda_no_dia_14_de_novembro_pelas_10_23_de_maio_",
	"vi_um_homem_em_o_monte_com_o_telescopio_",
	"veni_vidi_vici_",
	"mbmb_99_ee_iriribbii_",
	"mbmmmbbbobmmb_99_ee_iriribbii_",
	"alea_acta_esto_julio_cesar_49_bc_",
	"7mm7bb0b07_3513_99_VrVrLbbLL_",
	"77_3513_99_VrVrLbbLL_",
	"Xl9X_XctX_9st0_j8lL0_c9sXr_3413_bc_",
	"v9nL_vLdL_vLcL_"
]
for example in examples:
	with open("examples/" + example + ".txt", "w") as numberfile:
		for i,c in enumerate(example):	
			numberfile.write("%d %d %s %s\n" % (i, i+1, c, c) )
		numberfile.write(str(i+1)+"\n")
