#!/usr/bin/env python3


import sys
import re

def clean_input_file(filename, word):
	output_file = filename.split(".out")[0] + ".final"
	open(output_file, "w").close() # reset output file
	with open(filename, "r") as read_f, open(output_file, "a") as out:
		for line in read_f:
			label, frase = line.split("\t")
			if not any(x in label for x in ["#", "?", "n-é-verbo"]):
				re_pat = r'\b' + word + r'\b'
				if len(re.findall(re_pat, frase.lower())) == 1:
					out.write(re.sub(re_pat,label,frase))


if __name__ == '__main__':
	clean_input_file(sys.argv[1], sys.argv[2])
