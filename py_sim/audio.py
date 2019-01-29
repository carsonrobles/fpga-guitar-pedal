import pyaudio

import effects


def sinusoid(amp: float, freq: float, phs: float, fs: float, duration: float) -> list:
  return amp*np.sin(2*np.pi*np.arange(fs*duration)*(freq/fs)+phs).astype(np.float32)


def play(xn: list, fs: float):
  p = pyaudio.PyAudio()

  stream = p.open(format=pyaudio.paFloat32, channels=2, rate=fs, output=True)

  stream.write(xn.tobytes())
  stream.stop_stream()

  stream.close()

  p.terminate()

