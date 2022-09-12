setwd("./")

#args = commandArgs(trailingOnly=TRUE)

cat(prompt="Input your patient list (Full directory): ")
Input_list<-readLines(con="stdin",1)

cat(prompt="Output file name (Short Name): ")
Output_name<-readLines(con="stdin",1)

library(data.table)
library(dplyr)

# read file

Input<-fread(Input_list,sep="\t",header=T)
TPMI_list<-fread("./TPMI-list/20220811.CMUH.TPMI.list.txt",sep="\t",header=T)

# Check duplicate
colnames(Input)[1]<-"PatientID"
colnames(Input)[2]<-"Pheno"
Input_unique<-distinct(Input,PatientID,.keep_all = T)

# Count number of duplicate
num_dup=nrow(Input)-nrow(Input_unique)
cat('\n')
cat('##### Input Sample Information #####')
cat('\n')
cat('\nInput Sample Num. is:', nrow(Input))
cat('\nInput Sample Num. duplicated is:', num_dup)
cat('\nInput Sample Num. unique is:', nrow(Input_unique))
cat('\n')

# Get Patients with (without) TPMI

Patient_List_TPMI<-left_join(Input,TPMI_list,,by=c("PatientID"="PatientID"))

# Check duplicate

Patient_List_TPMI_unique=distinct(Patient_List_TPMI,PatientID,.keep_all = T)

# Get the list of TPMI with PatientID

no_chip=subset(Patient_List_TPMI_unique,is.na(Patient_List_TPMI_unique$GenotypeName))
have_chip=subset(Patient_List_TPMI_unique,!is.na(Patient_List_TPMI_unique$GenotypeName))

cat('\n')
cat('##### TPMI Chip Information #####')
cat('\n')
cat('\nSample Num. with TPMI chip is:', nrow(have_chip))
cat('\nSample Num. without TPMI chip is:', nrow(no_chip))
cat('\n')
cat('\n')

# Output the data
tmp_no_chip=paste0('./output/',Output_name,'-no-chip.txt',collapse = '')
tmp_have_chip=paste0('./output/',Output_name,'-have-chip.txt',collapse = '')

fwrite(no_chip,tmp_no_chip,sep="\t",col.names = T)
fwrite(have_chip,tmp_have_chip, sep="\t",col.names = T)


# Make the GWAS-ready Pheno table

have_chip_GWAS=have_chip[,c("GenotypeName","GenotypeName","Sex","Age","Pheno")]
colnames(have_chip_GWAS)<-c("FID","IID","Sex","Age","Pheno")

case=subset(have_chip_GWAS,have_chip_GWAS$Pheno=="1")    
control=subset(have_chip_GWAS,have_chip_GWAS$Pheno=="2")

cat('\n')
cat('##### TPMI Chip for GWAS Information #####')
cat('\n')
cat('\nNum. of GWAS in case is:', nrow(control))
cat('\nNum. of GWAS in control is:', nrow(case))
cat('\n')
cat('\n')
# Output the GWAS ready data
tmp_gwas_ready=paste0('./GWAS/',Output_name,'.gwas.pheno.txt',collapse = '')
fwrite(have_chip_GWAS,tmp_gwas_ready,sep="\t",col.names = T)
cat('\n')
cat('##### GWAS-ready Information #####')
cat('\n')
cat('\nThe GWAS-ready Phenotype table was output in:',tmp_gwas_ready)
cat('\n')
cat('\nReady for Next step: GWAS Analysis......')
cat('\n')
cat('\n')