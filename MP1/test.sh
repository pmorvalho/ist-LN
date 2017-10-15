# tests

cd tests

mkdir fst_in
mkdir fst_out

# Se faltarem os exemplos de palavras e os numeros
# mkdir examples
# mkdir numbers 
# python genexamples.py
# python gennumbers.py


T1=0 # Transdutor 1
T2=0 # Transdutor 2
T3=0 # Transdutor 3
TR=0 # Transdutor Romanos
COD=0 # Codificador
DESCOD=0 # Descodificador
INP=0 # Input
FAILED=0 # Failed tests
CLN=0 # Clean
SHOW_RESULT=0 # Show Result

function compile() { # compila os transdutores
	cd ..	
	./run.sh
	cd tests
}

function run_test () { # corre os testes gerais no respectivo transdutor

	fstcompose fst_in/$2.fst ../$1.fst | fstshortestpath > fst_out/test_$3_$2.fst
	fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait fst_out/test_$3_$2.fst | dot -Tpdf > test_$3_$2.pdf
	
	# remover eps e minimizar pra ter output mais bonito (opcional)
	fstrmepsilon fst_out/test_$3_$2.fst fst_out/test_$3_$2.fst

	fstprint --isymbols=syms.txt --osymbols=syms.txt fst_out/test_$3_$2.fst | sort -gr | awk -F " " '{print $4}' | grep -v "eps" | tr -d "\n" > output_$3/$2.output

	DIFF=$(diff output_$3/$2.output $3_expected_output/$2.expected)

	if [ -n "$DIFF" ]; then
		echo "TRANSDUTOR: $1
		"
		echo "INPUT: $2
		"
		echo "EXPECTED: $(cat $3_expected_output/$2.expected)"
		echo "OUTPUT: $(cat output_$3/$2.output)"	
		echo ""
		echo "------------------------------"
		FAILED=$(($FAILED+1))
	else
		if [ -s output_$3/$2.output ]; then
			echo ""
			echo "INPUT: $2
			"
			echo "OUTPUT: $(cat output_$3/$2.output)"	
			echo""
		fi	
	fi
}

function run_word_test () { # corre a respectiva word no trandutor respectivo

	fstcompose fst_in/$2.fst ../$1.fst | fstshortestpath > fst_out/test_$3_$2.fst
	fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait fst_out/test_$3_$2.fst | dot -Tpdf > test_$3_$2.pdf
	
	# remover eps e minimizar pra ter output mais bonito (opcional)
	fstrmepsilon fst_out/test_$3_$2.fst fst_out/test_$3_$2.fst

	echo "TRANSDUTOR: $1
	"
    	echo "INPUT: $2
    	"
    	echo "OUTPUT: $(fstprint --isymbols=syms.txt --osymbols=syms.txt fst_out/test_$3_$2.fst | sort -gr | awk -F " " '{print $4}' | grep -v "eps" | tr -d "\n")"
	echo""
	echo "------------------------------"

}

function word_test(){ # Chama a funcao de correr uma palavra nos respectivos transdutores

	python ../scripts/word2fst.py $1 > examples/$1.txt

	fstcompile --isymbols=syms.txt --osymbols=syms.txt < examples/$1.txt | fstarcsort > fst_in/$1.fst

	if [ $T1 -ne 0 ]; then
		run_word_test transdutor1 $1 t1
	fi
	if [ $T2 -ne 0 ]; then
		run_word_test transdutor2 $1 t2
	fi
	if [ $T3 -ne 0 ]; then
		run_word_test transdutor3 $1 t3
	fi
	if [ $COD -ne 0 ]; then
		run_word_test codificador $1 cod
	fi
	if [ $DESCOD -ne 0 ]; then
		run_word_test descodificador $1 descod
	fi

	rm examples/$1.txt

}

function test_Romanos(){ # Testa os numeros de 1 a 99 com o Transdutor de Romanos
	SHOW_RESULT=1
	echo ""
	echo ""
	echo "---------------------"
	echo "---------------------"
	echo "  transdutorRomanos  "
	echo "---------------------"
	echo "---------------------"
	echo ""
	echo ""
	for f in numbers/*.txt
	do
		filename=$(basename $f .txt)
		fstcompile --isymbols=syms.txt --osymbols=syms.txt $f | fstarcsort > fst_in/$filename.fst

		run_test transdutorRomanos $filename tR

	done
}	

function test_t1_t2_t3_cod_descod(){ # Testa os numeros de 1 a 99 com o Transdutor 1,2,3, Codificador e Descodificador
	SHOW_RESULT=1
	echo ""
	echo ""
	echo "---------------------"
	echo "---------------------"
	echo "    $1"
	echo "---------------------"
	echo "---------------------"
	echo ""
	echo ""
	for f in examples/*.txt
	do
		filename=$(basename $f .txt)
		fstcompile --isymbols=syms.txt --osymbols=syms.txt $f | fstarcsort > fst_in/$filename.fst

		run_test $1 $filename $2
		
	done

}

function clean(){ # limpa os outputs
	rm -r output_t1 output_t2 output_t3 output_tR output_cod output_descod
	mkdir output_t1 
	mkdir output_t2 
	mkdir output_t3 
	mkdir output_tR 
	mkdir output_cod 
	mkdir output_descod
}

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
	-c|--compile)
		compile
		echo "
		-------Compiling------
		"
	    shift
    ;;
    -a|--all)
		T1=1
		T2=1
		T3=1
		TR=1
		COD=1
		DESCOD=1
	    shift
    ;;
    -t1|--transdutor1)
	    T1=1
	    shift
    ;;
    -t2|--transdutor2)
	    T2=1
	    shift
    ;;
    -t3|--transdutor3)
	    T3=1
	    shift
    ;;
    -tR|--transdutorRomanos)
	    TR=1
	    shift
    ;;
    -cod|--codificador)
	    COD=1
	    shift
    ;;
    -descod|--descodificador)
	    DESCOD=1
	    shift
    ;;
    -cln|--clean)
	    CLN=1
	    shift
    ;;
    -i|--input)
		WORD=$2
	    INP=1
	    shift
	    shift
    ;;
    -h|--help)
	echo "USAGE: $0 [-c|--compile] [-a|--all] [-tR|--transdutorRomanos] [-t1|--transdutor1] [-t2|--transdutor2] [-t3|--transdutor3] [-cod|--codificador] [-descod|--descodificador] [-cln|--clean] [-i|--input word] 
	--> -c|--compile -- para compilar
	--> -a|--all -- para testar todos os transdutores
	--> -tR|--transdutorRomanos -- para testar todos o transdutor dos Romanos
	--> -t1|--transdutor1 -- para testar o transdutor 1
	--> -t2|--transdutor2 -- para testar o transdutor 2
	--> -t3|--transdutor3 -- para testar o transdutor 3
	--> -cod|--codificador -- para testar o codificador
	--> -descod|--descodificador -- para testar o codificador
	--> -cln|--clean  -- para limpar os outputs
	--> -i|--input word  -- para correr a word nos transdutor selecionados"
    shift
    ;;
    *)
	echo "test.sh: error: unrecognized arguments: $key"
	echo "Try [-h|--help] for help"
	shift
	;;    

esac
done

	if [ $INP -ne 1 ]; then
		if [ $TR -ne 0 ]; then
			test_Romanos
		fi
		if [ $T1 -ne 0 ]; then
			test_t1_t2_t3_cod_descod transdutor1 t1
		fi
		if [ $T2 -ne 0 ]; then
			test_t1_t2_t3_cod_descod transdutor2 t2
		fi
		if [ $T3 -ne 0 ]; then
			test_t1_t2_t3_cod_descod transdutor3 t3
		fi
		if [ $COD -ne 0 ]; then
			test_t1_t2_t3_cod_descod codificador cod
		fi
		if [ $DESCOD -ne 0 ]; then
			test_t1_t2_t3_cod_descod descodificador descod
		fi
		if [ $SHOW_RESULT -ne 0 ]; then
			echo ""
			echo ""
			echo "---------------------"
			echo "---------------------"
			echo "  FAILED TESTS: $FAILED"
			echo "---------------------"
			echo "---------------------"

		fi
	else 
		word_test $WORD	
	fi

	if [ $CLN -ne 0 ]; then
		clean
	fi	

rm *.pdf
rm -r fst_out fst_in 
cd ..
