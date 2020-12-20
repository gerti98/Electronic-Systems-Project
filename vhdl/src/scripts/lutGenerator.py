"""
LSB(out) = (1)/(2^15 - 1) = 3.0518509475997192297128208258309e-5
LSB(in) = (11)/(2^11 - 1) = 0.00537371763556424035173424523693

What to store in the lut? round(f(x)/LSB(out)) for x in [0; 2047]*LSB(in)
"""

import math

#Calculate lsb of x (16 bits) and f(x) (12 bits)
lsb_out = (1)/(2**15 - 1)
lsb_in = (11)/(2**11 - 1)
result = ""


for x in range(0, 2048):

    f_x = (1)/(1 + math.exp(-(x*lsb_in)))
    lut = round(f_x/lsb_out)

    #Generate lut entries for every x
    result += str(x) + " => " + str(lut) + ",\n"

print(result)
