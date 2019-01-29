#!/usr/bin/python3

import matplotlib.pyplot as plt
import numpy as np

import audio
import effects


def plot_io(xn: list, yn: list, n: int = -1):
  f, ((ax1, ax2), (ax3, ax4)) = plt.subplots(2, 2, sharex='col', sharey='row')

  xn_l = xn if n < 1 else xn[0:n]
  yn_l = yn if n < 1 else yn[0:n]

  ax1.plot(xn_l)
  ax2.plot(yn_l)
  ax3.plot(np.abs(np.fft.fft(xn_l)))
  ax4.plot(np.abs(np.fft.fft(yn_l)))
  plt.show()


if __name__ == '__main__':
  fs = 44100

  xn = sinusoid(amp=1, freq=440, phs=0, fs=fs, duration=2)

  yn = effects.soft_clip(xn, k=8, gain=8)
  #yn = effects.hard_clip(yn, threshold=1, gain=4)
  #yn = effects.asym_clip(yn, high=1, low=-0.5, gain=2)
  #yn = effects.triangular(yn, gain=1)

  plot_io(xn, yn, n=300)

  audio.play(xn, fs)
  audio.play(yn, fs)
