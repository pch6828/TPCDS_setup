TPCDS_PATH=$1
SETUP_PATH=$PWD
DATA_PATH=$2
SCALE=$3
DB_NAME=$4
TABLES=(call_center catalog_page catalog_returns catalog_sales customer \
        customer_address customer_demographics date_dim household_demographics \
        income_band inventory item promotion reason ship_mode store \
        store_returns store_sales time_dim warehouse web_page web_returns \
        web_sales web_site)

export PATH=/usr/local/pgsql/bin:$PATH

dropdb $DB_NAME
createdb $DB_NAME
psql $DB_NAME -f $TPCDS_PATH/tpcds.sql

for table in ${TABLES[@]}
do
    $SETUP_PATH/tpcds_load_each_table.sh $DB_NAME $SCALE $table 1 $SCALE $TPCDS_PATH $SETUP_PATH $DATA_PATH
done

psql $DB_NAME -f tpcds_ri.sql
