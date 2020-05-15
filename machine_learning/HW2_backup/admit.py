import numpy as np
import pandas as pd


#---------- Maximum Likelihood Approch ----------
def ML_Train(O1, O2, X_train):
    
    P = O1*O2
    phi = np.ndarray(shape=(400,P+2))
    s = [] # s[0] means s1 ; s[1] means s2
    mu = [[], []] # First row for mu_i ; Second row for mu_j

    s.append((max(X_train[:,0])-min(X_train[:,0]))/(O1-1))
    s.append((max(X_train[:,1])-min(X_train[:,1]))/(O2-1))

    for i in range(1, O1+1):
        for j in range(1, O2+1):
            k = O2*(i-1)+j
            mu_i = s[0]*(i-1)+min(X_train[:,0])
            mu_j = s[1]*(j-1)+min(X_train[:,1])
            mu[0].append(mu_i)
            mu[1].append(mu_j)
            phi[:,k-1] = np.exp(-(((X_train[:,0]-mu_i)**2)/(2*(s[0]**2)))-(((X_train[:,1]-mu_j)**2)/(2*(s[1]**2))))
    
    phi[:,P] = X_train[:,2]
    phi[:,P+1] = np.ones(400)

    return s, mu, phi


#---------- ML Predict & Least Square ----------
def ML_Predict(O1, O2, s, mu, phi, X_test, Y_test, Y_train):

    P = O1*O2
    phi_test = np.ndarray(shape=(100,P+2))
    w_ML = np.linalg.inv(phi.T.dot(phi)).dot(phi.T).dot(Y_train)
    index = 0

    for i in range(1, O1+1):
        for j in range(1, O2+1):
            k = O2*(i-1)+j
            mu_i = mu[0][index]
            mu_j = mu[1][index]
            phi_test[:,k-1] = np.exp(-(((X_test[:,0]-mu_i)**2)/(2*(s[0]**2)))-(((X_test[:,1]-mu_j)**2)/(2*(s[1]**2))))
            index = index+1
    
    phi_test[:,P] = X_test[:,2]
    phi_test[:,P+1] = np.ones(100)
    
    result = phi_test.dot(w_ML)
    squared_error = (result-Y_test)**2

    return result, squared_error


#---------- Bayesian Approach ----------
def Bayesian_Train(O1, O2, X_train, Y_train):

    P = O1*O2
    beta = 1
    m_0 = np.ones(P+2)
    S_0 = np.eye(P+2)
    phi = np.ndarray(shape=(400,P+2))
    s = []
    mu = [[], []]
    
    s.append((max(X_train[:,0]-min(X_train[:,0])))/(O1-1))
    s.append((max(X_train[:,1]-min(X_train[:,1])))/(O2-1))

    for i in range(1, O1+1):
        for j in range(1, O2+1):
            k = O2*(i-1)+j
            mu_i = s[0]*(i-1)+min(X_train[:,0])
            mu_j = s[1]*(j-1)+min(X_train[:,1])
            mu[0].append(mu_i)
            mu[1].append(mu_j)
            phi[:,k-1] = np.exp(-(((X_train[:,0]-mu_i)**2)/(2*(s[0]**2)))-(((X_train[:,1]-mu_j)**2)/(2*(s[1]**2))))
    
    phi[:,P] = X_train[:,2]
    phi[:,P+1] = np.ones(400)

    S_N_inv = np.linalg.inv(S_0)+beta*(phi.T.dot(phi))
    m_N = np.linalg.inv(S_N_inv).dot(phi.T).dot(Y_train)

    return s, mu, m_N


#---------- Bayesian Linear Regression predict ----------
def Bayesian_Predict(O1, O2, s, mu, m_N, X_test, Y_test):

    P = O1*O2
    phi_test = np.ndarray(shape=(100,P+2))
    w_MAP = m_N
    index = 0

    for i in range(1, O1+1):
        for j in range(1, O2+1):
            k = O2*(i-1)+j
            mu_i = mu[0][index]
            mu_j = mu[1][index]
            phi_test[:,k-1] = np.exp(-(((X_test[:,0]-mu_i)**2)/(2*(s[0]**2)))-(((X_test[:,1]-mu_j)**2)/(2*(s[1]**2))))
            index = index+1
    
    phi_test[:,P] = X_test[:,2]
    phi_test[:,P+1] = np.ones(100)

    result = phi_test.dot(w_MAP)
    squared_error = (result-Y_test)**2

    return result, squared_error


def main():

    O1 = 12
    O2 = 14

    # Read training data set
    df = pd.read_csv('Training_set.csv', header=None)
    df = df.values
    X_train = df[:,0:3] # Scores and Research Experience
    Y_train = df[:,3] # Chance of Admit

    # Read testing data set
    df = pd.read_csv('Testing_set.csv', header=None)
    df = df.values
    X_test = df[:,0:3]
    Y_test = df[:,3]

    # Use Maximum Likelihood and Least Squares Approach to train the model
    s, mu, phi = ML_Train(O1, O2, X_train)

    # Use trained linear model to predict the chance of admit and compute the squared error
    ML_result, ML_squared_error = ML_Predict(O1, O2, s, mu, phi, X_test, Y_test, Y_train)

    # Use Bayesian Linear Regression Approach to train the model
    s, mu, m_N = Bayesian_Train(O1, O2, X_train, Y_train)

    # Use trained Bayesian Linear model to predict the chance of admit and compute the squared error
    Bayesian_result, Bayesian_squared_error = Bayesian_Predict(O1, O2, s, mu, m_N, X_test, Y_test)

    print(ML_squared_error)
    print(Bayesian_squared_error)


if __name__ == '__main__':
    main()
