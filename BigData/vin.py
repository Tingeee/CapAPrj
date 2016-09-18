#!/usr/bin/python
import inspect
from datetime import datetime, date
import sys
import json

#find unique value of vin and counting frequency
#author: Ting
#2016.09.18

#get substring
def get_substring(array,i,j):
	mid_string=array
	array=mid_string[i:j]
	return array

#reform list
def reform_list(data_list):
	#print len(data_list)
	if (len(data_list) ==15):
		data_list.insert(3,'ss')
	del data_list[5:10]	#remove nonsense element
	del data_list[-3:]
	del data_list[1]
	data_list[0]=get_substring(data_list[0],0,-9)	#0-time
	data_list[0]=data_list[0]+'(GMT)'
	data_list[1]=get_substring(data_list[1],1,-1)	#1--IP
	data_list[2]=get_substring(data_list[2],0,-1)	#2--Vin
	data_list[4]=get_substring(data_list[4],1,-1)	#3--response code
	data_list[5]=get_substring(data_list[5],1,4)	#4--type 5--URI
	data_list[1]=''.join('%s, %s' %(data_list[1],data_list[2]))
	del data_list[2]
	#print data_list
	return data_list

#get line number of file == size of array
def get_size_of_array():
	rawdata_file=open("/usr/load/apache2/log2/cep_access_log.2016-04-15-00_00_00",'r')
	size=len(rawdata_file.readlines())                              #get line number
	rawdata_file.close()
	return size

#read data and reform 	
def read_from_file():
	size=get_size_of_array()
	read_again=open("/usr/load/apache2/log2/cep_access_log.2016-04-15-00_00_00",'r')
	split_line = [[0 for x in range(0,10)] for y in range(size)] 	#build a 2-D array
	for i in range (size):
		split_line[i]=read_again.readline().split()		#read file and store in pre-build list
		split_line[i]=reform_list(split_line[i])		#reform
	#print_as_list(split_line[i])
	read_again.close()
	return split_line	

#unique value & its index
def find_response(objlist):
	uniqueval_of_obj=list(set(objlist)) #find unique value
	i_list=[0 for x in range(0)]
	uniqueval_num = len(uniqueval_of_obj)
	i_list = [[0 for x in range(0)] for y in range(uniqueval_num)] #2-D array
	for i,s in enumerate(objlist):				
		for m,val in enumerate(uniqueval_of_obj):
			if s == val:			#find the indexes of each unique value in objlist
				i_list[m].extend([i])  # then put indexes in a 2-D array 
	return i_list,uniqueval_of_obj

mylist=read_from_file()       
vin_column=[row[2]for row in mylist]
vin_index_list,unique_val_of_vin=find_response(vin_column)

# def output
result_list = [[0 for x in range(0,2)] for y in range(len(unique_val_of_vin))]
for i,s in enumerate(unique_val_of_vin):
	result_list[i][0]=len(vin_index_list[i])
	result_list[i][1]=s

result_list=sorted(result_list)  #sorted the 2-D array by the first column which stores the counting
f=open("/usr/load/apache2/log2/time_pointer1",'w')

for s in reversed(result_list):  #enumerate the list in reverse  
	print_form='{:<32}{:<}{:<}'.format(s[1],s[0],'\n')
	f.write(print_form)
f.close()





