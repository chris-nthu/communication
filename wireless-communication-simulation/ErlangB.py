import numpy as np

def SimplifyErlangB(traffic, channels):
    B = 1

    for i in range(0, channels):
        B = (traffic * B) / (traffic * B + i)
    
    return B

def main():
    blockingProb = [0.01, 0.03, 0.05, 0.1] # blocking probability
    traffic = np.zeros((20, 4))

    for m in range(1, 21):
        B = 1 # initialize
        load = np.arange(0, m, .0001)
        
        for i in range(1, m):
            B = (B * load) / (B * load + i)

        for j in range(0, 4):
            index = min(abs(B-blockingProb[j]))
            print(index)
        


if __name__ == '__main__':
    main()