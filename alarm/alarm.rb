#!/Users/Ryan/.rvm/rubies/ruby-2.1.1/bin/ruby

require 'packetfu'
include PacketFu

$incident_number = 0;
$incident = ""
$source = ""
$protocol = ""
$payload = ""

iface = "en0"

# Stream Checking

def checkStream(pkt)
	errorDetected = false;
	$incident = "test"

	# Check TCP vulnerabilities
	if pkt.proto.last == "TCP"
		puts pkt.tcp_flags
		if checkNull(pkt)
			errorDetected = true
			$incident = "NULL"
		elsif checkFin(pkt)
			errorDetected = true
			$incident =  "FIN"
		elsif checkXMAS(pkt)
			errorDetected = true
			$incident =  "XMAS"
		end
	else
		if checkNikto(pkt)
			errorDetected = true
			$incident =  "nikto"
		elsif checkNmap(pkt)
			errorDetected = true
			$incident = "Nmap"
		elsif checkCreditCard(pkt)
			errorDetected = true
			$incident = "Credit card leaked"
		end
	end

	if errorDetected
		puts "#{$incident_number}. ALERT: #{$incident} is detected from #{pkt.ip_saddr} (#{pkt.proto.last}) (#{pkt.payload})!"	
		$incident_number = $incident_number + 1
	end
end

def checkNull(line)
	flags = line.tcp_flags
	ret = true;
	flags.each do |flag|
		if flag == 1
			ret = false
		end
	end

	return ret
end

def checkFin(line)
	flags = line.tcp_flags
	i = 0
	flags.each do |flag|
		if flag == 1 and i != 5
			return false	
		end
		i = i + 1
	end
	if flags[5] != 1 
		return false
	end

	return true
end

def checkXMAS(line)
	flags = line.tcp_flags
	return (flags[0] == 1) && (flags[2] == 1) && (flags[5] == 1) && (flags[1] == 0) && (flags[3] == 0) && (flags[4] == 0)
end

def checkNmap(line)
	return (line.ip_saddr =~ /\x4E\x6D\x61\x70/) || (line.payload =~ /\x4E\x6D\x61\x70/)
end

def checkNikto(line)
	return (line.ip_saddr =~ /\x4E\x69\x6B\x74\x6F/) || (line.payload =~ /\x4E\x69\x6B\x74\x6F/)
end

def checkCreditCard(line)
	ret = false;
	if line =~ /4\d{3}(\s|-)?\d{4}(\s|-)?\d{4}(\s|-)?\d{4}/
		ret = true
		puts "VISA"
	end
	if line =~ /5\d{3}(\s|-)?\d{4}(\s|-)?\d{4}(\s|-)?\d{4}/
		ret = true
		puts "Mastercard"
	end
	if line =~ /6011(\s|-)?\d{4}(\s|-)?\d{4}(\s|-)?\d{4}/
		ret = true
		puts "Discover"
	end
	if line =~ /3\d{3}(\s|-)?\d{6}(\s|-)?\d{5}/
		ret = true
		puts "AMERICAN"
	end
	
	return ret
end

# Log Checking

def checkLog(line)
	if checkLogShellShock(line)
		puts "SHELL SHOCK"
	elsif checkLogPhpMyAdmin(line)
		puts "PHP"
	elsif checkLogMasscan(line)
		puts "MASSCAN"
	elsif checkLogShell(line)
		puts "SHELL CODE"
	elsif checkLogNmap(line)
		puts "NMAP"
	end
end


def checkLogShellShock(line)
	return line =~ /()\s*{\s*:;\s*};/
end

def checkLogPhpMyAdmin(line)
	return line.to_s.downcase.include? "phpmyadmin"
end

def checkLogMasscan(line)
	return line.to_s.downcase.include? "masscan"
end

def checkLogShell(line)
	return line.to_s.include? "\\x"
end

def checkLogNmap(line)
	return line.to_s.downcase.include? "nmap"
end

def checkLogNikto(line)
	return line.to_s.downcase.include? "nikto"
end

# Read Log
if ARGV.length >= 2
	puts ARGV[0],ARGV[1]
	if ARGV[0] == '-r'
		File.open(ARGV[1], "r") do |f|
			f.each_line do |line|
				checkLog(line)
			end
		end
	end

# Otherwise Read Stream
else
	stream = PacketFu::Capture.new(:start => true, :iface => iface, :promisc => true)
	# stream.show_live()

	# For every stream
	stream.stream.each do |p|
		# parse the packet
		pkt =  Packet.parse p
		# Check if it's an IP
		if pkt.is_ip?
			# skip if it's my IP
			# next if pkt.ip_saddr == Utils.ifconfig(iface)[:ip_saddr] 
			
			# Show basic packet information
			# packet_info = [pkt.ip_saddr, pkt.ip_daddr, pkt.size, pkt.proto.last]
			# if pkt.ip_saddr.to_s == "173.194.123.116"
			# 	puts "%-15s -> %-15s %-4d %s" % packet_info	
			# end
			
			checkStream(pkt)
	    end
	end
end


