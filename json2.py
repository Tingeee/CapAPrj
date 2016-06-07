import inspect
from datetime import datetime, date
import sys
import json

#json version: Creat json
#author: Ting
#2016.06.02



#creat json file
def JSON_creat(objlist,index_list):
        today=date.today().isoformat()
	vin_column=[row[2] for row in objlist]
        data_value=[]
	#url_column=[row[4] for row in objlist]
        for i,s in enumerate (vin_column):
                if i in index_list:
                	data_value.append({'vin':vin_column[i],'url':objlist[i][5]})
        json_filename='rowdatajson'+today
	with open(json_filename,'w')as outfile:
		json.dump({'404':data_value},outfile,indent=4)

#get substring
def get_substring(array,i,j):
	mid_string=array
	array=mid_string[i:j]
	return array

#reform list
def reform_list(data_list):
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
	rawdata_file=open("/usr/load/apache2/log2/cep_access_log.2015-04-15-00_00_00",'r')
	size=len(rawdata_file.readlines())                              #get line number
	rawdata_file.close()
	return size

#read data and reform 	
def read_from_file():
	size=get_size_of_array()
	read_again=open("/usr/load/apache2/log2/cep_access_log.2015-04-15-00_00_00",'r')
	split_line = [[0 for x in range(0,10)] for y in range(size)] 	#build a 2-D array
	for i in range (size):
		split_line[i]=read_again.readline().split()		#read file and store in pre-build list
		split_line[i]=reform_list(split_line[i])		#reform
	#print_as_list(split_line[i])
	read_again.close()
	return split_line	

#find bad response
def find_bad_response(objlist):
	response_colum=[row[3] for row in objlist]
	i_list=[0 for x in range(0)]
	j=0
	for i,s in enumerate(response_colum):
		if s == '404':
			i_list.insert(i,j)
			j=j+1
	return i_list

			
mylist=read_from_file()
output_list=[]
index_list=find_bad_response(mylist)
JSON_creat(mylist,index_list)












