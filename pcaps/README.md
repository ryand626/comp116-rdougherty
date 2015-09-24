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
	
	'''
	ettercap -Tq -L set3 -r set3.pcap
	'''
	
	To get the set3.eci file and then
	
	'''
	etterlog --text set3.eci | grep -A 1 '^[ *$]IP address' | grep -B 1 '^[ *$]Host' > set3IPs.txt
	'''
	to parse out the IP addresses with host names

	IP address   : 17.134.62.236 
	Hostname     : gs-loc.apple.com  
	IP address   : 17.134.126.211 
	Hostname     : gs-loc.apple.com  
	IP address   : 17.134.126.213 
	Hostname     : gs-loc.apple.com  
	IP address   : 17.134.127.250 
	Hostname     : gs-loc.apple.com  
	IP address   : 17.143.163.152 
	Hostname     : 12-courier.push.apple.com  
	IP address   : 17.164.1.38 
	Hostname     : lcdn-locator.apple.com  
	IP address   : 17.172.100.8 
	Hostname     : p05-keyvalueservice.icloud.com.akadns.net  
	IP address   : 17.173.255.51 
	Hostname     : profile.ess.apple.com  
	IP address   : 17.249.25.246 
	Hostname     : api.smoot-apple.com.akadns.net  
	IP address   : 17.253.16.222 
	Hostname     : a769.phobos.apple.com  
	IP address   : 17.253.34.123 
	Hostname     : time-ios.apple.com  
	IP address   : 17.253.34.253 
	Hostname     : time-ios.apple.com  
	IP address   : 23.56.114.217 
	Hostname     : su.itunes.apple.com  
	IP address   : 23.61.194.184 
	Hostname     : gsp1.apple.com  
	IP address   : 23.99.50.237 
	Hostname     : pipe.prd.skypedata.akadns.net  
	IP address   : 23.99.206.196 
	Hostname     : 138-trouter-cus-b.drip.trouter.io  
	IP address   : 23.203.185.137 
	Hostname     : init-cdn.itunes-apple.com.akadns.net  
	IP address   : 23.203.202.78 
	Hostname     : e2842.e9.akamaiedge.net  
	IP address   : 23.203.203.37 
	Hostname     : static.ess.apple.com  
	IP address   : 23.216.11.104 
	Hostname     : mesu.apple.com  
	IP address   : 50.18.108.169 
	Hostname     : insight.adsrvr.org  
	IP address   : 50.22.46.102 
	Hostname     : dx.steelhousemedia.com  
	IP address   : 50.97.130.117 
	Hostname     : px.steelhousemedia.com  
	IP address   : 52.5.63.176 
	Hostname     : dc23-bigglesworth.slack.com  
	IP address   : 54.76.77.85 
	Hostname     : collector-191.tvsquared.com  
	IP address   : 54.201.5.173 
	Hostname     : tiles.services.mozilla.com  
	IP address   : 54.231.12.249 
	Hostname     : canopylabstracking.s3.amazonaws.com  
	IP address   : 54.231.80.139 
	Hostname     : s3.amazonaws.com  
	IP address   : 63.245.215.95 
	Hostname     : fhr.data.mozilla.com  
	IP address   : 63.245.217.43 
	Hostname     : aus4.mozilla.org  
	IP address   : 63.251.210.235 
	Hostname     : t.cxt.ms  
	IP address   : 65.55.246.149 
	Hostname     : contacts.msn.com  
	IP address   : 66.35.58.75 
	Hostname     : vpc.altitude-arena.com  
	IP address   : 68.67.128.86 
	Hostname     : m.anycast.adnxs.com  
	IP address   : 68.67.128.110 
	Hostname     : ib.anycast.adnxs.com  
	IP address   : 69.22.163.234 
	Hostname     : a248.e.akamai.net  
	IP address   : 72.21.91.8 
	Hostname     : cdn.optimizely.com  
	IP address   : 74.122.190.78 
	Hostname     : api.squareup.com  
	IP address   : 74.125.28.141 
	Hostname     : mighty-app.appspot.com  
	IP address   : 74.125.28.189 
	Hostname     : 0.client-channel.google.com  
	IP address   : 91.189.95.36 
	Hostname     : manpages.ubuntu.com  
	IP address   : 91.190.218.69 
	Hostname     : conn.skype.akadns.net  
	IP address   : 93.184.216.180 
	Hostname     : tags.tiqcdn.com  
	IP address   : 104.16.19.44 
	Hostname     : askubuntu.com  
	IP address   : 104.31.65.18 
	Hostname     : peerio.com  
	IP address   : 104.244.43.172 
	Hostname     : platform.twitter.com  
	IP address   : 108.162.200.15 
	Hostname     : cloud.freedom.press  
	IP address   : 131.253.34.162 
	Hostname     : flex.msn.com.nsatc.net  
	IP address   : 131.253.61.100 
	Hostname     : login.live.com  
	IP address   : 132.245.20.178 
	Hostname     : outlook.office365.com  
	IP address   : 172.230.246.231 
	Hostname     : www.microsoft.com  
	IP address   : 173.194.65.94 
	Hostname     : csi.gstatic.com  
	IP address   : 173.194.202.188 
	Hostname     : mtalk.google.com  
	IP address   : 173.252.110.27 
	Hostname     : api.facebook.com  
	IP address   : 184.172.43.156 
	Hostname     : rto.steelhousemedia.com  
	IP address   : 185.70.40.118 
	Hostname     : stats.protonmail.ch  
	IP address   : 199.16.156.11 
	Hostname     : t.co  
	IP address   : 199.16.156.104 
	Hostname     : api.twitter.com  
	IP address   : 199.16.156.231 
	Hostname     : api.twitter.com  
	IP address   : 199.96.57.7 
	Hostname     : o.twimg.com  
	IP address   : 205.180.86.169 
	Hostname     : login.dotomi.com  
	IP address   : 216.58.216.170 
	Hostname     : www.googleapis.com  
	IP address   : 216.58.217.193 
	Hostname     : lh4.googleusercontent.com  
	IP address   : 216.58.217.194 
	Hostname     : www.googleadservices.com  
	IP address   : 216.58.217.195 
	Hostname     : fonts.gstatic.com  
	IP address   : 216.58.217.196 
	Hostname     : www.google.com  
	IP address   : 216.58.217.200 
	Hostname     : www.googletagmanager.com  
	IP address   : 216.58.217.206 
	Hostname     : play.google.com 


	## General Questions

19. How did you verify the successful username-password pairs?  
	
	By looking at what the server did after the username/password were given.  If the password was legitimate, the server responded with actual data, otherwise it refused or did nothing.  

20. What advice would you give to the owners of the username-password pairs that you found so their account information would not be revealed "in-the-clear" in the future?  
	
	Use https to encrypt their messages to the server!  