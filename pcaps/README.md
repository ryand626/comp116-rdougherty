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
	
	Three. Two aren't actual accounts, one is legitimate.  
	
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
	
	I used 
	
	```
	ettercap -Tq -L set3 -r set3.pcap
	```
	
	To get the set3.eci file and then
	
	```
	etterlog --text set3.eci | grep -A 1 '^[ *$]IP address' | grep -B 1 '^[ *$]Host' > set3IPs.txt
	```

	to parse out the IP addresses with host names

	IP Address | Hostname
	--- | ---
	17.134.62.236 | gs-loc.apple.com  
	17.134.126.211 | gs-loc.apple.com  
	17.134.126.213 | gs-loc.apple.com  
	17.134.127.250 | gs-loc.apple.com  
	17.143.163.152 | 12-courier.push.apple.com  
	17.164.1.38 | lcdn-locator.apple.com  
	17.172.100.8 | p05-keyvalueservice.icloud.com.akadns.net  
	17.173.255.51 | profile.ess.apple.com  
	17.249.25.246 | api.smoot-apple.com.akadns.net  
	17.253.16.222 | a769.phobos.apple.com  
	17.253.34.123 | time-ios.apple.com  
	17.253.34.253 | time-ios.apple.com  
	23.56.114.217 | su.itunes.apple.com  
	23.61.194.184 | gsp1.apple.com  
	23.99.50.237 | pipe.prd.skypedata.akadns.net  
	23.99.206.196 | 138-trouter-cus-b.drip.trouter.io  
	23.203.185.137 | init-cdn.itunes-apple.com.akadns.net  
	23.203.202.78 | e2842.e9.akamaiedge.net  
	23.203.203.37 | static.ess.apple.com  
	23.216.11.104 | mesu.apple.com  
	50.18.108.169 | insight.adsrvr.org  
	50.22.46.102 | dx.steelhousemedia.com  
	50.97.130.117 | px.steelhousemedia.com  
	52.5.63.176 | dc23-bigglesworth.slack.com  
	54.76.77.85 | collector-191.tvsquared.com  
	54.201.5.173 | tiles.services.mozilla.com  
	54.231.12.249 | canopylabstracking.s3.amazonaws.com  
	54.231.80.139 | s3.amazonaws.com  
	63.245.215.95 | fhr.data.mozilla.com  
	63.245.217.43 | aus4.mozilla.org  
	63.251.210.235 | t.cxt.ms  
	65.55.246.149 | contacts.msn.com  
	66.35.58.75 | vpc.altitude-arena.com  
	68.67.128.86 | m.anycast.adnxs.com  
	68.67.128.110 | ib.anycast.adnxs.com  
	69.22.163.234 | a248.e.akamai.net  
	72.21.91.8 | cdn.optimizely.com  
	74.122.190.78 | api.squareup.com  
	74.125.28.141 | mighty-app.appspot.com  
	74.125.28.189 | 0.client-channel.google.com  
	91.189.95.36 | manpages.ubuntu.com  
	91.190.218.69 | conn.skype.akadns.net  
	93.184.216.180 | tags.tiqcdn.com  
	104.16.19.44 | askubuntu.com  
	104.31.65.18 | peerio.com  
	104.244.43.172 | platform.twitter.com  
	108.162.200.15 | cloud.freedom.press  
	131.253.34.162 | flex.msn.com.nsatc.net  
	131.253.61.100 | login.live.com  
	132.245.20.178 | outlook.office365.com  
	172.230.246.231 | www.microsoft.com  
	173.194.65.94 | csi.gstatic.com  
	173.194.202.188 | mtalk.google.com  
	173.252.110.27 | api.facebook.com  
	184.172.43.156 | rto.steelhousemedia.com  
	185.70.40.118 | stats.protonmail.ch  
	199.16.156.11 | t.co  
	199.16.156.104 | api.twitter.com  
	199.16.156.231 | api.twitter.com  
	199.96.57.7 | o.twimg.com  
	205.180.86.169 | login.dotomi.com  
	216.58.216.170 | www.googleapis.com  
	216.58.217.193 | lh4.googleusercontent.com  
	216.58.217.194 | www.googleadservices.com  
	216.58.217.195 | fonts.gstatic.com  
	216.58.217.196 | www.google.com  
	216.58.217.200 | www.googletagmanager.com  
	216.58.217.206 | play.google.com 


	## General Questions

19. How did you verify the successful username-password pairs?  
	
	By looking at what the server did after the username/password were given.  If the password was legitimate, the server responded with actual data, otherwise it refused or did nothing.  

20. What advice would you give to the owners of the username-password pairs that you found so their account information would not be revealed "in-the-clear" in the future?  
	
	Use https to encrypt their messages to the server!  