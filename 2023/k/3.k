i:0:"3.txt"

s:"*&+#$@%-=/"
n:"0"+!10

m:{|/x=\:}
splode:{|/'3':0,x,0}
lead:{1,(-1+#x)#0}
cutpoint:{|/m[".",s]'x,y}
bin:{&(lead x)|cutpoint':x}
cut:{(bin x)_x}

mask:+splode'+splode'm[s]''i
st:{(?{x'y}.)'(+(bin'x;&'(&).'+(m[n]''x;y)))}
partnumbers:{`I${x@y}.'{0<#'(+x)@1}#+(cut'x;st[x;y])}
"Part 1: ",$+/,/partnumbers[i;mask]

p:+{" ",x," "}'+{"   ",x,"   "}'i
scope:{+'x':''y':}
star:{"*"=x[1][3]}
w:,/scope[7][3]p
sw:{star'w}#w
mask:{0 0,x,0 0}'3 3#1

nums:,/'partnumbers[;mask]'sw
"Part 2: ",$+/*/'{2=#'nums}#nums
