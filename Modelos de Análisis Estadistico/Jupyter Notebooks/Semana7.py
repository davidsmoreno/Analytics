import pandas as pd
import numpy as np
import statsmodels.api as sm
from statsmodels.sandbox.regression.predstd import wls_prediction_std

url = "http://archive.ics.uci.edu/ml/machine-learning-databases/auto-mpg/auto-mpg.data"
column_names = ["mpg", "cyl", "disp", "hp", "wt", "acc", "year", "origin", "name"]


autompg = pd.read_csv(url, sep="\s+", header=None, names=column_names)


#Clean the data

autompg = autompg[autompg['hp'] != '?']
autompg['hp'] = pd.to_numeric(autompg['hp'])
autompg = autompg[autompg['name'] != 'plymouth reliant']
autompg.index = autompg['cyl'].astype(str) + " cylinder " + autompg['year'].astype(str) + " " + autompg['name']
autompg = autompg[["mpg", "cyl", "disp", "hp", "wt", "acc", "year"]]

print(autompg.head())

print(autompg.describe())


import seaborn as sns
import matplotlib.pyplot as plt
sns.set(style="ticks",color_codes=True)

sns.pairplot(autompg,kind="reg")
plt.show()


import matplotlib.pyplot as plt
import seaborn as sns
coor=autompg.corr()
sns.heatmap(corr,xticklabels=corr.columns.values,yticklabels=corr.columns.values)
plt.show()