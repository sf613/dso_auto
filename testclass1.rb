def test
	yield 5
	puts "aaa"
	yield 10
end

test{|i| puts i}
