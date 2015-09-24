# Homework 1

## Set 1
1. How many packets are there in this set?  
861  
2. What protocol was used to transfer files from PC to server?  
TCP  
3. Briefly describe why the protocol used to transfer the files is insecure?  
TCP is vulnerable to man in the middle and denial of service attacks, among others that can either shut down the connection or eavesdrop on it.  

4. What is the secure alternative to the protocol used to transfer files?  
They could add Transport Layer Security to their file transfer (TLS).  
5. What is the IP address of the server?  
192.168.99.130  
6. What was the username and password used to access the server?  
USER defcon  
PASS: m1ngisablowhard  
7. How many files were transferred from PC to server?  
6  
8. What are the names of the files transferred from PC to server?  
CDkv69qUsAAq8zN.jpg  
CJoWmoOUkAAAYpx.jpg  
CKBXgmOWcAAtc4u.jpg  
CLu-mOMWoAAgjkr.jpg  
CNsAEaYUYAARuaj.jpg  
COaqQWnU8AAwX3K.jpg  
9. Extract all the files that were transferred from PC to server.  
	## Set 2
10. How many packets are there in this set?  
77982  
11. How many plaintext username-password pairs are there in this packet set? Please count any anonymous or generic accounts.  
1 larry@radsot.com Z3lenzmej  
12. Briefly describe how you found the username-password pairs.  
I used ettercaps went to Profiles, sorted them, viewed the vulnerable ones, double clicked them and read the account information plaintext User/Password pair.  
13. For each of the plaintext username-password pair that you found, identify the protocol used, server IP, the corresponding domain name (e.g., google.com), and port number.  
Protocol: TCP imap2, Port: 143  
14. Of all the plaintext username-password pairs that you found, how many of them are legitimate? That is, the username-password was valid, access successfully granted? Please do not count any anonymous or generic accounts.  
One is legitimate.  
	## Set 3
15. How many plaintext username-password pairs are there in this packet set? Please count any anonymous or generic accounts.  
3. 2 aren't actual accounts, one is legitimate.  
###Real
IMAP  
USER: nab01620@nifty.com PASS: Nifty->takirin1  
From: 210.131.4.55:143  
###Fake
USER: seymore PASS: butts INFO: forum.defcon.org/login.php?user=seymore&password=butts  
From: 162.222.171.208:80  
USER: jeff PASS: asdasdasd INFO: ec2.intelctf.com/C  
From: 54.191.109.23:80  
16. For each of the plaintext username-password pair that you found, identify the protocol used, server IP, the corresponding domain name (e.g., google.com), and port number.  
USER: nab01620@nifty.com PASS: Nifty->takirin1  
PROTOCOL: IMAP, IP: 210.131.4.55, PORT: 143  
USER: seymore PASS: butts   
PROTOCOL: HTTP, IP: 162.222.171.208, DOMAIN: forum.defcon.org/login.php?user=seymore&password=butts PORT: 80  
USER: jeff PASS: asdasdasd  
PROTOCOL: HTTP, IP: 54.191.109.23, DOMAIN: ec2.intelctf.com/C, PORT: 80  
17. Of all the plaintext username-password pairs that you found, how many of them are legitimate? That is, the username-password was valid, access successfully granted? Please do not count any anonymous or generic accounts.  
1  
18. Provide a listing of all IP addresses with corresponding hosts (hostname + domain name) that are in this PCAP set. Describe your methodology.  
I used ettercaps to get these  
162.222.171.208:80 forum.defcon.org/login.php?user=seymore&password=butts  
ec2.intelctf.com/C  
	## General Questions
19. How did you verify the successful username-password pairs?  
By looking at what the server did after the username/password were given.  If the password was legitimate, the server responded with actual data, otherwise it refused or did nothing.  
20. What advice would you give to the owners of the username-password pairs that you found so their account information would not be revealed "in-the-clear" in the future?  
Use https to encrypt their messages to the server!  