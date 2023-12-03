/Parse a game into list of dicts of color->count
/ f"2 red, 2 green; 1 red, 1 green, 2 blue"
/ -> (("red";"green")!2 2
/     ("red";"green";"blue")!1 1 2
p:(`I$(!).|+" "\'", "\)'"; "\*|": "\

/Compute a matrix of red-green-blue counts per game
c:{0^x@("red";"green";"blue")}

/Determine if a dict of color->count is impossible
/ i("red";"green")!2 2
/ -> 0
/ i("red";"blue")!100 2
/ -> 1
i:{0<+/12 13 14<0^c x}

/Determine minimum number of dice for game to be possible
m:{|/c x}

p1:{0=+/i'p x}
p2:{*/|/c'p x}
"D2P1: ",$+/1+&p1'0:"2.txt"
"D2P2: ",$+/p2'0:"2.txt"
