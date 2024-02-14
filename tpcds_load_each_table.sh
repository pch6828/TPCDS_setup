DB_NAME=$1
SCALE=$2
TABLE=$3
START_CHUNK=$4
END_CHUNK=$5
TPCDS_PATH=$6
SETUP_PATH=$7
DATA_PATH=$8

export PATH=/usr/local/pgsql/bin:$PATH

cd $DATA_PATH/tpc-ds/data/$SCALE

if [ $SCALE -eq 1 ]
then
    echo "Processing ${TABLE}"
    if [ -f "$TABLE.dat" ]; then
        linecount=$(wc --lines < $TABLE.dat)
        if [ $linecount = 0 ];then
            echo "$TABLE.dat is not generated properly"
            break
        fi        
        python3 $SETUP_PATH/fix-utf8.py $TABLE.dat ${TABLE}_2.dat
        psql $DB_NAME -c "\\copy ${TABLE} FROM '${TABLE}_2.dat' CSV DELIMITER '|'" 
        rm $TABLE.dat
    elif [ -f "${TABLE}_2.dat" ]; then           
        psql $DB_NAME -c "\\copy ${TABLE} FROM '${TABLE}_2.dat' CSV DELIMITER '|'"    
    fi
else
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
fi

     