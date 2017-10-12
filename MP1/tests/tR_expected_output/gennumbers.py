#!env python3

for number in range(1,100):
	with open(str(number) + ".expected", "w") as numberfile:
		numberfile.write(str(number)+"\n")
