# Comp 116 Assignment 5 Forensics
Susie Church and Ryan Dougherty

# Part 1
Determined a was smaller than b and c using
```
ls -l
ls -lh
```

Found that b and c were identical using  
`diff b.jpg c.jpg`  

a and b and a and c were both different using diff.  

Made a shell script to use a password list on steghide
```
while read line
do
	echo "$line"
	steghide extract -sf a.jpg -p $line
done
```
And ran it with
`sh stegdetect.sh < wordlist.txt`  

We found out that there is no password. The program's name is `runme`.
We modified it to be executable by using `chmod +x runme`. And then 
ran it with `./runme`.

The result was a program that when given no input says
```
Perhaps use your first name as an argument. :-)
```  

When given any other input it displays
```
$Input, you are doing a heckuvajob!
```

#Part 2

1. What is/are the disk format(s) of the disk on the suspect's computing device?  

There are multiple partitions.

Unallocated
Win95 FAT32 (0x0c)
Linux (0x83)
Unallocated

2. Is there a phone carrier involved?  

I'm going to go out on a limb and say yes?

3. What operating system, including version number, is being used? Please elaborate how you determined this information.  

Windows 95, and Linux Windows 95

4. What applications are installed on the disk? Please elaborate how you determined this information.

5. Is there a root password? If so, what is it?

6. Are there any additional user accounts on the system? If so, what are their passwords?

7. List some of the incriminating evidence that you found. Please elaborate where did you find the evidence, and how you uncovered the evidence.

8. Did the suspect move or try to delete any files before his arrest? Please list the name(s) of the file(s) and any indications of their contents that you can find.

9. Did the suspect save pictures of the celebrity? If so, how many pictures of the celebrity did you find? (including any deleted images)

10. Are there any encrypted files? If so, list the contents in the encrypted file and provide a brief description of how you decrypted the file.

11. Who is the celebrity that the suspect has been stalking?

Victor Espinoza and American Pharaoh