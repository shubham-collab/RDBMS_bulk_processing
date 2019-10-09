globaldb_mysql=null
globaltable_mysql=null

hdfsToMysql()
{
echo -e "\nEnter MySQL DB name:"
read db
echo -e "\nEnter MySQL Table name:"
read table
echo -e " ------------------------- Exporting data from HDFS to MySQL -----------------------------\n\n"

echo -e "MySQL Database entered: $db \nMySQL Table entered: $table\n\n"




declare -g globaldb_mysql=$db
declare -g globaltable_mysql=$table

echo -e " --------------------   Starting Sqoop job  ------------------\n\n"

	if sqoop export --connect jdbc:mysql://localhost/$db --username root --password root --table $table --export-dir /user/shubham/customer_details.txt
	then
		return 1
	else
		return 0
	fi
}
#############################################################################################################
mysqlToHive()
{

	echo -e "\nEnter HIVE DB name:"
	read dbh
	echo -e "\nEnter HIVE Table name:"
	read tableh
	echo -e " ------------------------- Exporting data from MySQL to HIVE -----------------------------\n\n"
	echo -e "HIVE Database entered: $dbh \nHIVE Table entered: $tableh\n\n"


	temp=static_script
	tempHiveHDFSFolder=$temp$(date "+%d-%m-%y_%H-%M")

	#echo -e "HIVE Database entered: $db \nHIVE Table name: $tempHiveHDFSFolder\n\n"
	#echo $tempHiveHDFSFolder

	if sqoop import --connect jdbc:mysql://localhost:3306/$globaldb_mysql --username root --password root --table $globaltable_mysql --target-dir /$tempHiveHDFSFolder --hive-import --create-hive-table --hive-table $dbh.$tableh -m 1
	then
		return 1
	else
		return 0
	fi
}





#############################################################################################################
#########  main #########

hdfsToMysql

return_hdfsToMysql=$?
if [ "$return_hdfsToMysql" == 1  ]
then
	echo -e "--------------------------------- Successfully imported data to Mysql ---------------------------------"
	mysqlToHive
	return_mysqlToHive=$?
	if [ "$return_mysqlToHive" == 1 ]
	then
		echo -e "\n\n -------------------------------------------    import to hive is a success ------------------------------"
	else
		echo -e "\n\n -------------------------------------------    import to hive failed ------------------------------"
	fi
else
	echo -e "--------------------------------- Export Data operation Failed ---------------------------------"
fi




