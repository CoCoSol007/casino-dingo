import os
from PIL import Image

ratio = float(input("Ratio ?"))

files = os.listdir()
for f in files:
    if f.endswith(".png"):
        print(f"Processing {f}...")
        old = Image.open(f)
        new = old.resize((round(old.size[0]/ratio), round(old.size[1]/ratio)))
        new.save(f)

print("Done ! ")
