from PIL import Image
import numpy as np

# Configuración
width, height = 100, 100  # Dimensiones de la imagen
input_file = 'pixeles_cuadrante.txt'  # Nombre de tu archivo de entrada
output_image = 'cuadrante.png'  # Nombre de la imagen de salida


def leer_pixeles(archivo):
    with open(archivo, 'r') as f:
        contenido = f.read()

    # Dividir todos los valores RGB
    valores = contenido.replace('\n', ' ').split()

    # Procesar cada grupo RGB
    pixeles = []
    for valor in valores:
        r, g, b = map(int, valor.split(','))
        pixeles.append((r, g, b))

    return pixeles


# Leer los píxeles del archivo
pixeles = leer_pixeles(input_file)

# Verificar que tenemos suficientes píxeles
if len(pixeles) != width * height:
    print(f"Error: Se esperaban {width * height} píxeles, pero se encontraron {len(pixeles)}")
else:
    # Crear una nueva imagen
    imagen = Image.new('RGB', (width, height))

    # Convertir la lista de píxeles a un array de numpy para mejor manipulación
    array_pixeles = np.array(pixeles).reshape(height, width, 3)

    # Crear la imagen desde el array
    imagen = Image.fromarray(array_pixeles.astype('uint8'), 'RGB')

    # Guardar la imagen
    imagen.save(output_image)
    print(f"Imagen guardada como {output_image}")

    # Mostrar la imagen (opcional)
    imagen.show()