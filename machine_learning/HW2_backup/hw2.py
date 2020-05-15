import numpy as np
import pandas as pd

#---------- Maximum Likelihood Approch ----------
def ML_Train(O1, O2, train_x1, train_x2, train_x3):

    P = O1*O2
    phi = np.ndarray(shape=(400,P+2))
    s1 = (max(train_x1)-min(train_x1))/(O1-1)
    s2 = (max(train_x2)-min(train_x2))/(O2-1)

    for i in range(1, O1+1):
        for j in range(1, O2+1):
            k = O2*(i-1)+j
            mu_i = s1*(i-1)+min(train_x1)
            mu_j = s2*(j-1)+min(train_x2)
            phi[:,k-1] = np.exp(-(((train_x1-mu_i)**2)/(2*(s1**2)))-(((train_x2-mu_j)**2)/(2*(s2**2))))
    
    phi[:,P] = train_x3
    phi[:,P+1] = np.ones(400)

    return phi


#---------- ML Predict & Least Square ----------
def ML_Predict(O1, O2, phi, train_x4, test_x1, test_x2, test_x3, test_x4):
    
    P = O1*O2
    phi = np.ndarray(shape=(400,P+2))
    s1 = (max(x1)-min(x1))/(O1-1)
    s2 = (max(x2)-min(x2))/(O2-1)
    W_ml = np.linalg.inv(phi.T.dot(phi)).dot(phi.T).dot(train_x4)

    for i in range(1, O1+1):
        for j in range(1, O2+1):
            k = O2*(i-1)+j
            mu_i = s1*(i-1)+min(x1)
            mu_j = s2*(j-1)+min(x2)

    print(W_ml)


#---------- Bayesian Linear Regression ----------


def main():

    O1 = 12
    O2 = 14

    # Read training data
    df = pd.read_csv('Training_set.csv', header=None)
    df = df.values
    train_x1 = df[:,0] # GRE Scores
    train_x2 = df[:,1] # TOEFL Scores
    train_x3 = df[:,2] # Research Experience
    train_x4 = df[:,3] # Chance of Admit

    # Read testing data
    df = pd.read_csv('Testing_set.csv', header=None)
    df = df.values
    test_x1 = df[:,0] # GRE Scores
    test_x2 = df[:,1] # TOEFL Scores
    test_x3 = df[:,2] # Research Experience
    test_x4 = df[:,3] # Chance of Admit

    # Use Maximum Likelihood and Least Squares Approach to train the model
    phi = ML_Train(O1, O2, train_x1, train_x2, train_x3)

    # Use trained linear model to predict the chance of admit and compute the squared error
    ML_Predict(O1, O2, phi, train_x4, test_x1, test_x2, test_x3, test_x4)


if __name__ == '__main__':
    main()
