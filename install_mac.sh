#!/bin/bash
echo check the R library abcrf
#wget https://cran.r-project.org/src/contrib/abcrf_1.7.1.tar.gz
#sudo R CMD INSTALL abcrf_1.7.1.tar.gz

echo check msnsam
if which msnsam >/dev/null; then
	echo msnsam is ok
else
	echo msnsam has to be installed
	gcc -O2 -o msnsam  msnsam.c  rand1.c streec.c -lm -w
	sudo ln -s $PWD/msnsam /usr/local/bin/
fi

for i in mscalc_wgd.py priorgenwgd priorgen_wgd_geneflow_v2.py run_ABC_polyploid.py run_ABC_polyploid_v2.py; do
	echo check ${i}
	if which ${i}>/dev/null; then
		echo ${i} is ok
	else
		echo ${i} not in the bin.
		chmod +x ${i} 
		sudo ln -s $PWD/${i} /usr/local/bin/
	fi
done

echo check pypy
if which pypy >/dev/null; then
	echo pypy is ok
else
	echo installation of pypy
	tar -xvf pypy2-v6.0.0-osx64.tar.bz2
	sudo ln -s $PWD/pypy2-v6.0.0-osx64/bin/pypy /usr/local/bin/
fi

