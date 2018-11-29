#!/usr/bin/python
## ./run_ABC_polyploid.py [model] [name of the argfile] [bpfile]
## model = [diso1, diso2_auto, diso2_allo, tetra1, tetra2_auto, tetra2_allo, hetero1, hetero2_auto, hetero2_allo]
listModels = ["diso1", "diso2_auto", "diso2_allo", "tetra1", "tetra2_auto", "tetra2_allo", "hetero1", "hetero2_auto", "hetero2_allo"]

import sys
import os

help = "\n\trun_ABC_polyploid.py is a python script usefull to run some random simulations of 9 models\n\tof speciation between a diploid and a tetraploid\n"
help += "\tIt takes 3 arguments: 1) a demographic model; 2) the name of a file containing the arguments; 3) the name of the bpfile\n"
help += "\tThe accepted models are:\n\t\t{0}\n".format("\n\t\t".join(listModels))
help += "\n\tcommand line: ./run_ABC_polyploid.py [model] [name of the argfile] [bpfile]\n\n"

if len(sys.argv) != 4:
	print(help)
	print("\n\tThe expected number of arguments is 3\n\n")
	sys.exit()

model = sys.argv[1]
argfile = sys.argv[2]
bpfile = sys.argv[3]

if model not in listModels:
	print(help)
	print("\n\tThe model {0} is not in the list of expected models:\n{1}\n".format(model, "\n\t".join(listModels)))
	sys.exit()

if os.path.isfile(bpfile) == False:
	print(help)
	print("\n\t{0} is not found as a correct bpfile\n".format(bpfile))
	sys.exit()

if os.path.isfile(argfile) == False:
	print(help)
	print("\n\t{0} is not found as a correct argfile\n".format(argfile))
	sys.exit()

# get the number of loci
infile = open(bpfile, 'r')
tmp = infile.readline()
tmp = infile.readline().strip().split('\t')
nLoci = len(tmp)
infile.close()

# get the number of simulations 
infile = open(argfile, 'r')
for i in infile:
	if 'nreps' in i:
		i = i.strip().split('=')
		if i[0].strip() == 'nreps':
			nreps = int(i[1])
infile.close()

nsim = nreps * nLoci

## model = [diso1, diso2_auto, diso2_allo, tetra1, tetra2_auto, tetra2_allo, hetero1, hetero2_auto, hetero2_allo]
if model == "diso1":
	## WGD at the same time of split + diso
	command = "priorgenwgd --arg-file {0} --bpfile {1} --prior priorfile_{2}.txt | msnsam tbs {3} -t tbs -r tbs tbs -I 3 tbs tbs tbs 0 -m 2 3 tbs -m 3 2 tbs -n 1 tbs -n 2 tbs -n 3 tbs -g 2 tbs -g 3 tbs -ej tbs 3 2 -ej  tbs 2 1 -eN tbs tbs | mscalc_wgd.py".format(argfile, bpfile, model, nsim)

if model == "diso2_auto":
	## auto + diso
	command = "priorgenwgd --arg-file {0} --bpfile {1} --prior priorfile_{2}.txt | msnsam tbs {3} -t tbs -r tbs tbs -I 3 tbs tbs tbs 0 -m 2 3 tbs -m 3 2 tbs -n 1 tbs -n 2 tbs -n 3 tbs -g 2 tbs -g 3 tbs -ej tbs 3 2 -en tbs 2 tbs -ej tbs 2 1 -eN tbs tbs | mscalc_wgd.py".format(argfile, bpfile, model, nsim)

if model == "diso2_allo":
	## allo + diso
	command = "priorgenwgd --arg-file {0} --bpfile {1} --prior priorfile_{2}.txt | msnsam tbs {3} -t tbs -r tbs tbs -I 3 tbs tbs tbs 0 -m 2 3 tbs -m 3 2 tbs -n 1 tbs -n 2 tbs -n 3 tbs -g 2 tbs -g 3 tbs -ej tbs 3 1 -en tbs 2 tbs -eM tbs 0 -ej tbs 2 1 -eN tbs tbs | mscalc_wgd.py".format(argfile, bpfile, model, nsim)

if model == "tetra1":
	## WGD at the same time of split + tetra
	command = "priorgenwgd --arg-file {0} --bpfile {1} --prior priorfile_{2}.txt | msnsam tbs {3} -t tbs -r tbs tbs -I 3 tbs tbs tbs 0 -m 2 3 tbs -m 3 2 tbs -n 1 tbs -n 2 tbs -n 3 tbs -g 2 tbs -g 3 tbs -ej tbs 3 2 -ej  tbs 2 1 -eN tbs tbs | mscalc_wgd.py".format(argfile, bpfile, model, nsim)

if model == "tetra2_auto":
	## auto + tetra
	command = "priorgenwgd --arg-file {0} --bpfile {1} --prior priorfile_{2}.txt | msnsam tbs {3} -t tbs -r tbs tbs -I 3 tbs tbs tbs 0 -m 2 3 tbs -m 3 2 tbs -n 1 tbs -n 2 tbs -n 3 tbs -g 2 tbs -g 3 tbs -ej tbs 3 2 -en tbs 2 tbs -ej tbs 2 1 -eN tbs tbs | mscalc_wgd.py".format(argfile, bpfile, model, nsim)

if model == "tetra2_allo":
	## allo + tetra
	command = "priorgenwgd --arg-file {0} --bpfile {1} --prior priorfile_{2}.txt | msnsam tbs {3} -t tbs -r tbs tbs -I 3 tbs tbs tbs 0 -m 2 3 tbs -m 3 2 tbs -n 1 tbs -n 2 tbs -n 3 tbs -g 2 tbs -g 3 tbs -ej tbs 3 1 -en tbs 2 tbs -eM tbs 0 -ej tbs 2 1 -eN tbs tbs | mscalc_wgd.py".format(argfile, bpfile, model, nsim)

if model == "hetero1":
	## WGD at the same time of split + hetero
	command = "priorgenwgd --arg-file {0} --bpfile {1} --prior priorfile_{2}.txt | msnsam tbs {3} -t tbs -r tbs tbs -I 3 tbs tbs tbs 0 -m 2 3 tbs -m 3 2 tbs -n 1 tbs -n 2 tbs -n 3 tbs -g 2 tbs -g 3 tbs -ej tbs 3 2 -ej  tbs 2 1 -eN tbs tbs | mscalc_wgd.py".format(argfile, bpfile, model, nsim)

if model == "hetero2_auto":
	# auto + hetero
	command = "priorgenwgd --arg-file {0} --bpfile {1} --prior priorfile_{2}.txt | msnsam tbs {3} -t tbs -r tbs tbs -I 3 tbs tbs tbs 0 -m 2 3 tbs -m 3 2 tbs -n 1 tbs -n 2 tbs -n 3 tbs -g 2 tbs -g 3 tbs -ej tbs 3 2 -en tbs 2 tbs -ej tbs 2 1 -eN tbs tbs | mscalc_wgd.py".format(argfile, bpfile, model, nsim)

if model == "hetero2_allo":
	## allo + hetero
	command = "priorgenwgd --arg-file {0} --bpfile {1} --prior priorfile_{2} | msnsam tbs {3} -t tbs -r tbs tbs -I 3 tbs tbs tbs 0 -m 2 3 tbs -m 3 2 tbs -n 1 tbs -n 2 tbs -n 3 tbs -g 2 tbs -g 3 tbs -ej tbs 3 1 -en tbs 2 tbs -eM tbs 0 -ej tbs 2 1 -eN tbs tbs | mscalc_wgd.py".format(argfile, bpfile, model, nsim)

try:
	os.system(command)
except NameError:
	print("I don't know exactly why, but it doesn't work, sorry...")

	
