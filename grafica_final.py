import numpy as np
from PIL import Image

def cargar_matriz_reconstruida(archivo):
    return np.loadtxt(archivo, dtype=np.uint8)

def guardar_imagen_grises(matriz, nombre_archivo):
    imagen = Image.fromarray(matriz, mode='L')  # 'L' = escala de grises (8-bit)
    imagen.save(nombre_archivo)
    #imagen.show()  # Mostrar la imagen automáticamente

# Función principal
def graficar_imagen_interpolada():
    archivo_matriz = "matriz_reconstruida.img"
    archivo_imagen = "imagen_interpolada.jpg"

    # Cargar la matriz reconstruida
    matriz = cargar_matriz_reconstruida(archivo_matriz)

    # Guardar como imagen
    guardar_imagen_grises(matriz, archivo_imagen)
    print(f"Imagen guardada como {archivo_imagen}")

