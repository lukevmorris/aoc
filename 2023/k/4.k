i:0:"4.txt"
cards:({x=0N}_`I$" "\)''(" | "\)'(*|":"\)'i
points:#'{x^x^y}.'cards

"Part 1: ",$+/{*/x#2}'-1+{x=0}_points

init:(#points)#1
p:+(points;!#points)
g:{(s;n):y; x[1+n+!s]+: x[n]; x}

"Part 2: ",$+/init g/p
