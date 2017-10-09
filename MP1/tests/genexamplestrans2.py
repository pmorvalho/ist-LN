#!env python3

examples = [
	"XCIX_",
	"XCIX_aa_",
	"batata_XXVIII_",
	"ir_tambem_"
]
for example in examples:
	with open("examples_t2/" + example + ".txt", "w") as numberfile:
		for i,c in enumerate(example):	
			numberfile.write("%d %d %s %s\n" % (i, i+1, c, c) )
		numberfile.write(str(i+1)+"\n")
