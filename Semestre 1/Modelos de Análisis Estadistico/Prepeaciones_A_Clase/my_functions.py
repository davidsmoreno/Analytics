import numpy as np
from sklearn.base import BaseEstimator, RegressorMixin, clone
from sklearn.model_selection import cross_val_score
import statsmodels.api as sm
from mlxtend.feature_selection import SequentialFeatureSelector as SFS

# Definir funciones de puntuación fuera de la clase
def aic_scorer(estimator, X, y):
    return -1 * estimator.sm_model_.aic

def bic_scorer(estimator, X, y):
    return -1 * estimator.sm_model_.bic

# Clase SMWrapper actualizada para regresión logística (o regresión lineal si cambias sm.Logit por sm.OLS)
class SMWrapper(BaseEstimator, RegressorMixin):
    def __init__(self, model_class=sm.OLS):
        self.model_class = model_class
        self.sm_model_ = None

    def fit(self, X, y):
        X = sm.add_constant(X)
        self.sm_model_ = self.model_class(y, X).fit()
        return self

    def predict(self, X):
        return self.sm_model_.predict(sm.add_constant(X))

    def get_params(self, deep=True):
        return {"model_class": self.model_class}

    def set_params(self, **parameters):
        for parameter, value in parameters.items():
            setattr(self, parameter, value)
        return self

# Función para realizar la selección de características
def select_features_using_criterion(X, y, criterion='aic', forward=True, floating=False):
    if criterion == 'aic':
        scorer = aic_scorer
    elif criterion == 'bic':
        scorer = bic_scorer
    else:
        raise ValueError("Invalid criterion. Choose 'aic' or 'bic'")
    
    sm_model = SMWrapper()
    
    sfs = SFS(sm_model, 
              k_features=(1, X.shape[1]), 
              forward=forward, 
              floating=floating, 
              scoring=scorer, 
              cv=0)
    sfs = sfs.fit(X, y)
    
    return sfs

def calc_loocv_rmse(model):
    X=model.model.exog
    hat_matriz=X@np.linalg.inv(X.T@X)@X.T
    loocv_resid=model.resid/(1-np.diag(hat_matriz))
    loocv_rmse=np.sqrt(np.mean(loocv_resid**2))
    return loocv_rmse