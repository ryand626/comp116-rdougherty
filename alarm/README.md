# Incident Alarm

## What Worked
Live Scan

Scan | Detection Algorithm
---|---
NULL scan | checks if each tcp_flag is 0
FIN scan | checks if each other tcp_flag is zero and FIN is 1
Xmas scan | checks if each other tcp_flag is zero and URG PSH and FIN are 1
Other Nmap scans | checks for the word nmap in hex
Nikto scan | checks for the word nikto in hex
Credit card leak | checks a series of regular expressions for known credit card regex matches

Access Log Scan

Scan | Detection Algorithm
---|---
NMAP scan (of any variety) | Searches for the word nmap
Nikto scan | searches for the word nikto
Someone running Rob Graham's Masscan | searches for the word masscan
Someone scanning for Shellshock vulnerability.  | searches for (){:;}
Anything pertaining to phpMyAdmin | searches for phpmyadmin
Anything that looks like shellcode.  | searches for \x


## Still left
- Some testing of live stream
- Some log testing
- PCAP output?

## Time
- Redoing work lost from VM crash: 4 hours. Lesson learned: figure out how to install VM in the future.
- Lots of regex fun times: 3 hours
- Testing 2 hours on and off

## Questions
1. Are the heuristics used in this assignment to determine incidents "even that good"?  
Eh not really, there's probably lots of edge cases and ways of getting around the detection if someone really wants to be sneaky.

2. If you have spare time in the future, what would you add to the program or do differently with regards to detecting incidents?  
I'd probably put more research into incidents not specified by the assignment, and see if my program had any known flaws and address them.
