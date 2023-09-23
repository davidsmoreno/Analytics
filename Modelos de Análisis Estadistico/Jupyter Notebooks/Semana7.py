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
corr=autompg.corr()
sns.heatmap(corr,xticklabels=corr.columns.values,yticklabels=corr.columns.values)
plt.show()

import numpy as np
import statsmodels.api as sm


# Create linear regression model
X = autompg[["wt", "year"]]
X = sm.add_constant(X)  # Adds a constant (intercept) to the predictor
y = autompg['mpg']

model = sm.OLS(y, X).fit()

# get the coefficients

n=len(autompg)
p=len(model.params)

X=np.column_stack((np.ones(n),autompg["wt"],autompg["year"]))

y=autompg["mpg"].values


beta_hat_manual=np.linalg.inv(X.T @ X) @ X.T @ y
print(beta_hat_manual)

print(model.params)


### Siempre tiene que ser 1 ya que es la variable constante
model.conf_int(alpha=0.001, cols=None)





# Predictions for new data
new_cars = pd.DataFrame({'wt': [3500, 5000], 'year': [76, 81]})
new_cars = sm.add_constant(new_cars)  # Add constant for prediction



predictions = model.get_prediction(new_cars)
prediction_summary = predictions.summary_frame(alpha=0.01)  # 99% confidence
print(prediction_summary)

