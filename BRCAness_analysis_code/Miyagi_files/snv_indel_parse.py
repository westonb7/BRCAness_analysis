#! /usr/bin/env python

import sys
import re

writefile = open("germline_snv_indel.tsv", "w")

spazer = 0
counter = 0

writefile.write("Sample_ID\tGene\tMutation\tMutation_Type\n")

readfile = open("../Data/TCGA_Subtypes_Mutations_WindowsFormatted.txt")

for lines in readfile:
	lines = lines.strip()

	del_yes = 0
	ins_yes = 0
#	if lines == "":
#		continue

	if counter == 0:
		counter += 1
		spazer += 1
	elif (spazer <= 1004):
		line = lines.split("\t")
		patient_ID = line[0]
		chrm = line[1]
		coordinate = line[2]
		ref = line[3]
		var = line[4]
		damaging = line[5]
		gene = line[6]
		mutation = line[7]
		notes = line[8]
		PAM50 = line[9]
		TNBC = line[10]
		EPC = line[11]
		ER_status = line[12]
		PR_status = line[13]
		HER2_status = line[14]

		#if (spazer <= 1004):
		#	print patient_ID + "\t" + chrm + "\t" + coordinate + "\t" + mutation + "\t" + ER_status + "\t" + PR_status + "\t" + HER2_status
		
		mutation = str(mutation)
		
		search_del = "d"
		mut_del = re.search(search_del, mutation)
		search_ins = "i"
		mut_ins = re.search(search_ins, mutation)		
		del_str = "del"		
	
		if (spazer <= 1004):
			if mut_del:
				del_yes = 1
			if mut_ins:
				ins_yes = 1

#                if (spazer <= 1004):
 #                       print str(patient_ID) + "\t" + str(gene) + "\t" + str(mutation) + "\t" + str(del_yes) + "\t" + str(ins_yes)

		if gene != "": 
			if (spazer <= 1004):
				if del_yes == 1:
					writefile.write(patient_ID + "\t" + gene + "\t" + mutation + "\t" + "Deletion" + "\n")
				elif ins_yes == 1:
					writefile.write(patient_ID + "\t" + gene + "\t" + mutation + "\t" + "Insertion" + "\n")
				else:
					writefile.write(patient_ID + "\t" + gene + "\t" + mutation + "\t" + "SNV" + "\n")

		spazer += 1

readfile.close
writefile.close()

