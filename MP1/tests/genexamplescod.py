#!env python3

examples = [
	"99_",
	"99_aa_",
	"batata_28_",
	"ir_tambem_"
]
for example in examples:
	with open("examples_cod/" + example + ".txt", "w") as numberfile:
		for i,c in enumerate(example):	
			numberfile.write("%d %d %s %s\n" % (i, i+1, c, c) )
		numberfile.write(str(i+1)+"\n")
