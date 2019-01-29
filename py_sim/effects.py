import numpy as np


def triangular(xn: list, exp: float = 3, gain: float = 1) -> list:
  yn = np.ndarray(len(xn)).astype(np.float32)

  for i in range(len(xn)):
    yn[i] = gain * (xn[i] + (xn[i]**exp)/3.0)

  return yn


def soft_clip(xn: list, k: float, gain: float = 1) -> list:
  yn = np.ndarray(len(xn)).astype(np.float32)

  for i in range(len(xn)):
    yn[i] = gain * (xn[i] / (1.0 + k*np.abs(xn[i])))

  return yn


def hard_clip(xn: list, threshold: float, gain: float = 1) -> list:
  yn = np.ndarray(len(xn)).astype(np.float32)

  for i in range(len(xn)):
    x = gain*xn[i]

    if x > threshold:
      yn[i] = threshold
    elif x < -1*threshold:
      yn[i] = -1*threshold
    else:
      yn[i] = x

  return yn


def asym_clip(xn: list, high: float, low: float, gain: float = 1) -> list:
  yn = np.ndarray(len(xn)).astype(np.float32)

  for i in range(len(xn)):
    x = gain*xn[i]


    if x > high:
      yn[i] = high
    elif x < low:
      yn[i] = low
    else:
      yn[i] = x

  return yn
