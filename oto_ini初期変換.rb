# coding: UTF-8

require 'csv'

BEGIN {
	puts __FILE__
	puts "あ行と「ん」の先行発音を5、オーバーラップを0に、\nか行「たつと」ぱ行のオーバーラップを-30にする\n"
	puts "\n"
}

#----------------------------------------------------
# function
#----------------------------------------------------

# 進捗表示(time回ずつ点を打つ)
def puts_progress(i, time)
	if (i % time) == 0
		putc "."
	end
end

def convert(rows)
	rows.each_with_index do |row, i|
		wav_name = row[0]

		if /[あいうえおん]/ =~ wav_name
			# 先行発音を5に固定
			rows[i][4] = "5"
	
			# オーバーラップを0に固定
			rows[i][5] = "0"
	
			#p wav_name.encode("Windows-31J")
		end

		if /[かきくけこたつとぱぴぷぺぽ]/ =~ wav_name
			# オーバーラップを-30に固定
			rows[i][5] = "-30"
			#p wav_name.encode("Windows-31J")
		end

		puts_progress(i, 10)
	end

	return rows
end

#----------------------------------------------------
# main
#----------------------------------------------------

if ARGV.size == 1 && File.extname(ARGV[0]) == ".ini"
	file_pass = ARGV[0]
else
	raise ArgumentError, "oto.iniへのパスを指定してね"
end

rows = CSV.read(file_pass, encoding: "Windows-31J:UTF-8")

puts "変換開始"
rows = convert(rows)
puts "\n完了\n\n"

CSV.open("oto_output.ini","w", encoding: "Windows-31J:UTF-8") do |output_line|
	rows.each do |row|
		output_line << row
	end
end

puts "oto_output.iniを出力したよ"
