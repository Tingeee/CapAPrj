import inspect
import datetime
import sys
#version 1.4 automatically choose vin based process or time based process depending on input
#author: Ting
#2016.05.25

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

#print as lists
def print_as_list(print_list):
	print_form='{:<32}{:<32}{:<32}{:<24}{:<24}{:<}'.format(print_list[2],print_list[1],print_list[0],print_list[3],print_list[4],print_list[5])
	print print_form

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

#read input
def read_from_input():
	length_of_input=len(sys.argv)	#check the length of input then choose vin process or time process
	#vin based input
	if length_of_input==2:
		vin_input=sys.argv[1]
		choice=0
		invalid=0		#nonsense value
		return choice,vin_input,invalid
	#time based input
	else:
		choice=1
		time_input1=[0,0,0]
		time_input2=[0,0,0]
		time_input1[0]=int(sys.argv[1])
		time_input1[1]=int(sys.argv[2])
		time_input1[2]=int(sys.argv[3])
		time_input2[0]=int(sys.argv[4])
		time_input2[1]=int(sys.argv[5])
		time_input2[2]=int(sys.argv[6])
		return choice,time_input1,time_input2

#find index of vin that satisfy desired vin
def vin_fuzzy_input(sub,objlist):
	index_ref=[0 for x in range(0)]
	index=0
	vin_column=[row[2] for row in objlist]
	for i,s in enumerate(vin_column):
		if sub.lower() in s.lower():
			index_ref.insert(index,i)
			index=index+1
	return index_ref	 	

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

vin_or_time,a,b=read_from_input()
mylist=read_from_file()
if vin_or_time==1:	#time input
	time1=a
	time2=b					       	#desired time period
	index_list=find_specified_data(time1,time2,mylist) #time1 later than time2
else:			#vin input	
	desired_vin=a
	index_list=vin_fuzzy_input(desired_vin,mylist)

for i in index_list:
	print_as_list(mylist[i])







