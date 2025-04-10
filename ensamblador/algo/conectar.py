import subprocess

# Run the x86 program
subprocess.run(["./algoritmo"])

# Optionally read the generated output
with open("output.bin", "rb") as f:
    data = f.read()
    print("Output contents (hex):", data.hex())