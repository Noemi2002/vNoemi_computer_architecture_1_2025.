import subprocess

# Run the x86 program
subprocess.run(["./ensamblador/algo/algoritmo"])

# Optionally read the generated output
with open("output.img", "rb") as f:
    data = f.read()
    print("Output contents (hex):", data.hex())