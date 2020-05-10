import numpy as np
import pandas as pd

#---------- Maximum Likelihood Approch ----------
def ML_Train(O1, O2, x1, x2, x3):

    P = O1*O2
    phi = np.ndarray(shape=(400,P+2))
    s1 = (max(x1)-min(x1))/(O1-1)
    s2 = (max(x2)-min(x2))/(O2-1)

    for i in range(1, O1+1):
        for j in range(1, O2+1):
            k = O2*(i-1)+j
            mu_i = s1*(i-1)+min(x1)
            mu_j = s2*(j-1)+min(x2)
            phi[:,k-1] = np.exp(-(((x1-mu_i)**2)/(2*(s1**2)))-(((x2-mu_j)**2)/(2*(s2**2))))
    
    phi[:,P] = x3
    phi[:,P+1] = np.ones(400)

    return phi


#---------- ML Predict & Least Square ----------
def ML_Predict():
    


#---------- Bayesian Linear Regression ----------


def main():

    O1 = 12
    O2 = 14

    df = pd.read_csv('Training_set.csv', header=None)
    x1 = df.values[:,0]
    x2 = df.values[:,1]
    x3 = df.values[:,2]

    phi = ML_Train(O1, O2, x1, x2, x3)


if __name__ == '__main__':
    main()
