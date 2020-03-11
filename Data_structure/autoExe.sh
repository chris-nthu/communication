#!/bin/bash

for num in $(seq -w 01 87); do
    inputFile=emotion/Deceptive/Deceptive_$num.wav
    outputFile=emotion/csv/deceptive/deceptive_$num.csv
    SMILExtract -C config/demo/demo1_energy.conf -I $inputFile -O $outputFile
done
