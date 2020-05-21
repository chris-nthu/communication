import numpy as np
import pandas as pd

class Linear_Regression:
    def __init__(self, X_train, Y_train, X_test, Y_test, O1, O2):
        self.X_train = X_train
        self.Y_train = Y_train
        self.X_test = X_test
        self.Y_test = Y_test
        self.O1 = O1
        self.O2 = O2

        self.P = O1*O2
        self.s1 = (max(self.X_train[:,0])-min(self.X_train[:,0]))/(self.O1-1)
        self.s2 = (max(self.X_train[:,1])-min(self.X_train[:,1]))/(self.O2-1)
        self.alpha = 1
        self.beta = 1

    def feature_vector(self, X):
        phi = np.ndarray(shape=(len(X),self.P+2))

        for i in range(1, self.O1+1):
            for j in range(1, self.O2+1):
                k = self.O2*(i-1)+j
                self.mu_i = self.s1*(i-1)+min(self.X_train[:,0])
                self.mu_j = self.s2*(j-1)+min(self.X_train[:,1])
                phi[:,k-1] = np.exp(-(((X[:,0]-self.mu_i)**2)/(2*(self.s1**2)))-(((X[:,1]-self.mu_j)**2)/(2*(self.s2**2))))
     
        phi[:,self.P] = X[:,2]
        phi[:,self.P+1] = np.ones(len(X))

        return phi
    
    def ML_Train(self):
        return self.feature_vector(self.X_train)

    def ML_Predict(self, phi):
        w_ML = np.linalg.inv(phi.T.dot(phi)).dot(phi.T).dot(self.Y_train)

        result = self.feature_vector(self.X_test).dot(w_ML)
        squared_error = (result-self.Y_test)**2

        return result, squared_error
    
    def Bayesian_Train(self):
        m_0 = np.zeros(self.P+2)
        S_0 = (1/self.alpha)*np.eye(self.P+2)
        phi = self.feature_vector(self.X_train)

        S_N_inv = np.linalg.inv(S_0)+self.beta*(phi.T.dot(phi))
        m_N = np.linalg.inv(S_N_inv).dot(phi.T).dot(self.Y_train)

        return m_N
    
    def Bayesian_Predict(self, w_MAP):
        result = self.feature_vector(self.X_test).dot(w_MAP)
        squared_error = (result-self.Y_test)**2

        return w_MAP, result, squared_error


def data_split(train_data, test_data):
    return train_data[:,:3], train_data[:,3], test_data[:,:3], test_data[:,3]


if __name__ == '__main__':
    O1 = 2
    O2 = 4

    train_df = pd.read_csv('Training_set.csv', header=None)
    test_df = pd.read_csv('Testing_set.csv', header=None)

    X_train, Y_train, X_test, Y_test = data_split(train_df.values, test_df.values)

    linear_regression = Linear_Regression(X_train, Y_train, X_test, Y_test, O1, O2)

    phi = linear_regression.ML_Train()
    ML_result, ML_squared_error = linear_regression.ML_Predict(phi)

    m_N = linear_regression.Bayesian_Train()
    w_MAP, Bayesian_result, Bayesian_squared_error = linear_regression.Bayesian_Predict(m_N)
    
    print('----------------------------------------------------------------------')
    print('The Result of Maximum Likelihood Approach :')
    print('\nChance of Admit is \n', ML_result)
    print('\nSquared error is\n', ML_squared_error)
    print('----------------------------------------------------------------------')

    print('----------------------------------------------------------------------')
    print('The Result of Bayesian Approach :')
    print('\nw is\n', w_MAP)
    print('\nChance of Admit is \n', Bayesian_result)
    print('\nSquared error is\n', Bayesian_squared_error)
    print('----------------------------------------------------------------------')
