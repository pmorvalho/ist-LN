#!env python3

for number in range(1,100):
	with open("numbers/" + str(number) + ".txt", "w") as numberfile:
		for i,c in enumerate(str(number)):	
			numberfile.write("%d %d %s %s\n" % (i, i+1, c, c) )
		numberfile.write(str(i)+"\n")
