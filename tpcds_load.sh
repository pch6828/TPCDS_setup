DB_NAME=$1
TPCDS_PATH=/home/pch/TPC-DS_Tools_v3.2.0/tools
SETUP_PATH=/home/pch/TPCDS_setup
SCALE=$2
TABLES=(call_center catalog_page catalog_returns catalog_sales customer \
        customer_address customer_demographics date_dim household_demographics \
        income_band inventory item promotion reason ship_mode store \
        store_returns store_sales time_dim warehouse web_page web_returns \
        web_sales web_site)

dropdb $DB_NAME
createdb $DB_NAME
psql $DB_NAME -f $TPCDS_PATH/tpcds.sql

cd $SETUP_PATH

for table in ${TABLES[@]}
do
    ./tpcds_load_each_table.sh $DB_NAME $SCALE $table 1 $SCALE
done

cd $SETUP_PATH
psql $DB_NAME -f tpcds_ri.sql
