import pandas as pd
import numpy as np
import random
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA
import matplotlib.pyplot as plt

wine = [[], [], []] # A 3D list to record each type of wine

def train_test_split(filename):

    wine_test = []
    wine_train = []

    # Read the given Wine.csv
    df = pd.read_csv(filename, header=None)
    df = df.values
    for i in range(len(df)):
        for j in range(3):
            if(df[i][0]==float(j+1)):
                wine[j].append(list(df[i]))
                break

    # Random shuffle the wine list
    for i in range(3):
        random.shuffle(wine[i])

    # Split test data and store in to test.csv
    for i in range(3):
       for j in range(18):
           wine_test.append(wine[i][j])
    wine_test = pd.DataFrame(wine_test)
    wine_test.to_csv('test.csv', index=False, header=False)

    # Split train data and store into train.csv
    for i in range(3):
        for j in range(18, len(wine[i])):
            wine_train.append(wine[i][j])
    wine_train = pd.DataFrame(wine_train)
    wine_train.to_csv('train.csv', index=False, header=False)


def training(filename):

    prior_prob = np.ndarray(shape=(3), dtype=float)
    mean = np.ndarray(shape=(3,14), dtype=float)
    var = np.ndarray(shape=(3,14), dtype=float)

    df = pd.read_csv(filename, header=None)
    df = df.values

    # Calculate priori probability
    for i in range(3):
        index = np.where(df[:,0]==i+1)[0]
        prior_prob[i] = (index.shape[0])/(df.shape[0])
        mean[i] = np.mean(df[index], axis=0)
        var[i] = np.var(df[index], axis=0)

    # Delete the first column of mean and variance
    mean = np.delete(mean, 0, axis=1)
    var = np.delete(var, 0, axis=1)

    return prior_prob, mean, var


def MAP_detect(filename, prior_prob, mean, var):

    likelihood = np.ndarray(shape=(3,13), dtype=float)
    MAP = np.ndarray(shape=(3,13), dtype=float)
    MAP_overall = np.ones(3)
    detection_result = []

    # Read testing dataset
    df = pd.read_csv(filename, header=None)
    df = df.values
    feature = np.delete(df, 0, axis=1)

    # Calculate the posteriori probability and select the maximum one
    for i in range(len(feature)):
        MAP_overall = np.ones(3)
        for j in range(3):
            # Subtitute test data into likelihood function (Gaussain distribution)
            likelihood[j] = (1/((2*np.pi*var[j]))**0.5)*np.exp(-1*((feature[i]-mean[j])**2)/(2*var[j]))

            # Calculate posteriori prabability * p(x)
            MAP[j] = prior_prob[j] * likelihood[j]

            # Calculate the overall posteriori prabability * p(x)
            for k in range(13):
                MAP_overall[j] = MAP_overall[j] * MAP[j][k]
        
        # Select the maximum one
        detection_result.append(np.argmax(MAP_overall) + 1)
    
    # Calculate the overall accuracy
    accuracy = np.where(detection_result==df[:,0])[0].shape[0] / len(feature)

    return detection_result, accuracy


def PCA_plot(filename):
    # load dataset into Pandas DataFrame
    df = pd.read_csv(filename, header=None)

    feature = np.delete(df.values, 0, axis=1) # Separating out the feature
    target = df.values[:,0] # Separating out the target

    # Standardizing the features
    feature = StandardScaler().fit_transform(feature)

    # PCA projection to 2D
    pca = PCA(n_components=2)
    principalComponents = pca.fit_transform(feature)
    principalDf = pd.DataFrame(data=principalComponents, columns=['principal component 1', 'principal component 2'])
    finalDf = pd.concat([principalDf, df[0]], axis=1)
    
    # Plot the scatter figure
    fig = plt.figure(figsize = (8,8))
    ax = fig.add_subplot(1,1,1) 
    ax.set_xlabel('Principal Component 1', fontsize = 15)
    ax.set_ylabel('Principal Component 2', fontsize = 15)
    ax.set_title('2 component PCA', fontsize = 20)
    targets = [1, 2, 3]
    colors = ['r', 'g', 'b']
    for target, color in zip(targets,colors):
        indicesToKeep = finalDf[0] == target
        ax.scatter(finalDf.loc[indicesToKeep, 'principal component 1']
                , finalDf.loc[indicesToKeep, 'principal component 2']
                , c = color
                , s = 50 )
    ax.legend(['type 1', 'type 2', 'type 3'])
    ax.grid()
    plt.show()
    

def main():

    # Split training and test data
    train_test_split('Wine.csv')

    # Calculate priori probability, mean value and variance of training data
    prior_prob, mean, var = training('train.csv')

    # Calculate MAP and make decision
    detection_result, accuracy = MAP_detect('test.csv', prior_prob, mean, var)

    print('MAP decison result =', detection_result)
    print('\nAccuracy(%) = {0:.4f}%'.format(accuracy*100))

    # Plot PCA figure
    PCA_plot('test.csv')


if __name__ == '__main__':
    main()
