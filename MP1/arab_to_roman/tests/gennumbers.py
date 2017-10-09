#!env python3

for number in range(1,100):
	with open("numbers/" + str(number) + ".txt", "w") as numberfile:
		for i,c in enumerate(str(number)):	
			numberfile.write("%d %d %s %s\n" % (i, i+1, c, c) )
		numberfile.write("%d %d %s %s\n" % (i+1, i+2, "_", "_") )
		numberfile.write(str(i+2)+"\n")
