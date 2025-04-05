from PIL import Image
import numpy as np


def cargar_imagen_grises(archivo, ancho=100, alto=100):
    # Leer todos los valores del archivo
    with open(archivo, 'r') as f:
        valores = [int(linea.strip()) for linea in f if linea.strip()]

    # Verificar cantidad de píxeles
    if len(valores) != ancho * alto:
        raise ValueError(f"Se esperaban {ancho * alto} valores, pero se encontraron {len(valores)}")

    # Convertir a array numpy y redimensionar
    matriz_grises = np.array(valores, dtype=np.uint8).reshape((alto, ancho))

    # Crear imagen (PIL automáticamente la interpreta como escala de grises)
    imagen = Image.fromarray(matriz_grises, 'L')

    return imagen


# Uso del código
try:
    # Configuración
    input_file = 'pixeles_cuadrante.txt'  # Archivo con valores de gris
    output_image = 'imagen_grises.png'  # Imagen de salida

    # Cargar y procesar imagen
    imagen = cargar_imagen_grises(input_file, 100, 100)

    # Guardar imagen
    imagen.save(output_image)
    print(f"Imagen en escala de grises guardada como {output_image}")

    # Mostrar imagen
    imagen.show()

except FileNotFoundError:
    print(f"Error: No se encontró el archivo {input_file}")
except ValueError as e:
    print(f"Error: {e}")
except Exception as e:
    print(f"Error inesperado: {e}")