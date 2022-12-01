import pandas as pd
datase = pd.read_csv('C:\\Users\\KALYAN\\Downloads\\pv.txt', header=0, low_memory=False, infer_datetime_format=True, parse_dates={'datetime':[0]}, index_col=['datetime'])
from numpy import nan
from numpy import isnan
from pandas import read_csv
from pandas import to_numeric

def fill_missing(values):
    one_da = 60 * 24
    for ro in range(values.shape[0]):
        for colu in range(values.shape[1]):
            if isnan(values[ro, colu]):
                values[ro, colu] = values[ro - one_da, colu]


datase = read_csv('C:\\Users\\KALYAN\\Downloads\\pv.txt', header=0, low_memory=False, infer_datetime_format=True,
                  parse_dates={'datetime': [0]}, index_col=['datetime'])
datase.replace('?', nan, inplace=True)
datase = datase.astype('float32')
fill_missing(datase.values)
values = datase.values
datase.to_csv('pv.csv')
from pandas import read_csv
datase = read_csv('pv.csv', header=0, infer_datetime_format=True, parse_dates=['datetime'], index_col=['datetime'])
daily_group = datase.resample('D')
daily_dat = daily_group.sum()
print(daily_dat.shape)
print(daily_dat.head())
daily_dat.to_csv('pvr.csv')

from math import sqrt
from numpy import split
from numpy import array
from pandas import read_csv
from sklearn.metrics import mean_squared_error
from sklearn.metrics import mean_absolute_error
from matplotlib import pyplot
from keras.models import Sequential
from keras.layers import Dense
from keras.layers import Flatten
from keras.layers import LSTM
from keras.layers import RepeatVector
from keras.layers import TimeDistributed

def split_datase(data):
    trainx, testy = data[1:-328], data[-328:-6]
    trainx = array(split(trainx, len(trainx) / 7))
    testy = array(split(testy, len(testy) / 7))
    return trainx, testy
def evaluate_forecast(actua, predicte):
    score = list()
    for i in range (actua.shape[1]):
        mae = mean_absolute_error(actua[:, i], predicte[:, i])
        rmse = sqrt(mae)
        score.append(rmse)
    ss = 0
    for ro in range(actua.shape[0]):
        for colu in range(actua.shape[1]):
            ss += (actua[ro, colu] - predicte[ro, colu]) ** 2
    scores = sqrt(ss / (actua.shape[0] * actua.shape[1]))
    print('mae=', mae)
    return scores, score

    pyplot.plot(datase)
    pyplot.show()

def summarize_score(name, scores, score):
    ss_scores = ', '.join(['%.1f' % s for s in score])
    print('%s: [%.2f] %s' % (name, scores, ss_scores))

def too_supervised(trainx, N_input, N_out=7):
    data = trainx.reshape((trainx.shape[0] * trainx.shape[1], trainx.shape[2]))
    x, y = list(), list()
    i_start = 0
    for _ in range(len(data)):
        i_end = i_start + N_input
        o_end = i_end + N_out
        if o_end <= len(data):
            x.append(data[i_start:i_end, :])
            y.append(data[i_end:o_end, 0])
        i_start += 1
    return array(x), array(y)

def build_model(trainx, N_input):
    trainx_x, trainy_y = too_supervised(trainx, N_input)
    verbose, epochs, batch_size = 0, 25, 16
    N_timesteps, N_features, N_outputs = trainx_x.shape[1], trainx_x.shape[2], trainy_y.shape[1]
    trainy_y = trainy_y.reshape((trainy_y.shape[0], trainy_y.shape[1], 1))

    model = Sequential()
    model.add(LSTM(150, activation='relu', input_shape=(N_timesteps, N_features)))
    model.add(RepeatVector(N_outputs))
    model.add(LSTM(150, activation='relu', return_sequences=True))
    model.add(TimeDistributed(Dense(50, activation='relu')))
    model.add(TimeDistributed(Dense(1)))
    model.compile(loss='mae', optimizer='adam')
    model.fit(trainx_x, trainy_y, epochs=epochs, batch_size=batch_size, verbose=verbose)
    print(model.summary())
    return model

def forecas(model, histor, N_input):
    data = array(histor)
    data = data.reshape((data.shape[0] * data.shape[1], data.shape[2]))
    i_x = data[-N_input:, :]
    i_x = i_x.reshape((1, i_x.shape[0], i_x.shape[1]))
    yhat = model.predict(i_x, verbose=0)
    yhat = yhat[0]
    return yhat

def evaluat_model(trainx, testy, N_input):
    model = build_model(trainx, N_input)
    histor = [x for x in trainx]
    prediction = list()
    for i in range(len(testy)):
        yhat_sequence = forecas(model, histor, N_input)
        prediction.append(yhat_sequence)
        histor.append(testy[i, :])

    prediction = array(prediction)
    scores, score = evaluate_forecast(testy[:, :, 0], prediction)
    return scores, score

datase = read_csv('pvr.csv', header=0, infer_datetime_format=True, parse_dates=['datetime'], index_col=['datetime'])
trainx, testy = split_datase(datase.values)
N_input =14
scores, score = evaluat_model(trainx, testy, N_input)
summarize_score('lstm', scores, score)
days = ['one', 'two', 'three', 'four', 'five', 'six', 'seven']
pyplot.plot(days, score, marker='o', label='lstm')
pyplot.show()
