#!/usr/bin/python3

import matplotlib.pyplot as plt
import numpy as np

import audio
import effects


def plot_io(xn: list, yn: list, fs: float, n: int = -1):
  f, ((ax1, ax2), (ax3, ax4)) = plt.subplots(2, 2, sharex='col', sharey='row')

  xn_l = xn if n < 1 else xn[0:n]
  yn_l = yn if n < 1 else yn[0:n]

  Xn = np.fft.fft(xn_l)
  Yn = np.fft.fft(yn_l)

  N  = len(Xn)
  k  = np.arange(0, N, dtype=np.float32)
  fa = fs * k / N

  ax1.plot(k, xn_l)
  ax2.plot(k, yn_l)
  ax3.plot(fa, np.abs(Xn))
  ax4.plot(fa, np.abs(Yn))
  plt.show()


if __name__ == '__main__':
  fs = 44100

  xn = audio.sinusoid(amp=10, freq=17000, phs=0, fs=fs, duration=1)

  #yn = effects.soft_clip(xn, k=8, gain=8)
  yn = effects.wah(xn)
  #yn = effects.tremolo(yn)
  #yn = effects.asym_clip(yn, high=1, low=-0.5, gain=2)
  #yn = effects.triangular(yn, gain=1)

  #plot_io(xn, yn, fs)#, n=10000)

  #audio.play(xn, fs)
  #audio.play(yn, fs)
