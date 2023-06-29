TPCDS_PATH=/home/pch/TPC-DS_Tools_v3.2.0/tools
DATA_PATH=/data/pch
SCALE=$1
START_CHUNK=$2
END_CHUNK=$3

cd $DATA_PATH/tpc-ds/
mkdir -p ./data/$SCALE
rm -rf ./data/$SCALE/*

cd $TPCDS_PATH
if [ $SCALE -eq 1 ] 
then 
    echo "Basic Generation"
    ./dsdgen -SCALE $SCALE -DIR $DATA_PATH/tpc-ds/data/$SCALE
else
    for i in $(seq $START_CHUNK $END_CHUNK)
    do
        echo "Generation Phase "$i
        ./dsdgen -SCALE $SCALE -DIR $DATA_PATH/tpc-ds/data/$SCALE -PARALLEL $SCALE -CHILD $i
    done 
fi


