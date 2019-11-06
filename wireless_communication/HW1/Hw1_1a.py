import numpy as np

def SimplifyErlangB(traffic, channels):
    B = 1

    for i in range(1, channels):
        B = (traffic * B) / (traffic * B + i)
    
    return B

def main():
    blockingProb = [0.01, 0.03, 0.05, 0.1] # blocking probability
    traffic = np.zeros((20, 4))

    for m in range(1, 21):
        index = 0
        i = 0
        while i <= 20:
            buffer = SimplifyErlangB(i, m)
            
            if index > 3:
                break

            if buffer > blockingProb[index]:
                traffic[m-1][index] = abs(i-0.001)
                index = index + 1

            i = i + 0.001
    
    print(traffic)

if __name__ == '__main__':
    main()