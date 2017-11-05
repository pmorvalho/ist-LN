#!/usr/bin/env python3

# Grupo 19
# 80967, Daniel Correia
# 81151, Pedro Orvalho

import sys
import re
from nltk import word_tokenize

global unigrams, bigrams, params, phrases, V

def calculate_prob(phrase, word, lemmas):
	words = word_tokenize(phrase)
	smooth_results = []
	basic_results = []
	w_bef = w_after = ""
	count_w_bef = 0

	for i in range(len(words)):
		if words[i] == word:
			if i<len(words)-1:
				w_after=words[i+1]
				break
		elif i < len(words)-1:
			if words[i+1]==word:
				w_bef = words[i]
				if i < len(words) - 2:
					w_after = words[i+2]
				break

	for u in unigrams:
		if u[0] == w_bef:
			count_w_bef = int(u[1])	
			break

	for l in lemmas:
		count_lemma = 0
		bi_after  = 0
		bi_before = 0
		for u in unigrams:
			if l in u[0]:
				count_lemma = int(u[1])
				break
		for b in bigrams:
			bi = b[0].split(" ")
			if bi[0] == l and bi[1] == w_after:
				bi_after   = int(b[1])
			elif bi[1] == l and bi[0] == w_bef:
				bi_before  = int(b[1])

		print(bi_before,count_w_bef,bi_after,count_lemma,l)
		smooth_results.append((l, (((bi_before+1)/(count_w_bef+V))*((bi_after+1)/(count_lemma+V)))))
		try:
			basic_results.append( (l, (bi_before/count_w_bef)*(bi_after/count_lemma) ) )
		except ZeroDivisionError:
			basic_results.append( (l, -1))

	print("\n===================== SEM ALISAMENTO ============================")
	maximum = (lemmas[0],0)
	for r in basic_results:
		if maximum[1] < r[1]:
			maximum = r

	print(str(phrase), " -----> lema escolhido: ", maximum[0],sep="")
	for r in basic_results:
		print("lema: ",r[0], "   probabilidade: ", r[1],sep="")

	print("===================== COM ALISAMENTO ============================")
	maximum = (lemmas[0],0)
	for r in smooth_results:
		if maximum[1] < r[1]:
			maximum = r

	print(str(phrase), " -----> lema escolhido: ", maximum[0],sep="")
	for r in smooth_results:
		print("lema: ",r[0], "   probabilidade: ", r[1],sep="")


if __name__ == '__main__':
	if len(sys.argv)!=5:
		print("Err, four files needed: Unigrams, Bigrams, Parameterization and Examples")
	
	try:
		unigrams = open(sys.argv[1], "r+").readlines()
		unigrams = [line.strip().split("\t") for line in unigrams]

		V = len(unigrams)

		bigrams = open(sys.argv[2], "r+").readlines()
		bigrams = [line.strip().split("\t") for line in bigrams]

		params   = open(sys.argv[3], "r+").read().strip().split("\n")
		params[1] = params[1].split(" ")

		phrases  = open(sys.argv[4], "r+").read().strip().split("\n")

	except:
		print("Wrong format in files")
		raise

	print("Grupo 19 - Resultados com/sem alisamento")
	for p in phrases:
		calculate_prob(p, params[0], params[1])
	
