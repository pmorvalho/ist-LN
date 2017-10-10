#!env python3

examples = [
	"3513_",
	"3513_XX_",
	"bXtXtX_332111_",
	"Vr_tX79m_"
]
for example in examples:
	with open("examples_decod/" + example + ".txt", "w") as numberfile:
		for i,c in enumerate(example):	
			numberfile.write("%d %d %s %s\n" % (i, i+1, c, c) )
		numberfile.write(str(i+1)+"\n")
