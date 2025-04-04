import numpy as np
import matplotlib.pyplot as plt

# Leer el archivo
with open('pixeles_cuadrante.txt', 'r') as f:
    lines = f.readlines()

# Convertir líneas en una matriz de enteros
matrix = [list(map(int, line.strip().split())) for line in lines]

# Convertir a arreglo de NumPy
image_array = np.array(matrix)

# Graficar la imagen
plt.imshow(image_array, cmap='gray', interpolation='nearest')
plt.title("Imagen desde archivo de texto")
plt.colorbar(label='Intensidad')
plt.show()
