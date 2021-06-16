import pandas as pd
import numpy as np
import re 
from sqlalchemy import create_engine
import matplotlib.pyplot as plt
import sklearn.linear_model
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_absolute_error

houses_data = pd.read_csv("../../brief_agile_houses_cali/housing.csv")
houses_data


