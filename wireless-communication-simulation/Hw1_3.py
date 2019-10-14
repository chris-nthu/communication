import numpy as np

def SimplifyErlangB(traffic, channels):
    B = 1

    for i in range(1, channels):
        B = (traffic * B) / (traffic * B + i)
    
    return B

def main():
    blockingProb = [0.01, 0.03, 0.05, 0.1]
    channels = [120, 60, 40]

    traffic_cell = np.zeros((3, 4))

    for i in range(0, 3):
        index = 0
        j = 0
        m = channels[i]

        while j <= 130:
            buffer = SimplifyErlangB(j, m)

            if index > 3:
                break

            if buffer > blockingProb[index]:
                traffic_cell[i][index] = j
                index = index + 1
            
            j = j + 0.001
    
    traffic_load = np.zeros((3, 4))

    for i in range(0, 3):
        for j in range(0, 4):
            traffic_load[i][j] = traffic_cell[i][j] * (i+1)
        
    print(traffic_cell)
    print(traffic_load)

if __name__ == '__main__':
    main()
