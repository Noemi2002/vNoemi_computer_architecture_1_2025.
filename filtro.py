'''Librería para el manejo de la imagen
Para el manejo de la imagen y los pixeles de la misma se puede usar una libería
ya que esto se va a hacer de otra forma (ya conocida) en Cpulator
'''

# Debo cambiar la lista de los pixeles?

from PIL import Image
#from mult import multiplicar
#from div import division

def gray_filter(img_sepia):

    pixelList =[] # Variable para guardar los pixeles de la imagen en una list
    newPixelList = [] # Varaibles para guardar los pixeles con el filtro

    width, height = img_sepia.size # Obtiene el tamaño de la imagen
    pixels = img_sepia.load() # Crea un objeto de pixeles

    # Guardar los pixeles en una lista
    for y in range(height):
        for x in range(width):
            pixelList.append(pixels[x,y])


    # Aplicar el filtro
    for py in range(height):
        for px in range(width):
            r, g, b = img_sepia.getpixel((px, py)) # Cambiarlo para que sean los de la lista

            # Valores predefinidos para crear el filtro
            # Valores para el rojo
            g1 = 299
            g2 = 587
            g3 = 114

            # Operaciones para el filtro
            # Multiplicar
            # Para el rojo
            valor1 = (r * g1)
            valor2 = (g * g2)
            valor3 = (b * g3)

            # Dividir
            # Para el rojo
            valor1 /= 1000
            valor2 /= 1000
            valor3 /= 1000

            # Valor para los grises
            grayValue = int(valor1 + valor2 + valor3)



            # Asegurar que los valores no excedan 255
            if grayValue > 255:
                grayValue = 255


            # Guardar los nuevos pixeles en otra lista lista
            newPixelList.append((grayValue, grayValue, grayValue))


            # Edita lo pixeles originales
            pixels[px, py] = (grayValue, grayValue, grayValue)
    return img_sepia

img = Image.open("imagenes/flores_400x400.jpg") # Variable para guardar el path de la imagen
#img.show() # Muestra la imagen

gray_img = gray_filter(img) #Llamada a la función
#gray_img.show()
gray_img.save("floresGrises_400x400.png")