import math

def get_outputs(i, x, w, b):
    print(f"################### TEST #{i} ###################")
    print(f"X: {x}")
    print(f"W: {w}")
    print(f"b: {b}")

    sum = summation(x, w, b)
    print(f"Sum result:\t\t\t\t {sum}")

    f_z = sigmoid_output(sum)
    print(f"Sigmoid output:\t\t\t {f_z}")

    #the sum with 12 bits
    sum_in_circuit = round(sum/lsb_in)
    print(f"Sum value quantized:\t {sum_in_circuit}")

    f_z_in_circuit = round(f_z/lsb_out)
    print(f"Output value quantized:\t {f_z_in_circuit}")
def summation(x, w, b):
    sum = 0
    for i in range(0, 10):
        sum += x[i]*w[i]
    sum += b
    return sum

def sigmoid_output(s):
    res = (1)/(1 + math.exp(-s))
    return res

lsb_out = (1)/(2**15 - 1)
lsb_in = (32)/(2**11 - 1)
#Test #1
x = [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]

w = [1,1,1,1,1,1,1,1,1,1]

b = 0
get_outputs(1, x, w, b)

#Test #2
x = [-0.75,-0.75,-0.75,-0.75,-0.75,-0.75,-0.75,-0.75,-0.75,-0.75]
get_outputs(2, x, w, b)

#Test #3
x = [-0.5,-0.5,-0.5,-0.5,-0.5,-0.5,-0.5,-0.5,-0.5,-0.5]
get_outputs(3, x, w, b)

#Test #4
w = [0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5]
get_outputs(4, x, w, b)

#Test #5
w = [0,0,0,0,0,0,0,0,0,0]
get_outputs(5, x, w, b)

#Test #6
w = [-0.5,-0.5,-0.5,-0.5,-0.5,-0.5,-0.5,-0.5,-0.5,-0.5]
get_outputs(6, x, w, b)

#Test #7
x = [0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5]
w = [1,1,1,1,1,1,1,1,1,1]
get_outputs(7, x, w, b)

#Test #8
x = [0.75,0.75,0.75,0.75,0.75,0.75,0.75,0.75,0.75,0.75]
get_outputs(8, x, w, b)

#Test #9
x = [1,1,1,1,1,1,1,1,1,1]
get_outputs(9, x, w, b)

#Test #10
b = 1
get_outputs(10, x, w, b)

#Test #11
x = [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]
b = -1
get_outputs(11, x, w, b)
