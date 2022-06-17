#!/bin/bash

export PATH="/ari/users/csaylan/programs/cpptraj/bin:$PATH"
alias plip='python3 /ari/users/csaylan/programs/plip/plip/plipcmd.py'
export PATH="/ari/users/csaylan/programs/gnu-parallel/src:$PATH"

run_cpptraj() {

FOLDER="/ari/users/csaylan/RyR2/FKBP_RYR2/AF2_model/fkbp_ryr2_dan/binding_pose_1/charmm-gui-4068239580/namd"
OUTPUT="."
PREFIX="step3_input"
TOP=$FOLDER/$PREFIX.psf

  cpptraj <<EOF> cpptraj_hbond_align.log
parm $TOP

trajin $FOLDER/step5_$1.dcd 1 last 1

strip :TIP3
strip :POT,CLA
trajout ensemble_$1.pdb pdb
run

EOF

#HSD, HIP, HIE are considered as ligand, thus change their name as HIS
sed -i 's/HSD/HIS/g' ensemble_$1.pdb
sed -i 's/HIP/HIS/g' ensemble_$1.pdb
sed -i 's/HIE/HIS/g' ensemble_$1.pdb
}

run_plip() {
for i in {1..10} #change according to your frame lenght of ensemble.pdb
do
	plip -f ensemble_$1.pdb --model $i -tq --nohydro --nofixfile --maxthreads 2

	less report.txt | grep -e \| -e \* > interaction_log.txt

	while IFS= read -r line;do
		if [[ $line == \** ]];then
			intname=`echo $line | sed -e 's/\*\*\(.*\)\*\*/\1/'`
			intname=`echo ${intname} | sed -e 's/ /_/g'`
			continue
		elif [[ $line == \|\ RESNR* ]];then
			continue
		fi

		#echo $line | cut -f 2,3 -d \| >> ${intname}
		echo $line >> ${intname}
	done < interaction_log.txt
done
}

export -f run_cpptraj
export -f run_plip


run_analysis() {
run_cpptraj $1
run_plip $1
rm ensemble_$1.pdb
}

export -f run_analysis
#Consider the --maxthreads value while asigning the cpu.
cpu=64 #128/2
parallel -j $cpu run_analysis {} ::: {1..200} 

