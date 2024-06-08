from PIL import Image

ratio = 1.

while True:
    f = input("path ? ").replace("\"", "")

    if f.startswith("/"): ratio = float(f[1:])

    if f.endswith(".png"):
        print(f"Processing {f}...")
        old = Image.open(f)
        new = old.resize((round(old.size[0]/ratio), round(old.size[1]/ratio)))
        new.save(f)