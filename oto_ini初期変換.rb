# coding: UTF-8

require 'csv'

BEGIN {
	puts __FILE__
	puts "あ行と「ん」の先行発音を5、オーバーラップを0に、"
	puts "か行「たつと」ぱ行のオーバーラップを-30にする"
	puts "\n\n"
}

END{
	puts "\n\n"
	puts "終了。。。"
}

IN_FILE_NAME = "oto.ini"
OUT_FILE_NAME = "oto_output.ini"
FILE_ENCODING = "Windows-31J"	# oto.iniのエンコード
RUBY_ENCODING = "UTF-8"	# Ruby内部で使う文字コード

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
			rows[i][4] = "5"	# 先行発音を5に固定
			rows[i][5] = "0"	# オーバーラップを0に固定
		end

		if /[かきくけこたつとぱぴぷぺぽ]/ =~ wav_name
			rows[i][5] = "-30"	# オーバーラップを-30に固定
		end

		puts_progress(i, 10)
	end

	return rows
end

#----------------------------------------------------
# main
#----------------------------------------------------

if ARGV.size == 1 && File.basename(ARGV[0]) == IN_FILE_NAME
	file_pass = ARGV[0]
else
	raise ArgumentError, "#{IN_FILE_NAME} へのパスを指定してね"
end

rows = CSV.read(file_pass, encoding: "#{FILE_ENCODING}:#{RUBY_ENCODING}")

puts "変換開始"
rows = convert(rows)
puts "\n完了\n\n"

CSV.open(OUT_FILE_NAME,"w", encoding: "#{FILE_ENCODING}:#{RUBY_ENCODING}") do |output_line|
	rows.each do |row|
		output_line << row
	end
end

puts "#{OUT_FILE_NAME}を出力したよ"
