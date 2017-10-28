#!/usr/bin/env python3

import nltk
from nltk import word_tokenize
from nltk.util import ngrams
from collections import Counter

import sys

def get_ngrams_without_smoothing(corpus, keyword):
	tokens = nltk.word_tokenize(corpus)
	bigrams = ngrams(tokens,2)

	count_unigrams = Counter(tokens)
	open("unigrams_"+ keyword +".txt","w").close() #reset output file
	with open("unigrams_"+ keyword +".txt","a") as output_unigrams:
		for k,v in count_unigrams.items():
			line = str(k) + "\t" + str(v) + "\n"
			output_unigrams.write(line)

	count_bigrams = Counter(bigrams)
	open("bigrams_"+ keyword +".txt","w").close() #reset output file
	with open("bigrams_"+ keyword +".txt","a") as output_bigrams:
		for k,v in count_bigrams.items():
			line = " ".join(k) + "\t" + str(v) + "\n"
			output_bigrams.write(line)


if __name__ == '__main__':
	input_corpus = open(sys.argv[1])
	corpus_text = input_corpus.read()

	get_ngrams_without_smoothing(corpus_text,sys.argv[2])
