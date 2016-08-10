#!/usr/bin/python
import inspect
from datetime import datetime, date
import sys
import json

#json version 3.2: Creating json files, contain vin json ,time json and response# json
#author: Ting
#2016.08.01



#creat json file
def JSON_creat(objlist,index_list,unique_val,mode):
        today=date.today().isoformat()
	#today = '2016-08-08'
	vin_column=[row[2] for row in objlist]
        data_value=[[0 for x in range(0)] for y in range(len(unique_val))]
	json_filename='/var/www/json/'+mode+today
	datata={}
	res_array=[]
	data={}
	if mode == 'vin':
		chosenlist=[row[3] for row in objlist]
		key = 'response code'
		for index,val in enumerate(unique_val):
                	for i,s in enumerate (vin_column):
                        	if i in index_list[index]:
                                	data_value[index].append({'time':objlist[i][0],key:chosenlist[i],'url':objlist[i][5]})
                	datata[val]=data_value[index]
	elif mode == 'responsecode':
		chosenlist=[row[2]for row in objlist]
		key = 'vin'
		for index,val in enumerate(unique_val):
                	for i,s in enumerate (vin_column):
                        	if i in index_list[index]:
                                	data_value[index].append({'time':objlist[i][0],key:chosenlist[i],'url':objlist[i][5]})
                	datata[val]=data_value[index]
	else:
		unique_val=[today]
		data_value = []
		for i,s in enumerate (vin_column):
			 data_value.append({'time':objlist[i][0],'vin':objlist[i][2],'url':objlist[i][5], 'response code':objlist[i][3]})
		datata[today]=data_value	
	data[mode]=datata
	data["mode"]=mode
	data['date']=today
	data['unique value']=unique_val
	with open(json_filename,'w')as outfile:
        	json.dump({'results':data},outfile,indent=4)

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

#find index of data in specified period
def find_specified_data(upper_date,lower_date,objlist):
	begin_time=datetime.date(lower_date[0],lower_date[1],lower_date[2])#year month day
	end_time=datetime.date(upper_date[0],upper_date[1],upper_date[2])#year month day
	index=0
	valid_index_list=[0 for x in range(0)]
	time_column=[row[0] for row in objlist]  
	for i,s in enumerate(time_column):		
		this_y=int(get_substring(s,0,4))		#read data time	
		this_m=int(get_substring(s,5,7))
		this_d=int(get_substring(s,8,10))
		this_time=datetime.date(this_y,this_m,this_d) 
		if(this_time>=begin_time and this_time<=end_time):	#select index of time that in the desired period
			valid_index_list.insert(index,i)	   
			index=index+1
	return valid_index_list

#get line number of file == size of array
def get_size_of_array():
	rawdata_file=open("/usr/load/apache2/log2/cep_access_log",'r')
	size=len(rawdata_file.readlines())                              #get line number
	rawdata_file.close()
	return size

#read data and reform 	
def read_from_file():
	size=get_size_of_array()
	read_again=open("/usr/load/apache2/log2/cep_access_log",'r')
	split_line = [[0 for x in range(0,10)] for y in range(size)] 	#build a 2-D array
	for i in range (size):
		split_line[i]=read_again.readline().split()		#read file and store in pre-build list
		split_line[i]=reform_list(split_line[i])		#reform
	#print_as_list(split_line[i])
	read_again.close()
	return split_line	

#response code list and its unique value
def find_response(objlist,mode):
	#response_colum=[row[3] for row in objlist]
    	#line = map(int,response_colum)
	uniqueval_of_obj=list(set(objlist)) #find unique value
    	uniqueval=uniqueval_of_obj
	#print(uniqueval_of_response)
	i_list=[0 for x in range(0)]
	j=0
	if (mode == 'response#'):
		for m,val in enumerate(uniqueval):
			if val.isdigit()== False:
				uniqueval_of_obj.remove(val)	
	#print uniqueval_of_response
	uniqueval_num = len(uniqueval_of_obj)
	i_list = [[0 for x in range(0)] for y in range(uniqueval_num)]
	#print i_list
	for i,s in enumerate(objlist):
		for m,val in enumerate(uniqueval_of_obj):
			if s == val:
				i_list[m].extend([i])
	#print i_list
	return i_list,uniqueval_of_obj

mylist=read_from_file()
output_list=[]
respondnum=[row[3] for row in mylist]
vin_column=[row[2]for row in mylist]
respond_num_index_list,unique_val_of_response=find_response(respondnum,'response#')
vin_index_list,unique_val_of_vin=find_response(vin_column,'vin')

#print(unique_val_of_vin)

JSON_creat(mylist,respond_num_index_list,unique_val_of_response,'responsecode')
JSON_creat(mylist,vin_index_list,unique_val_of_vin,'vin')
JSON_creat(mylist,vin_index_list,unique_val_of_vin,'time')
