#!/usr/bin/env python3


import sys


def clean_input_file(filename,word):
	output_file = filename.split(".out")[0] + ".final"
	open(output_file,"w").close() # reset output file
	with open(filename,"r") as f, open(output_file,"a") as out:
		for line in f:
			label, frase  = line.split("\t")
			if not any(x in label for x in ["#","?","n-é-verbo"]):
				if frase.lower().count(word) == 1:
					out.write(frase.replace(word,label))


if __name__ == '__main__':
	filename = sys.argv[1]
	word = sys.argv[2]
	clean_input_file(filename,word)