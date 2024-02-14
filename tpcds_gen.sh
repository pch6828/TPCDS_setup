TPCDS_PATH=$1
DATA_PATH=$2
SCALE=$3

mkdir -p $DATA_PATH/tpc-ds/data/$SCALE
rm -rf $DATA_PATH/tpc-ds/data/$SCALE/*

if [ $SCALE -eq 1 ] 
then 
    echo "Basic Generation"
    $TPCDS_PATH/dsdgen -SCALE $SCALE -DIR $DATA_PATH/tpc-ds/data/$SCALE
else
    for i in $(seq 1 $SCALE)
    do
        echo "Generation Phase "$i
        $TPCDS_PATH/dsdgen -SCALE $SCALE -DIR $DATA_PATH/tpc-ds/data/$SCALE -PARALLEL $SCALE -CHILD $i
    done 
fi


