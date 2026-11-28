"""Generate post photos with Runware: gen.py photos.json [ids...] -> photos/<id>.jpg"""
import json, os, sys, uuid, urllib.request, concurrent.futures as cf
KEY = os.environ["RunWare_API_Key"]
STYLE = ", soft natural daylight, warm tones, real skin texture with visible pores, minimal retouching, editorial photography, calm, high detail"
NEG = "text, letters, words, logo, watermark, brand name, label text, before and after, medical setting, syringe, needle, plastic skin, heavy retouch, teenager, child, deformed hands, extra fingers"
def call(tasks):
    req = urllib.request.Request("https://api.runware.ai/v1", data=json.dumps(tasks).encode(),
        headers={"Content-Type": "application/json", "Authorization": "Bearer " + KEY})
    with urllib.request.urlopen(req, timeout=300) as r: return json.load(r)
def one(pid, prompt, w, h):
    t = [{"taskType": "imageInference", "taskUUID": str(uuid.uuid4()), "model": "runware:101@1",
          "positivePrompt": prompt + STYLE, "negativePrompt": NEG, "width": w, "height": h,
          "numberResults": 1, "outputFormat": "JPG", "steps": 30, "CFGScale": 3.5}]
    r = call(t)
    if "errors" in r: return pid, "ERR " + json.dumps(r["errors"])[:300]
    url = r["data"][0]["imageURL"]
    urllib.request.urlretrieve(url, f"photos/{pid}.jpg")
    return pid, "ok"
spec = json.load(open(sys.argv[1]))
ids = sys.argv[2:] or list(spec)
with cf.ThreadPoolExecutor(4) as ex:
    for pid, st in ex.map(lambda k: one(k, spec[k]["p"], spec[k].get("w", 1088), spec[k].get("h", 1344)), ids):
        print(pid, st)
