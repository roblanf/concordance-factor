#! /bin/bash

# $ -q hugemem.q
# $ -l virtual_free=10g,h_vmem=10.1g
#$ -l compute
#$ -S /bin/bash
#$ -pe threads 20
#$ -j y
#$ -r y
#$ -cwd
#$ -N concord
#$ -V
#$ -b y
#$ -m ea
#$ -M m.bui@anu.edu.au

dir=$1
max_loci=200
min_loci=10
step_loci=10
aln=alignment.nex
seed=1
threads=10

if [ "$2" == "" ]; then
	echo "Usage: $0 <DIR> <SUBSAMPLE> [EXTRA_OPTIONS]"
	exit 1
fi

min_loci=$2
max_loci=$2

for ((step=min_loci; step <= max_loci; step+=step_loci)); do


  prefix=u$step

  if [ ! -f $dir/$aln ]; then
    echo "ERROR: $dir/$aln not found"
    exit 2
  fi

  /project/pd-phylo/bin/iqtree2 -p $dir/$aln --prefix $dir/$prefix -T $threads -m TEST -bb 1000 --no-terrace --subsample $step --subsample-seed $seed ${@:3}

  /project/pd-phylo/bin/iqtree2 -S $dir/$aln --prefix $dir/"l"$step -T $threads -m TEST --subsample $step --subsample-seed $seed ${@:3}


done

