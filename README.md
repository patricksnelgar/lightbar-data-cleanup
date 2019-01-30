# lightbar-data-cleanup
R script to compress and date align lightbar data files

Combines individual files for each run (morning, midday, afternoon) in sequential order then extracts 
the matching records from the reference data set based on datestamps.

Splits the data into 'calibration' and 'lightbar' then writes them to csv
