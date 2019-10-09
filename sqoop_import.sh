sqoop import --connect jdbc:mysql://localhost:3306/testing_db --username root --password root --table emp --target-dir /hive90 --hive-import --create-hive-table --hive-table retail.Company2Hive9 -m 1
