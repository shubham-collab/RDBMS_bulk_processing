#!/bin/bash
read $1,$2
echo -e " ------------------------- Exporting data from HDFS to MySQL -----------------------------\n\n"

echo -e "MySQL Database entered: $1 \nMySQL Table entered: $2\n\n"


echo -e " --------------------   Starting Sqoop job  ------------------\n\n"


sqoop export --connect jdbc:mysql://localhost/$1 --username root --password root --table $2 --export-dir c/user/shubham/customer_details.txt




insertToHive()
{
sqoop import --connect jdbc:mysql://localhost:3306/static_project_mysql --username root --table emp --target-dir /myhive --hive-import --create-hive-table –hive-table default.Company2Hive -m 1
}

insertToMySQL()
{

}
