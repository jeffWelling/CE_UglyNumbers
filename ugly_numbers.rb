#!/usr/bin/env ruby1.9.1
#1 Argument: filename
#
#File contains sequences of digits eg. 123456, one sequence per line
#maxlength of any sequence is 13 digits
#
#An ugly number is a number divisible any of (2,3,5,7)
#
#For all sequences in the file, print out the number of expressions
#that evaluate to an ugly number
#
#An acceptable expression: 1+2-3456 = X where X is an ugly number
require 'pp'

if ARGV[0]
	sequences= File.open( File.expand_path(ARGV[0]) ).read.split("\n")
end



class Platter
	def initialize sequence
		@@seq=Array.new
		@@orig_seq=sequence
		sequence.split('').each {|i| @@seq << i; @@seq << '0' }
		#@@seq==[1,0,2,0,3,0,4,0,5,0,6,0,7,0,8,0,9,0,10,0,11,0,12,0,13]
		@@seq.pop
	end

	def inspect
		pool_of_operators=[ '', '+', '-' ]
		line=""
		@@seq.each_index {|i| 
			if i.even? 
				line << @@seq[i]
			elsif @@seq[i].to_i <= 2
				line << pool_of_operators[@@seq[i].to_i]
			end 
		}
		line
	end

	def calc_exp
		expressions=[]
		last_round=""


		begin
			until bump(1)==last_round do
				if ugly?( eval( self.inspect) )
				  puts "self.inspect: #{self.inspect}=#{eval(self.inspect)} - is ugly!"
					expressions << (self.inspect << "=#{eval(self.inspect)}")
				else
				  puts "self.inspect: #{self.inspect}=#{eval(self.inspect)} - is NOT ugly!"
				end
			end
		rescue => e
			#This is for debugging purposes, without it, all errors are caught here
			#and I can't determine why something failed
			raise e unless e.to_s=="done"
			#printf "Done!   Sequence: #{@@orig_seq} has #{expressions.length} number of expressions that eval to an ugly number.\n"
			puts expressions.length
		end

		last_round=self.inspect
	end


	def bump cylinder
		if @@seq[cylinder].to_i >= 2
			@@seq[cylinder]='0'
			unless cylinder == 24
				bump(cylinder+2) 
			end
		elsif cylinder >= @@seq.length
			raise 'done'
		else
			@@seq[cylinder]= (@@seq[cylinder].to_i + 1).to_s
		end
		self.inspect
	end

end

def ugly? i
	if (i % 2)==0 or (i % 3)==0 or (i % 5)==0 or (i % 7)==0
		return true
	else
		return false
	end
end

begin
sequences.each {|seq|
	puts "Calculating sequence #{seq}..."
	p=Platter.new seq
	p.calc_exp
}
rescue
end
