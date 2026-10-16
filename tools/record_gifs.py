"""Record the README GIFs from the two offline viewers.

    pip install websocket-client pillow
    python3 tools/record_gifs.py

Needs Google Chrome (or Chromium) and ffmpeg. Drives each viewer frame by frame
through the Chrome DevTools protocol, so every frame is exact, then encodes
test-rig-v3/media/strike.gif and concepts/six_solenoid_head/media/emboss.gif.
"""
import base64, io, json, shutil, socket, subprocess, tempfile, time, urllib.request
from pathlib import Path

import websocket
from PIL import Image

ROOT = Path(__file__).resolve().parent.parent
WIDTH = 880


class Chrome:
    def __init__(self):
        exe = shutil.which("google-chrome") or shutil.which("chromium") or shutil.which("chromium-browser")
        with socket.socket() as s:
            s.bind(("127.0.0.1", 0))
            self.port = s.getsockname()[1]
        self.profile = tempfile.mkdtemp()
        self.proc = subprocess.Popen(
            [exe, "--headless=new", f"--remote-debugging-port={self.port}", f"--user-data-dir={self.profile}",
             "--use-angle=swiftshader", "--enable-unsafe-swiftshader", "--hide-scrollbars",
             "--window-size=1280,1100", "about:blank"],
            stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        for _ in range(100):
            try:
                pages = json.load(urllib.request.urlopen(f"http://127.0.0.1:{self.port}/json"))
                ws = next(p["webSocketDebuggerUrl"] for p in pages if p["type"] == "page")
                break
            except Exception:
                time.sleep(0.1)
        self.ws = websocket.create_connection(ws, max_size=None, suppress_origin=True)
        self.n = 0
        self.send("Emulation.setDeviceMetricsOverride", width=1280, height=1100, deviceScaleFactor=1, mobile=False)

    def send(self, method, **params):
        self.n += 1
        self.ws.send(json.dumps({"id": self.n, "method": method, "params": params}))
        while True:
            msg = json.loads(self.ws.recv())
            if msg.get("id") == self.n:
                if "error" in msg:
                    raise RuntimeError(msg["error"])
                return msg.get("result", {})

    def eval(self, expr):
        r = self.send("Runtime.evaluate", expression=expr, awaitPromise=True, returnByValue=True)
        return r.get("result", {}).get("value")

    def open(self, path):
        self.send("Page.navigate", url=path.as_uri())
        for _ in range(300):
            if self.eval("(document.getElementById('loadState') || {}).textContent || ''").startswith("Drag"):
                break
            time.sleep(0.1)
        time.sleep(1.5)   # let the orbit controls settle

    def settle(self):
        self.eval("new Promise(r => requestAnimationFrame(() => requestAnimationFrame(r)))")

    def shot(self, selector):
        r = self.eval(f"(() => {{ const b = document.querySelector('{selector}').getBoundingClientRect();"
                      " return [b.x, b.y, b.width, b.height]; })()")
        clip = dict(x=r[0], y=r[1], width=r[2], height=r[3], scale=1)
        data = self.send("Page.captureScreenshot", format="png", clip=clip)["data"]
        return Image.open(io.BytesIO(base64.b64decode(data))).convert("RGB")

    def close(self):
        self.ws.close()
        self.proc.terminate()
        shutil.rmtree(self.profile, ignore_errors=True)


def side_by_side(left, right):
    h = max(left.height, right.height)
    right = right.resize((round(right.width * h / right.height), h), Image.LANCZOS) if right.height != h else right
    left = left.resize((round(left.width * h / left.height), h), Image.LANCZOS) if left.height != h else left
    out = Image.new("RGB", (left.width + right.width + 8, h), (242, 244, 246))
    out.paste(left, (0, 0))
    out.paste(right, (left.width + 8, 0))
    return out


def encode(frames, out, fps):
    out.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory() as tmp:
        for i, f in enumerate(frames):
            f.save(f"{tmp}/f{i:04d}.png")
        subprocess.run(
            ["ffmpeg", "-y", "-loglevel", "error", "-framerate", str(fps), "-i", f"{tmp}/f%04d.png",
             "-vf", f"scale={WIDTH}:-1:flags=lanczos,split[a][b];[a]palettegen=max_colors=128:stats_mode=diff[p];"
                    "[b][p]paletteuse=dither=bayer:bayer_scale=4:diff_mode=rectangle",
             "-loop", "0", str(out)], check=True)
    print(f"{out.relative_to(ROOT)}: {len(frames)} frames, {out.stat().st_size / 1e6:.1f} MB")


def rig(c):
    c.open(ROOT / "test-rig-v3/viewer/index.html")
    c.eval("document.getElementById('play').textContent === 'Pause' && document.getElementById('play').click()")
    frames = []
    for i in range(40):   # one strike, 3.2 s
        c.eval(f"const s = document.getElementById('scrub'); s.value = {i * 25}; s.dispatchEvent(new Event('input'))")
        c.settle()
        frames.append(side_by_side(c.shot("#viewer"), c.shot("#xsec")))
    encode(frames, ROOT / "test-rig-v3/media/strike.gif", 12.5)


def six(c, fps=10):
    c.open(ROOT / "concepts/six_solenoid_head/viewer/index.html")
    c.eval("document.getElementById('word').value = 'punch'; sixCapture.restart(); sixCapture.pause()")
    frames = []
    for _ in range(int(7.4 * fps)):   # five cells, then a short hold on the finished word
        c.eval(f"sixCapture.step({1 / fps})")
        c.settle()
        frames.append(side_by_side(c.shot(".viewer"), c.shot(".side")))
    encode(frames, ROOT / "concepts/six_solenoid_head/media/emboss.gif", fps)


if __name__ == "__main__":
    c = Chrome()
    try:
        rig(c)
        six(c)
    finally:
        c.close()
