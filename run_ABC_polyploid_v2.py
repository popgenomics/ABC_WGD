#!/usr/bin/python
## ./run_ABC_polyploid.py [model] [name of the argfile] [bpfile]
## model = [diso1, diso2_auto, diso2_allo, tetra1, tetra2_auto, tetra2_allo, hetero1, hetero2_auto, hetero2_allo]
listModels = ["auto", "allo"]

import sys
import os

help = "\n\trun_ABC_polyploid.py is a python script usefull to run some random simulations of models\n\tof speciation between a diploid and a tetraploid\n"
help += "\tIt takes 4 arguments:\n\t\t1) a demographic model (auto, allo);\n\t\t2) a model of inheritance (disomic, heterosomic, tetrasomic);\n\t\t3) the name of the bpfile;\n\t\t4) the number of replicates (an integer)\n"
help += "\n\tThe accepted models are:\n\t\t{0}\n".format("\n\t\t".join(listModels))
help += "\n\tcommand line: ./run_ABC_polyploid.py [model] [inheritance] [bpfile] [nreps]\n\n"

if len(sys.argv) != 5:
	print(help)
	print("\n\tThe expected number of arguments is 3\n\n")
	sys.exit()

model = sys.argv[1]
inheritance = sys.argv[2]
bpfile = sys.argv[3]
nreps = int(sys.argv[4])

if model not in listModels:
	print(help)
	print("\n\tThe model {0} is not in the list of expected models:\n{1}\n".format(model, "\n\t".join(listModels)))
	sys.exit()

if os.path.isfile(bpfile) == False:
	print(help)
	print("\n\t{0} is not found as a correct bpfile\n".format(bpfile))
	sys.exit()

if inheritance == 'disomic':
	alpha1=0
	alpha2=0

if inheritance == 'tetrasomic':
	alpha1=1
	alpha2=1

if inheritance == 'heterosomic':
	alpha1=0
	alpha2=1

# get the number of loci
infile = open(bpfile, 'r')
tmp = infile.readline()
tmp = infile.readline().strip().split('\t')
nLoci = len(tmp)
infile.close()

# get the number of simulations 
#infile = open(argfile, 'r')
#for i in infile:
#	if 'nreps' in i:
#		i = i.strip().split('=')
#		if i[0].strip() == 'nreps':
#			nreps = int(i[1])
#infile.close()

nsim = nreps * nLoci

if model == "auto":
	command = "priorgen_wgd_geneflow_v2.py bpfile={0} n1=0 n1=1 n2=1 n2=2 nA=2 nA=3 tau=0 tau=4 alpha={4} alpha={5} nreps={1} M=0 M=10 shape1=0 shape1=10 shape2=0 shape2=100 model={2} migModel=migAB symModel=asym MVariation=hetero parameters=output_{2}.txt | msnsam tbs {3} -t tbs -r tbs tbs -I 3 tbs tbs tbs 0 -m 1 2 tbs -m 2 1 tbs -m 1 3 tbs -m 3 1 tbs -m 2 3 tbs -m 3 2 tbs -n 1 tbs -n 2 tbs -n 3 tbs -g 2 tbs -g 3 tbs -ej tbs 3 2 -en tbs 2 tbs -ej tbs 2 1 -eN tbs tbs".format(bpfile, nreps, model, nsim, alpha1, alpha2)

if model == "allo":
	command = "priorgen_wgd_geneflow_v2.py bpfile={0} n1=0 n1=1 n2=1 n2=2 nA=2 nA=3 tau=0 tau=4 alpha={4} alpha={5} nreps={1} M=0 M=10 shape1=0 shape1=10 shape2=0 shape2=100 model={2} migModel=migAB symModel=asym MVariation=hetero parameters=output_{2}.txt | msnsam tbs {3} -t tbs -r tbs tbs -I 3 tbs tbs tbs 0 -m 1 2 tbs -m 2 1 tbs -m 1 3 tbs -m 3 1 tbs -m 2 3 tbs -m 3 2 tbs -n 1 tbs -n 2 tbs -n 3 tbs -g 2 tbs -g 3 tbs -ej tbs 3 1 -en tbs 2 tbs -em tbs 1 2 0 -em tbs 2 1 0 -ej tbs 2 1 -eN tbs tbs".format(bpfile, nreps, model, nsim, alpha1, alpha2)

try:
	os.system(command)
except NameError:
	print("I don't know exactly why, but it doesn't work, sorry...")


