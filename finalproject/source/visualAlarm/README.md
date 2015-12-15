# Tufts Comp 116 Assignment 2: Incident Alarm
An incident alarm that searches for exploits in a live scan of a network or from an access log.

Command | Result
---|---
`sudo ruby alarm.rb` | Program listens on the local network. When an exploit is detected, it is printed to the console.
`ruby alarm.rb -r <web_server_log>` | Program reads in the specified LOGFILE.  When an exploit is detected, the program prints the exploit's information to the console

Exploit Information Message format:  
`#{incident_number}. ALERT: #{incident} is detected from #{source IP address} (#{protocol}) (#{payload})!`


## What Worked
###Live Scan

Scan | Detection Algorithm
---|---
NULL scan | checks if each tcp_flag is 0
FIN scan | checks if each other tcp_flag is zero and FIN is 1
Xmas scan | checks if each other tcp_flag is zero and URG PSH and FIN are 1
Other Nmap scans | checks for the word nmap in hex with `/\x4E\x6D\x61\x70/`
Nikto scan | checks for the word nikto in hex with `/\x4E\x69\x6B\x74\x6F/`
Credit card leak | checks a series of regular expressions for known credit card regex matches

**Credit card matching**

Regex | Carrier
---|---
`/4\d{3}(\s|-)?\d{4}(\s|-)?\d{4}(\s|-)?\d{4}/` | Visa
`/5\d{3}(\s|-)?\d{4}(\s|-)?\d{4}(\s|-)?\d{4}/` | MasterCard
`/6011(\s|-)?\d{4}(\s|-)?\d{4}(\s|-)?\d{4}/`| Discover
`/3\d{3}(\s|-)?\d{6}(\s|-)?\d{5}/` | American Express

###Access Log Scan

Scan | Detection Algorithm
---|---
NMAP scan (of any variety) | Searches for the word `"nmap"` in each line converted to lowercase using `.downcase` on each line
Nikto scan | Searches for the word `"nikto"` in each line converted to lowercase using `.downcase` on each line
Someone running Rob Graham's Masscan | Searches for the word `"masscan"` in each line converted to lowercase using `.downcase` on each line
Someone scanning for Shellshock vulnerability.  | searches for `() { :; }` with `/()\s*{\s*:;\s*};/`
Anything pertaining to phpMyAdmin | Searches for the word `"phpmyadmin"` in each line converted to lowercase using `.downcase` on each line
Anything that looks like shellcode.  | Searches for `\x` to look for anything in hexidecimal that could be compiled shell code.


## Still left
- PCAP output

## Time
- Redoing work lost from VM crash: 4 hours. Lesson learned: figure out how to install VM in the future.
- Lots of regex fun times: 6 hours
- Testing 2 hours on and off
- 1 hour of making the README look nice/tweaking

## Questions
1. *Are the heuristics used in this assignment to determine incidents "even that good"?*    
The heuristiscs are *not* even that good.  There's probably lots of edge cases and ways of getting around the detection if someone really wants to be sneaky.  The nmap scans can be tricked if someone tries to hide the signature.

2. *If you have spare time in the future, what would you add to the program or do differently with regards to detecting incidents?*    
I'd probably put more research into incidents not specified by the assignment, and see if my program had any known flaws and address them.  I'd also try to see what edge cases there are for my existing scans and fix them.
