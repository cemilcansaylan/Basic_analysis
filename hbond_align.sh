#!/bin/bash

export PATH="/Users/badaylab/Desktop/programs/cpptraj/bin:$PATH"

run_cpptraj() {

FOLDER="/Volumes/My_Book_Duo/work/projects/peptides_amphihiles/stupp_jacs2010/${1}/namd-${2}"
OUTPUT="/Volumes/My_Book_Duo/work/projects/peptides_amphihiles/stupp_jacs2010/${1}/analysis/${2}-analysis/hbond_align"
PREFIX=$1
min=$2
TOP=$FOLDER/$PREFIX.psf

  cpptraj <<EOF> cpptraj_hbond_align.log
parm $TOP

for TRAJ in $FOLDER/production_2?.dcd
trajin \$TRAJ 1 last 10
done

for i=120;i<=181;i++
hbond @CA,C,O,N,H angle \$i out ${OUTPUT}/${PREFIX}_${min}_\$i_hbond_align.dat avgout ${OUTPUT}/${PREFIX}_${min}_\$i_hbond_align_avg.dat nointramol
done

EOF


for i in {120..180}
do
	awk 'BEGIN { print "#Frame" "\t" "HB_00001[UU]" }
	FNR>1 && NR==FNR { hbond[$1]=$2; next }
	FNR>1 { printf "%d\t%d\n",$1, $2-hbond[$1] } ' ${OUTPUT}/${PREFIX}_${min}_$((i+1))_hbond_align.dat ${OUTPUT}/${PREFIX}_${min}_${i}_hbond_align.dat > ${OUTPUT}/${PREFIX}_hbond_align_$((i+1))_${i}.dat
done
}

export -f run_cpptraj

for i in pal-2v2a3e pal-2v4a3e pal-3a3v3e pal-3v3a3e pal-4v2a3e pal-4v4a3e
do 
run_cpptraj $i min100 &
run_cpptraj $i min200 &
run_cpptraj $i min500
done 

