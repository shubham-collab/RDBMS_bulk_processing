#!/bin/sh

globaldb_mysql=null
globaltable_mysql=null

hdfsToMysql()
{
	if sqoop export --connect jdbc:mysql://localhost/static_project_mysql --username root --password root --table emp --export-dir /user/shubham/customer_details.txt
	then
		return 1
	else
		return 0
	fi
}
#############################################################################################################
mysqlToHive()
{

	tempHiveHDFSFolder=$temp$(date "+%d-%m-%y--%H-%M")

	sqoop import --connect jdbc:mysql://localhost:3306/static_project_mysql --username root --password root --table emp --target-dir /$tempHiveHDFSFolder --hive-import --create-hive-table --hive-table retail.$tempHiveHDFSFolder -m 1
}


#############################################################################################################
#########  main #########

hdfsToMysql

return_hdfsToMysql=$?
if [ "$return_hdfsToMysql" == 1 ]
then
	echo -e "--------------------------------- Successfully imported data to Mysql ---------------------------------"
	mysqlToHive
	return_mysqlToHive=$?
	if [ "$return_mysqlToHive" == 1 ]
	then
		echo -e "----- mysql to hive success-----"
	else
		echo -e "----- mysql to hive failed-----"
	fi
else
	echo -e "--------------------------------- Export Data operation Failed ---------------------------------"
fi





