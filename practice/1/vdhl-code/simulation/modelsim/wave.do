vsim disp7seg

add wave *

force SW(0) 0 0, 1 10 -repeat 20
force SW(1) 0 0, 1 20 -repeat 40
force SW(2) 0 0, 1 40 -repeat 80
force SW(3) 0 0, 1 80

run 160
