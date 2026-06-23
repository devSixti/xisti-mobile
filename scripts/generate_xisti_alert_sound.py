#!/usr/bin/env python3
"""Synthesize the XISTI ride-request alert (distinct from the legacy ZIMO tone).

Outputs:
  - assets/audio/new_request.mp3          (in-app AudioPlayer)
  - android/app/src/main/res/raw/new_request.mp3
  - ios/Runner/new_request.wav            (APNs / local notifications)
"""

from __future__ import annotations

import math
import subprocess
import wave
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parents[1]
SAMPLE_RATE = 44100
WAV_TMP = ROOT / "scripts/.xisti_alert_build.wav"
OUT_MP3_ASSET = ROOT / "assets/audio/new_request.mp3"
OUT_MP3_RAW = ROOT / "android/app/src/main/res/raw/new_request.mp3"
OUT_WAV_IOS = ROOT / "ios/Runner/new_request.wav"

# Ascending three-note motif (G5 → B5 → E6) — energetic, not a phone ring.
NOTES = [
    (783.99, 0.16, 0.55),  # G5
    (987.77, 0.16, 0.60),  # B5
    (1318.51, 0.34, 0.70),  # E6
]
GAP_S = 0.045


def _envelope(length: int, attack: int, release: int) -> np.ndarray:
    env = np.ones(length, dtype=np.float64)
    if attack > 0:
        env[:attack] = np.linspace(0.0, 1.0, attack, endpoint=False)
    if release > 0:
        env[-release:] = np.linspace(1.0, 0.0, release, endpoint=True)
    return env


def _tone(freq: float, duration_s: float, gain: float) -> np.ndarray:
    n = int(SAMPLE_RATE * duration_s)
    t = np.linspace(0.0, duration_s, n, endpoint=False)
    # Bright but smooth: fundamental + soft 2nd harmonic + tiny 3rd.
    signal = (
        0.78 * np.sin(2 * math.pi * freq * t)
        + 0.18 * np.sin(2 * math.pi * freq * 2 * t)
        + 0.06 * np.sin(2 * math.pi * freq * 3 * t)
    )
    attack = int(SAMPLE_RATE * 0.008)
    release = int(SAMPLE_RATE * 0.05)
    return signal * _envelope(n, attack, release) * gain


def synthesize_stereo() -> np.ndarray:
  chunks: list[np.ndarray] = []
  silence = np.zeros(int(SAMPLE_RATE * GAP_S), dtype=np.float64)

  for idx, (freq, duration_s, gain) in enumerate(NOTES):
    mono = _tone(freq, duration_s, gain)
    # Last note gets a gentle vibrato tail for memorability.
    if idx == len(NOTES) - 1:
      tail_t = np.linspace(0.0, duration_s, mono.size, endpoint=False)
      mono *= 1.0 + 0.04 * np.sin(2 * math.pi * 5.5 * tail_t)

    left = mono
    right = np.roll(mono, int(SAMPLE_RATE * 0.0008))  # subtle stereo width
    stereo = np.column_stack([left, right])
    chunks.append(stereo)
    if idx < len(NOTES) - 1:
      gap = np.zeros((silence.size, 2), dtype=np.float64)
      chunks.append(gap)

  audio = np.concatenate(chunks, axis=0)
  # Short fade-out on the full clip.
  fade = int(SAMPLE_RATE * 0.08)
  audio[-fade:, :] *= np.linspace(1.0, 0.0, fade)[:, None]
  peak = np.max(np.abs(audio)) or 1.0
  return (audio / peak * 0.92).astype(np.float32)


def write_wav(path: Path, stereo: np.ndarray) -> None:
    pcm = np.clip(stereo, -1.0, 1.0)
    pcm_i16 = (pcm * 32767.0).astype(np.int16)
    path.parent.mkdir(parents=True, exist_ok=True)
    with wave.open(str(path), "wb") as wf:
        wf.setnchannels(2)
        wf.setsampwidth(2)
        wf.setframerate(SAMPLE_RATE)
        wf.writeframes(pcm_i16.tobytes())


def write_mp3(path: Path, wav_src: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    subprocess.run(
        [
            "ffmpeg",
            "-y",
            "-hide_banner",
            "-loglevel",
            "error",
            "-i",
            str(wav_src),
            "-codec:a",
            "libmp3lame",
            "-b:a",
            "128k",
            "-ar",
            "44100",
            str(path),
        ],
        check=True,
    )


def main() -> None:
    stereo = synthesize_stereo()
    write_wav(WAV_TMP, stereo)
    write_mp3(OUT_MP3_ASSET, WAV_TMP)
    write_mp3(OUT_MP3_RAW, WAV_TMP)
    write_wav(OUT_WAV_IOS, stereo)
    WAV_TMP.unlink(missing_ok=True)
    duration = stereo.shape[0] / SAMPLE_RATE
    print(f"✓ new_request alert ({duration:.2f}s)")
    print(f"  {OUT_MP3_ASSET}")
    print(f"  {OUT_MP3_RAW}")
    print(f"  {OUT_WAV_IOS}")


if __name__ == "__main__":
    main()
