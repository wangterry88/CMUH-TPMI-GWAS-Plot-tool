#!/bin/bash
echo ""
echo "This script is to run TPMI mapping and perform GWAS analysis."
echo ""
echo ""
echo "Please specify the new Project name:"
read PROJECT
echo ""
echo ""

mkdir ./${PROJECT}
mkdir ./GWAS
mkdir ./GWAS/plot
mkdir ./output

echo "############# Step1: Perform TPMI Chip Mapping.... ###########"
echo ""
Rscript ./script/Step1.PatientID_to_TPMI.R
echo ""
echo "############# Step2: Perform GWAS Anaysis.... ###########"
echo ""
sh ./script/Step2.GWAS.sh
echo "When example mode, GWAS step will be skipped"
echo ""
echo "Example output will be in the following folder:"
echo ""
echo "./GWAS/Example.GWASresult.txt"
echo ""
echo "############# Step3: Plot the GWAS Manhattan QQ Plot.... ###########"
echo ""
Rscript ./script/Step3.Manhattan_QQ_Plot_PRSsumstat.R


echo "######### Final: Packaging ALL the results to your Project Folder.... #########"
echo ""
echo ""

mv ./GWAS ./${PROJECT}
mv ./output ./${PROJECT}

echo ""
echo ""
echo "#################################### Done #####################################"
