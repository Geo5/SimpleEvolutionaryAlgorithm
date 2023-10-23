#! /bin/bash
set -e

javac ./src/main/java/es/uma/informatica/misia/ae/simpleea/*.java

cd ./src/main/java || exit

regex='fitness=([0-9]+\.[0-9]),'

fitness="["

counter=1
while [ $counter -le "$1" ]
do
    ((counter++))
    result=$(java es.uma.informatica.misia.ae.simpleea.Main "$2" "$3" "$4" "$5" $6)

    [[ $result =~ $regex ]]

    fitness=$fitness${BASH_REMATCH[1]},
done

fitness=$fitness"]"


echo "$fitness"

echo -n "Mean="
python -c "import statistics; import ast; import sys; l = ast.literal_eval(sys.argv[1]); print(statistics.mean(l))" "$fitness"

echo -n "Standard derivation="
python -c "import statistics; import ast; import sys; l = ast.literal_eval(sys.argv[1]); print(statistics.stdev(l))" "$fitness"

echo -n "Optimal percentage="
python -c "import ast; import sys; l = ast.literal_eval(sys.argv[1]); print(float(len([True for f in l if f == $5]))/float(len(l))*100, \"%\")" "$fitness"
