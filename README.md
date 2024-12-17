# Overview

This is a selection of Shell and R Scripts which logs the battery health of your laptop.
The script saves your batteries current health and charge percentage, and also a computed real charge percentage based on the over all battery health.

# Running the Scripts

To log the script you need to setup a cron job calling the script every few minuets. I personally call the `script.sh` every 5 mins (`*/5 * * * *`).
The output is printed out to a `log.csv` file from which the `print_chart.R` script reads.
You may have to update `script.sh` to point to the correct system files to report the battery health.

You can run the `print_chart.R` script when ever you want to update the chart and save it a `battery_helth.pdf`.
