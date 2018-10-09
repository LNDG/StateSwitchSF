#!/bin/bash

InputDir=$1
OutputDir=$2

cd ${InputDir}

subjDICOMS=( $(find * -maxdepth 1 -type d -name "*STSW*") )

for i in ${subjDICOMS[@]}
do

cutsub=$(echo $i | cut -c6-9)
echo ${cutsub}

if [ $i == "2202" ]
then

continue

else

subid=STSWD${cutsub}

OUTDIR=${OutputDir}/B_data/sub-${subid}/dwi
mkdir -p ${OUTDIR}/

cd ${i}/*/ 

AcqMatch=$(find `pwd` -type d -name "*64DIRS*")

mrconvert ${AcqMatch} ${OUTDIR}/sub-${subid}_acq-AP_dwi.mif -strides +1,2,3,4 -force -json_export ${OUTDIR}/sub-${subid}_acq-AP_dwi.json -export_grad_mrtrix ${OUTDIR}/sub-${subid}_acq-AP_dwi.b -export_grad_fsl ${OUTDIR}/sub-${subid}_acq-AP_dwi.bvecs ${OUTDIR}/sub-${subid}_acq-AP_dwi.bvals

InvMatch=$(find `pwd` -type d -name "*INVPE*")

mrconvert ${InvMatch} ${OUTDIR}/sub-${subid}_acq-PA_dwi.mif -strides +1,2,3,4 -force -json_export ${OUTDIR}/sub-${subid}_acq-PA_dwi.json -export_grad_mrtrix ${OUTDIR}/sub-${subid}_acq-PA_dwi.b -export_grad_fsl ${OUTDIR}/sub-${subid}_acq-PA_dwi.bvecs ${OUTDIR}/sub-${subid}_acq-PA_dwi.bvals

fi

cd ${InputDir}

done
