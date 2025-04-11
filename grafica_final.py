import numpy as np
from PIL import Image

def cargar_matriz_reconstruida(archivo):
    """Carga la matriz reconstruida desde un archivo de texto."""
    return np.loadtxt(archivo, dtype=np.uint8)

def guardar_imagen_grises(matriz, nombre_archivo):
    """Convierte la matriz en una imagen y la guarda."""
    imagen = Image.fromarray(matriz, mode='L')  # 'L' = escala de grises (8-bit)
    imagen.save(nombre_archivo)
    imagen.show()  # Mostrar la imagen automáticamente

def graficar_imagen_interpolada():
    archivo_matriz = "matriz_reconstruida.img"  # Asegúrate de que los valores estén en 0-255
    archivo_imagen = "imagen_interpolada.jpg"

    # Cargar la matriz reconstruida (ej: 298x298 para interpolación 4x4 desde 100x100)
    matriz = cargar_matriz_reconstruida(archivo_matriz)

    # Guardar como imagen
    guardar_imagen_grises(matriz, archivo_imagen)
    print(f"Imagen guardada como {archivo_imagen}")

#graficar_imagen_interpolada()