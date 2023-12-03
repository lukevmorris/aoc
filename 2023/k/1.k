i:0:"1.txt"
a:"a"+!26
d:("one"; "two"; "three"; "four"; "five"; "six"; "seven"; "eight"; "nine")

/Find starting index(es) of a digit
/f["one"; "phonetone"]
/-> 0 0 1 0 0 0 1 0 0
f:{(x~)'(#x)':((#x)+(#y)-1)$y}

/Compute a "digit mask" for amendment of the input string
/g["two1nine"]
/-> 2 0 0 0 9 0 0 0
g:{|/(1+!#d)*f[;x]'d}

/Replace the first character word digits with numerals
r:{`c$',/($g@x)|x*~g@x}
p1:{`I${x(0;-1+#x)}@x^a}

"D1P1: ",$+/p1'i
"D1P2: ",$+/p1'r'i
