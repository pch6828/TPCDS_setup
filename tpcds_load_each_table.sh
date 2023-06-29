DB_NAME=$1
SCALE=$2
TABLE=$3
START_CHUNK=$4
END_CHUNK=$5
TPCDS_PATH=/home/pch/TPC-DS_Tools_v3.2.0/tools
SETUP_PATH=/home/pch/TPCDS_setup
DATA_PATH=/data/pch

cd $DATA_PATH/tpc-ds/data/$SCALE

for i in $(seq $START_CHUNK $END_CHUNK)
do
    FILENAME=${TABLE}_${i}_${SCALE}.dat
    if [ -f "$FILENAME" ]; then
        linecount=$(wc --lines < $FILENAME)
        if [ $linecount = 0 ];then
            echo "$FILENAME is not generated properly"
            break
        fi        
        echo "Processing Chunk ${i}"
        python3 $SETUP_PATH/fix-utf8.py $FILENAME ${FILENAME%.*}_2.dat
        psql $DB_NAME -c "\\copy ${TABLE} FROM '${FILENAME%.*}_2.dat' CSV DELIMITER '|'" 
        rm $FILENAME    
    elif [ -f "${FILENAME%.*}_2.dat" ]; then          
        echo "Processing Chunk ${i}"          
        psql $DB_NAME -c "\\copy ${TABLE} FROM '${FILENAME%.*}_2.dat' CSV DELIMITER '|'" 
    else
        break
    fi
done            