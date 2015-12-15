# Tufts University Comp 116
# Final Project: Visual Incident Alarm
# Written by: Ryan Dougherty

require 'date'
# ---- FROM ALARM -----
# require 'packetfu'
# include PacketFu
# ---------------------

# ============= Constants ============= 
WIDTH = 800
HEIGHT = 600
BARX = WIDTH / 5
TIMEY = HEIGHT / 6
PADDING = 10
SHADE_FACTOR = 25

# ============= Variables ============= 
attr_accessor :Frames, :TimeFrame, :BreakdownFrame, :ThreatFrame, :ScrollArea
attr_accessor :IPFrame, :DescriptionFrame, :MitigationFrame, :AttackFrame
attr_accessor :ExploitNames, :Exploits
attr_accessor :lorem_ipsum

@lorem_ipsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

# ---- FROM ALARM -----
$incident_number = 0;
$incident = ""
$source = ""
$protocol = ""
$payload = ""

# iface = "en0"
iface = "eth0"
# ---------------------

# ============== Classes ============== 

# Rectangle data class with added functionality
class Frame
	attr_accessor :x, :y, :w, :h, :c
	
	def initialize(*dimentions)
		@x, @y, @w, @h = *dimentions
		@c = [100, 100, 100]
	end

	def SetFrame(*dimentions)
		@x, @y, @w, @h = *dimentions
	end

	def IsMouseInside
		return mouse_x < x + w && mouse_x > x && mouse_y > y && mouse_y < y + h
	end

	def CopyDimentions
		return *[@x,@y,@w,@h]
	end

	def render
		fill(color(*c))
		rect(x,y,w,h)
	end

	def renderNoFill
		noFill()
		rect(x,y,w,h)
	end

	def pg_render(pg)
		pg.fill(color(*c))
		pg.rect(x,y,w,h)
	end

	def pg_renderNoFill(pg)
		pg.noFill()
		pg.rect(x,y,w,h)
	end
end

class TextFrame
	attr_accessor :txt, :x, :y, :w, :h, :c
	def initialize(*dimentions)
		@txt, @x, @y, @w, @h = *dimentions
		@c = [100, 100, 100]
	end

	def render
		fill(color(*c))
		rect(x,y,w,h)
		fill 255
		text txt, x, y, w, h
	end

	def renderNoFill
		noFill()
		rect(x,y,w,h)
		fill 255
		text txt, x, y, w, h
	end

	def renderNoFillNoStroke
		noStroke
		fill 255
		text txt, x, y, w, h
	end

	def pg_render(pg)
		# pg.fill(color(*c))
		# pg.rect(x,y,w,h)
		pg.fill 255
		pg.text txt, x, y, w, h
	end

	def pg_renderNoFill(pg)
		pg.noFill()
		pg.rect(x,y,w,h)
		pg.fill 255
		pg.text txt, x, y, w, h
	end
end

class ScrollableRegion
	attr_accessor :pg

	attr_accessor :BoundingFrame, :ContentFrame
	
	attr_accessor :IsScrolling, :original_mouse_y, :original_content_y

	attr_accessor :content

	def initialize(*dimentions)
		@pg = createGraphics(dimentions[2], dimentions[3])
		@BoundingFrame = Frame.new(*dimentions)
		@ContentFrame = Frame.new(*[0, 0, dimentions[2], dimentions[3] * 2])
		@content = []
	end

	def render
		if mouse_pressed? && @BoundingFrame.IsMouseInside
			@IsScrolling = true
		else
			@IsScrolling = false
			@original_mouse_y = mouse_y
			@original_content_y = @ContentFrame.y
		end

		if @IsScrolling
			@ContentFrame.y = @original_content_y + @original_mouse_y - mouse_y
		else
			if @ContentFrame.y > 0 
				@ContentFrame.y = lerp @ContentFrame.y, 0, 0.5
			elsif @ContentFrame.y < @BoundingFrame.h - @ContentFrame.h 
				@ContentFrame.y = lerp @ContentFrame.y, @BoundingFrame.h - @ContentFrame.h , 0.5
			end
		end

		stroke(0)
		@pg.beginDraw()
		
		@pg.clear

		@ContentFrame.h = content.length * (textAscent + textDescent)

		@ContentFrame.pg_renderNoFill(@pg)
		
		@content.each do |e|
			e.pg_render(@pg)
		end
		
		# @pg.noFill()
		# @pg.stroke(255)
		# @pg.ellipse(mouse_x - @BoundingFrame.x, mouse_y - @BoundingFrame.y, 60, 60)
		
		@pg.endDraw()

		image(@pg, @BoundingFrame.x, @BoundingFrame.y)
		@BoundingFrame.renderNoFill
	end
end

class ExploitInstance
	attr_accessor :IP, :TimeStamp

	def initialize(*info)
		puts "adding", info[0], info[1]
		@IP = info[0]
		@TimeStamp = info[1]
	end
end

class Exploit
	attr_accessor :description, :name, :mitigation
	attr_accessor :Selection_Frame, :Information_Frame, :FrequencyFrame

	attr_accessor :IsSelected

	attr_accessor :Instances

	attr_accessor :Alert

	def initialize(_name)
		@description = ""
		@name = _name
		
		@Selection_Frame = Frame.new(0,0,0,0)
		@Information_Frame = Frame.new(0,0,0,0)
		@FrequencyFrame = Frame.new(0,0,0,0)

		@IsSelected = false

		@Instances = []

		@Alert = AlertIcon.new(0,0)
	end

	def addInstance(*info)
		@Instances << ExploitInstance.new(info[0], info[1])
		@Alert.num_alerts += 1
	end
end

class AlertIcon
	attr_accessor :num_alerts
	attr_accessor :x, :y

	def initialize(*coords)
		@x, @y = *coords
		@num_alerts = 0
	end

	def SetCoords(*coords)
		@x, @y = *coords
	end

	def dismiss
		@num_alerts = 0
	end

	def render
		if @num_alerts != 0
			# Exclamation mark
			noStroke
			ellipse_mode(CENTER)
			fill 0
			ellipse x, y, 20, 20
			fill 255
			ellipse x, y, 18, 18
			fill color(116, 0, 0)
			ellipse x, y + 5, 4, 4
			rect_mode(CENTER)
			rect x, y - 3, 4, 10

			# Number Indicator
			fill color(255, 0, 0)
			ellipse x + 8, y - 8, 10 * @num_alerts.to_s.length, 10

			fill 255
			text_align(CENTER, CENTER)
			text_size 9
			text @num_alerts.to_s, x + 8, y - 10
			text_size 14
			rect_mode(CORNER)
		end
	end
end

# ============== Program ============== 

# ---------- Security Monitor ---------

# Stream Checking

def checkStream(pkt)
	errorDetected = false;
	$incident = "test"

	# Check TCP vulnerabilities
	if pkt.proto.last == "TCP"
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
		# puts "VISA"
	end
	if line =~ /5\d{3}(\s|-)?\d{4}(\s|-)?\d{4}(\s|-)?\d{4}/
		ret = true
		# puts "Mastercard"
	end
	if line =~ /6011(\s|-)?\d{4}(\s|-)?\d{4}(\s|-)?\d{4}/
		ret = true
		# puts "Discover"
	end
	if line =~ /3\d{3}(\s|-)?\d{6}(\s|-)?\d{5}/
		ret = true
		# puts "AMERICAN"
	end
	
	return ret
end

# Log Checking

def checkLog(line)
	if line == nil
		return
	end
	errorDetected = false
	if checkLogShellShock(line)
		errorDetected = true
			$incident = "SHELL SHOCK"
	elsif checkLogPhpMyAdmin(line)
		errorDetected = true
			$incident = "PhpMyAdmin exploit"
	elsif checkLogMasscan(line)
		errorDetected = true
			$incident = "MASSCAN"
	elsif checkLogShell(line)
		errorDetected = true
			$incident = "SHELL CODE"
	elsif checkLogNmap(line)
		errorDetected = true
			$incident = "NMAP"
	end


	# token = /^(.*?)\s+(.*?)\s+(.*?)\s+(\[.*?\])\s+(\".*?\")\s+(\d+)\s+(\d+)$/.match(line)
	# apache_line = /^(?<ip_address>\S+) \S+ \S+ \[(?<time>[^\]]+)\] "([A-Z]+)[^"]*" \d+ \d+ "[^"]*" "([^"]*)"$/m

	if errorDetected
		apache_line = /\A(?<ip_address>\S+) \S+ \S+ \[(?<time>[^\]]+)\] "(?<method>GET|POST) (?<url>\S+) \S+?" (?<status>\d+) (?<bytes>\S+) (?<mys>.*$)/
		parts = apache_line.match(line)
		if parts != nil
			# puts "#{$incident_number}. ALERT: #{$incident} is detected from #{parts[:ip_address]} (HTTP) (#{parts[:method]} #{parts[:url]} #{parts[:status]} #{parts[:bytes]} #{parts[:mys]})!"	
			
			if $incident == "SHELL SHOCK"
				@Exploits[6].addInstance(parts[:ip_address].to_s, parts[:time].to_s)				
			elsif $incident == "PhpMyAdmin exploit"
				@Exploits[7].addInstance(parts[:ip_address].to_s, parts[:time].to_s)				
			elsif $incident == "MASSCAN"
				@Exploits[8].addInstance(parts[:ip_address].to_s, parts[:time].to_s)				
			elsif $incident == "SHELL CODE"
				@Exploits[9].addInstance(parts[:ip_address].to_s, parts[:time].to_s)				
			elsif $incident == "NMAP"
				@Exploits[4].addInstance(parts[:ip_address].to_s, parts[:time].to_s)				
			end 
				
		end
		$incident_number = $incident_number + 1
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

def startupAlarm
	# Read Log
	if ARGV.length >= 2
		# puts "arg " + ARGV.map{|a| puts a }
		if ARGV[0] == '-r'
			File.open(ARGV[1], "r") do |f|
				f.each_line do |line|
					checkLog(line)
				end
			end
		end

	# Otherwise Read Stream
	elsif 1 == 2
		# stream = PacketFu::Capture.new(:start => true, :iface => iface, :promisc => true)
		# stream.show_live()

		# For every stream
		stream.stream.each do |p|
			# parse the packet
			pkt =  Packet.parse p
			# Check if it's an IP
			if pkt.is_ip?
				next if pkt.ip_saddr == Utils.ifconfig(iface)[:ip_saddr] 
				
				# # Uncomment to Show basic packet information
				# packet_info = [pkt.ip_saddr, pkt.ip_daddr, pkt.size, pkt.proto.last]
				# if pkt.ip_saddr.to_s == "173.194.123.116"
				# 	puts "%-15s -> %-15s %-4d %s" % packet_info	
				# end
				
				checkStream(pkt)
		    end
		end
	end
end

# ----------- Visualization -----------

# Initialization
def setup
	
	# Set up main window
  	size WIDTH, HEIGHT
  	
  	@ScrollArea = ScrollableRegion.new(BARX + PADDING, 5 * PADDING, width - BARX - 2 * PADDING, height - TIMEY - 6 * PADDING)

	# ---- Set up data structures ----
	
	# Frames
	@Frames = []
  	@Frames << @ThreatFrame = Frame.new(0, 0, BARX, height - TIMEY)
  	@Frames << @BreakdownFrame = Frame.new(BARX, 0, width - BARX, height - TIMEY)
	@Frames << @TimeFrame = Frame.new(2 * PADDING, height - TIMEY + 2 * PADDING, width - 4 * PADDING, TIMEY - 4 * PADDING)
  	
  	@DescriptionFrame = Frame.new(
  		@BreakdownFrame.x + PADDING,
  		@BreakdownFrame.y + PADDING,
  		@BreakdownFrame.w - 2 * PADDING,
  		@BreakdownFrame.h / 3 - 4.0 * PADDING / 3)
  	
  	@MitigationFrame = Frame.new(
  		@BreakdownFrame.x + PADDING,
  		@BreakdownFrame.y + 2 * PADDING + @BreakdownFrame.h / 3 - 4.0 * PADDING / 3,
  		@BreakdownFrame.w - 2 * PADDING,
  		@BreakdownFrame.h / 3 - 4.0 * PADDING / 3)
  	
  	@AttackFrame = Frame.new(
  		@BreakdownFrame.x + PADDING,
  		@BreakdownFrame.y + 3 * PADDING + 2 * (@BreakdownFrame.h / 3 - 4.0 * PADDING / 3),
  		@BreakdownFrame.w - 2 * PADDING,
  		@BreakdownFrame.h / 3 - 4.0 * PADDING / 3)

  	@IPFrame = ScrollableRegion.new(
  		@BreakdownFrame.x + 2 * PADDING,
  		@BreakdownFrame.y + 6 * PADDING + 2 * (@BreakdownFrame.h / 3 - 4.0 * PADDING / 3),
  		@BreakdownFrame.w - 4 * PADDING,
  		@BreakdownFrame.h / 3 - 4.0 * PADDING / 3 - 4 * PADDING)

  	@ThreatFrame.c = [150, 100, 100]
  	@TimeFrame.c = [100, 100, 150]
  	@BreakdownFrame.c = [100, 150, 100]
	
	# Exploits
	@ExploitNames = 
	[
		"NULL", 
		"FIN", 
		"XMAS", 
		"Nikto", 
		"NMAP", 
		"Credit Card", 
		"Shell Shock", 
		"PHP MyAdmin", 
		"Masscan", 
		"Shell code"
	]
	@ExploitDescriptions = 
	[
		"NULL sends a TCP packet with everything in the header set to NULL, and then waits for a response to probe your machine and see what it can figure out about your connections.", 
		"FIN sends a TCP packet with the FIN flag set to 1, then uses the response to see the vulnerabilities of your system", 
		"XMAS Sets the FIN, PSH, and URG flags of a TCP packet header, \"lighting the packet up like a Christmas tree.\" Then uses the response to see the vulnerabilities of your system", 
		"Nikto is an Open Source (GPL) web server scanner which performs comprehensive tests against web servers for multiple items, including over 6700 potentially dangerous files/programs, checks for outdated versions of over 1250 servers, and version specific problems on over 270 servers. It also checks for server configuration items such as the presence of multiple index files, HTTP server options, and will attempt to identify installed web servers and software. Scan items and plugins are frequently updated and can be automatically updated.", 
		"Nmap (\"Network Mapper\") is a free and open source (license) utility for network discovery and security auditing. Many systems and network administrators also find it useful for tasks such as network inventory, managing service upgrade schedules, and monitoring host or service uptime. Nmap uses raw IP packets in novel ways to determine what hosts are available on the network, what services (application name and version) those hosts are offering, what operating systems (and OS versions) they are running, what type of packet filters/firewalls are in use, and dozens of other characteristics. It was designed to rapidly scan large networks, but works fine against single hosts. Nmap runs on all major computer operating systems, and official binary packages are available for Linux, Windows, and Mac OS X. In addition to the classic command-line Nmap executable, the Nmap suite includes an advanced GUI and results viewer (Zenmap), a flexible data transfer, redirection, and debugging tool (Ncat), a utility for comparing scan results (Ndiff), and a packet generation and response analysis tool (Nping).", 
		"Credit Card information is encoded with basic patterning for different credit card companies.  By using unencrypted transmissions, it is easy for an attacker to see when you are sending out a number associated with a credit card.", 
		"Shell Shock allows the user to execute arbitrary bash scripts on your machine.  This gives them potentially full access to your computer.", 
		"phpMyAdmin is an administrative tool used for managing MySQL as it relates to a server.  However, there are many system exploits that can be done with phpMyAdmin.", 
		"Rob Graham's Masscan This is the fastest Internet port scanner. It can scan the entire Internet in under 6 minutes, transmitting 10 million packets per second. It produces results similar to nmap, the most famous port scanner. Internally, it operates more like scanrand, unicornscan, and ZMap, using asynchronous transmission. The major difference is that it's faster than these other scanners. In addition, it's more flexible, allowing arbitrary address ranges and port ranges.", 
		"Shell code is computer code designed to run on a terminal program that can execute arbitrary functions on your computer.  Compiled shellcode is in hexadecimal format and can be searched for by looking for the \\x character"
	]
	@ExploitMitigations = 
	[
		"NULL", 
		"FIN", 
		"XMAS", 
		"nikto", 
		"NMAP", 
		"Credit Card", 
		"Shell Shock", 
		"PHP", 
		"masscan", 
		"Shell code"
	]
	@ExploitColors = 
	[
		# [106,  74,  60],  # TCP
		[116,   0, 160],  # NULL
		[ 63,  18, 161],  # FIN
		[ 20, 100,  60],  # XMAS
		[  7,  86, 214],  # nikto
		[  0, 151, 213],  # NMAP
		[197,  22,  29],  # Credit Card
		[ 55,  50,  50],  # Shell Shock
		[113,   0,   0],  # PHP
		[200,  85,   0],  # masscan
		[ 25,  25,  25]   # Shell code
	]
	@Exploits = []
	# Populate Exploit objects
	@ExploitNames.each do |e|
		@Exploits << Exploit.new(e)
	end
	# Initialize objects
	for i in 0..(@ExploitNames.length - 1)
		@Exploits[i].description = @ExploitDescriptions[i]
		@Exploits[i].mitigation = @ExploitMitigations[i]
		@Exploits[i].Selection_Frame.c = @ExploitColors[i]
		@Exploits[i].Information_Frame.c = @ExploitColors[i]
		@Exploits[i].FrequencyFrame.c = @ExploitColors[i]
		@Exploits[i].Information_Frame.SetFrame(*@BreakdownFrame.CopyDimentions)
	end

	startupAlarm
end

# Draw loop
def draw
  	# Erase
  	background 255
  	
  	# Draw Background
  	# @Frames.each do |f|
  	# 	if f.IsMouseInside
  	# 		if mouse_pressed?
  	# 			fill color(255, 255, 255)	
  	# 		else
  	# 			fill color(*([f.c[0] + 10,f.c[1] + 10, f.c[2] + 10]))
  	# 		end
  	# 	else
  	# 		fill color(*f.c)
  	# 	end
  	# 	rect f.x, f.y, f.w, f.h
  	# end

	for i in 0..(@Exploits.length - 1)
		if @Exploits[i].IsSelected
  			draw_description(i)	
  		end
  	end
  	# For every Exploit
  	for i in 0..(@Exploits.length - 1)
  		# Update Selection Frame
  		@Exploits[i].Selection_Frame.SetFrame(@ThreatFrame.x, @ThreatFrame.y + (1.0 * i / @Exploits.length) * @ThreatFrame.h, BARX, 1.0 * @ThreatFrame.h / @Exploits.length)
  		if mouse_pressed? && @Exploits[i].Selection_Frame.IsMouseInside
  			@Exploits.each do |e|
  				e.IsSelected = false
  			end
  			@Exploits[i].IsSelected = true
  			@Exploits[i].Alert.dismiss
  		end
  		# Draw Frame
  		if @Exploits[i].IsSelected
  			noStroke
  			@Exploits[i].Selection_Frame.render
  			stroke 0
  			line(@Exploits[i].Selection_Frame.x,@Exploits[i].Selection_Frame.y,@Exploits[i].Selection_Frame.x+@Exploits[i].Selection_Frame.w,@Exploits[i].Selection_Frame.y)
  			line(@Exploits[i].Selection_Frame.x,@Exploits[i].Selection_Frame.y,@Exploits[i].Selection_Frame.x,@Exploits[i].Selection_Frame.y+@Exploits[i].Selection_Frame.h)
  		else
  			stroke 0
  			@Exploits[i].Selection_Frame.render
  		end
  		

  		# Write Text for Frame
  		fill 255
  		text_align(CENTER, CENTER)
  		text(@Exploits[i].name, @ThreatFrame.x + @ThreatFrame.w / 2, @ThreatFrame.y + ((1.0 * i / @Exploits.length) * @ThreatFrame.h) + (0.5 * @ThreatFrame.h / @Exploits.length))

  		# Render Alert
  		@Exploits[i].Alert.SetCoords(@Exploits[i].Selection_Frame.x + 2 * PADDING, @Exploits[i].Selection_Frame.y + @Exploits[i].Selection_Frame.h / 2)
  		@Exploits[i].Alert.render


  	end
  	
  	draw_breakdown
end


def draw_description(i)
	# Draw Background
	noStroke()
	@Exploits[i].Information_Frame.render

	@DescriptionFrame.c = lighten(@Exploits[i].Information_Frame.c)
  	@MitigationFrame.c = lighten(@Exploits[i].Information_Frame.c)
  	@AttackFrame.c = lighten(@Exploits[i].Information_Frame.c)
  	@IPFrame.ContentFrame.c = lighten(@Exploits[i].Information_Frame.c)
  	
  	@DescriptionFrame.render
  	@MitigationFrame.render
  	@AttackFrame.render
  	@IPFrame.render

	fill 255
	text_align(LEFT, TOP)
	text("Description", @DescriptionFrame.x + PADDING, @DescriptionFrame.y + PADDING)
  	TextFrame.new(@Exploits[i].description, 
  		@DescriptionFrame.x + 2 * PADDING, 
  		@DescriptionFrame.y + textAscent + textDescent + 2 * PADDING,
  		@DescriptionFrame.w - (3 * PADDING),
  		@DescriptionFrame.h - (3 * PADDING + textAscent + textDescent)).renderNoFillNoStroke
  	
  	text("Mitigation", @MitigationFrame.x + PADDING, @MitigationFrame.y + PADDING)
  	TextFrame.new("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",#@lorem_ipsum,#@Exploits[i].mitigation, 
  		@MitigationFrame.x + 2 * PADDING, 
  		@MitigationFrame.y + textAscent + textDescent + 2 * PADDING,
  		@MitigationFrame.w - (3 * PADDING),
  		@MitigationFrame.h - (3 * PADDING + textAscent + textDescent)).renderNoFillNoStroke

  	text("Attack Information (from " + @Exploits[i].Instances.length.to_s + " " + @Exploits[i].name + " attacks)", @AttackFrame.x + PADDING, @AttackFrame.y + PADDING)

  	if mouse_pressed? && @AttackFrame.IsMouseInside
  		puts Dir.pwd + "/../geoTest/geoCoder/geotesting/app/IPlogs/" + @Exploits[i].name + ".log"
  		File.open(Dir.pwd + "/../geoTest/geoCoder/geotesting/app/IPlogs/" + @Exploits[i].name + ".log", 'w') {|f| 
  			@Exploits[i].Instances.each do |instance|
  				f.write(instance.IP + "\n") 
  			end
  		}
  	end

  	index = 0  	
	@IPFrame.content = @Exploits[i].Instances.map{ |a| [TextFrame.new("IP Address of Attack: " + a.IP + "   Time of Attack: " + a.TimeStamp, @IPFrame.ContentFrame.x + PADDING,@IPFrame.ContentFrame.y + (textAscent + textDescent) * index,@IPFrame.ContentFrame.w,textAscent + textDescent), index += 1] }.map{ |x, y| x }

  	stroke(0)
end

def draw_breakdown
	
	noStroke
	fill 50
	rect 0, HEIGHT - TIMEY, WIDTH, TIMEY

	stroke 255

	sum = 0
	@Exploits.each do |e|
		sum += e.Instances.length
	end

	if sum != 0
		current_x = @TimeFrame.x

		for i in 0..(@Exploits.length - 1)
			@Exploits[i].FrequencyFrame.SetFrame(
				current_x, 
				@TimeFrame.y, 
				(1.0 * @Exploits[i].Instances.length / sum) * @TimeFrame.w, 
				@TimeFrame.h)
			@Exploits[i].FrequencyFrame.render

			current_x += (1.0 * @Exploits[i].Instances.length / sum) * @TimeFrame.w
		end

		for i in 0..(@Exploits.length - 1)
			if @Exploits[i].FrequencyFrame.IsMouseInside
				fill 255
				text_align(RIGHT, BOTTOM)
				text(@Exploits[i].Instances.length.to_s, mouse_x, mouse_y)
			end
		end
	end

	stroke 0
end

def addArray(*input)
	return *input[0].zip(input[1]).map { |arr| arr.inject { |sum, x| sum + x } }
end

def lighten(original)
	return *[original[0] + SHADE_FACTOR, original[1] + SHADE_FACTOR, original[2] + SHADE_FACTOR]
end

def darken(original)
	return *[original[0] - SHADE_FACTOR, original[1] - SHADE_FACTOR, original[2] - SHADE_FACTOR]
end