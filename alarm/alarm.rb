#!/Users/Ryan/.rvm/rubies/ruby-2.1.1/bin/ruby

require 'packetfu'
include PacketFu

$incident_number = 0;
$incident = "dogs"
$source = "1.3.5.6"
$protocol = "TCP"
$payload = "Binary data"

iface = "en0"

def checkLine(line)
	if checkNull(line)
		puts "NULL"
	elsif checkFin(line)
		puts "FIN"
	elsif checkXMAS(line)
		puts "XMAS"
	elsif checkNikto(line)
		puts "nikto"
	elsif checkNmap(line)
		puts("Nmap")
	else
		puts "No issues detected"
	end
	# "#{$incident_number}. ALERT: #{$incident} is detected from #{$source} (#{$protocol}) (#{$payload})!"	
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
	flags.each do |flag|
		if flag == 0
			return false
		end
		puts flag
	end
	return true
end

def checkNikto(line)
	if line.payload.unpack('H*').to_s.downcase.include? "nikto"
		return true
	end
	return false
end

def checkNmap(line)
	if line.payload.unpack('H*').to_s.downcase.include? "nmap"
		return true
	end
	return false
end

def checkShell(line)
	return line.include? "() { :; };"
end

def checkPhpMyAdmin(line)
	return line.to_s.downcase.include? "phpmyadmin"
end

# Read Log
if ARGV.length >= 2
	puts ARGV[0],ARGV[1]
	if ARGV[0] == '-r'
		File.open(ARGV[1], "r") do |f|
			f.each_line do |line|
				puts line
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
			next if pkt.ip_saddr == Utils.ifconfig(iface)[:ip_saddr] 
			
			# Show basic packet information
			packet_info = [pkt.ip_saddr, pkt.ip_daddr, pkt.size, pkt.proto.last]
			puts "%-15s -> %-15s %-4d %s" % packet_info
			
			# Check TCP vulnerabilities
			next if pkt.proto.last != "TCP"
			checkLine(pkt)
	    end
	end
end


