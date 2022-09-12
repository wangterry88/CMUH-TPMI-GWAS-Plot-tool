#!/bin/bash

echo "Enter the phenotype file (Full directory): "
read PHENO_COV  

echo "Output name of the GWAS result (Short Name): "
read GWAS_OUTPUT

#PHENO_COV=$1
#GWAS_OUTPUT=$2

BFILE=/media/volume1/bioinfo/TPMI_18W_imputed_QC_MAFQC/TPMI_18W_imputed_QC_MAF_0.01

#COVAR_NAME=`head -n 1 ${PHENO_COV} |cut -f 4- |sed 's/\t/,/g'`

#echo $COVAR_NAME

./tools/plink2 \
--bfile ${BFILE} \
--covar ${PHENO_COV} \
--covar-name Sex,Age \
--geno 0.05 \
--glm firth-fallback hide-covar \
--hwe 0.00001 \
--mind 0.1 \
--ci 0.95 \
--out ./GWAS/${GWAS_OUTPUT} \
--pheno ${PHENO_COV} \
--pheno-name  Pheno \
--memory 256000 \
--threads 120
#--maf 0.01 \



