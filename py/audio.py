import pyaudio

import effects


def play(xn: list, fs: float):
  p = pyaudio.PyAudio()

  stream = p.open(format=pyaudio.paFloat32, channels=2, rate=fs, output=True)

  stream.write(xn.tobytes())
  stream.stop_stream()

  stream.close()

  p.terminate()

