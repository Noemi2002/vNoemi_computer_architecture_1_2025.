import tkinter as tk
from tkinter import ttk
from PIL import Image, ImageTk
import numpy as np

from g_submatrices import submatrices
from grafica_final import graficar_imagen_interpolada
from matriz_final import matriz_final
from p_automatizado import procesar_submatrices

# Variables globales
canvas = None
imagen_original = None
imagen_tk = None
seleccion_label = None
cuadrante_canvas = None
cuadrante_imagen_tk = None
imagen_interpolada_canvas = None
imagen_interpolada_tk = None
seleccion_button = None
cuadrante_resaltado = None


# Función del botón
def procedimiento_algoritmo():

    # Función que genera todas las submatrices posibles
    submatrices()

    # Función que procesa todas las matrices, las pasa por ensamblador y guarda todos los output.img resultantes
    procesar_submatrices()

    # Función que genera la matriz con los valores interpolados
    matriz_final()

    # Función que genera la imagen interpolada
    graficar_imagen_interpolada()

    # Muestra la imagen interpolada
    mostrar_imagen_interpolada()


# FUnción para graficar la rejilla que diferencia los 16 cuadrantes
def dibujar_rejilla():
    quadrant_size = 100
    for i in range(1, 4):
        canvas.create_line(i * quadrant_size, 0, i * quadrant_size, 400, fill="black", width=2)
        canvas.create_line(0, i * quadrant_size, 400, i * quadrant_size, fill="black", width=2)


def cargar_imagen_grises(archivo, ancho=100, alto=100):
    with open(archivo, 'r') as f:
        valores = [int(linea.strip()) for linea in f if linea.strip()]
    if len(valores) != ancho * alto:
        raise ValueError(f"Se esperaban {ancho * alto} valores, pero se encontraron {len(valores)}")
    matriz_grises = np.array(valores, dtype=np.uint8).reshape((alto, ancho))
    return Image.fromarray(matriz_grises, 'L')

# Función que identifica el cuadrante seleccionado
def obtener_cuadrante_por_pixel(event):
    global imagen_original, seleccion_label, cuadrante_canvas, cuadrante_imagen_tk, cuadrante_resaltado

    x, y = event.x, event.y
    if 0 <= x < 400 and 0 <= y < 400:
        col = x // 100
        row = y // 100
        cuadrante = row * 4 + col + 1
        #seleccion_button.config(text=f"Generar interpolación")
        print(f"Seleccionaste el cuadrante: {cuadrante}")

# Poner color diferente al cuadrante seleccionado
        # Eliminar rectángulo anterior si existe
        if cuadrante_resaltado is not None:
            canvas.delete(cuadrante_resaltado)

        # Dibujar nuevo rectángulo rosa fuerte (magenta)
        x1, y1 = col * 100, row * 100
        x2, y2 = x1 + 100, y1 + 100
        cuadrante_resaltado = canvas.create_rectangle(x1, y1, x2, y2, outline="#FF1493", width=4)

        # Guardar píxeles del cuadrante
        cuadrante_img = imagen_original.crop((x1, y1, x2, y2))
        pixeles = list(cuadrante_img.getdata())
        with open("pixeles_cuadrante.img", "w") as f:
            for (r, g, b) in pixeles:
                f.write(f"{r}\n") # Guardar solo el valor del pixel rojo

        print("Pixeles guardados en 'pixeles_cuadrante.img'") # Pixeles guardados con éxito
        mostrar_imagen_cuadrante() #Mostrar la imagen del cuadrante

# Funicón para mostrar el cuadrante en la interfaz
def mostrar_imagen_cuadrante():
    global cuadrante_canvas, cuadrante_imagen_tk
    try:
        imagen = cargar_imagen_grises('pixeles_cuadrante.img', 100, 100)
        imagen_tk_local = ImageTk.PhotoImage(imagen)
        cuadrante_canvas.config(width=100, height=100)
        cuadrante_canvas.delete("all")
        cuadrante_canvas.create_image(0, 0, anchor=tk.NW, image=imagen_tk_local)
        cuadrante_imagen_tk = imagen_tk_local
    except Exception as e:
        print(f"Error: {e}")

# Función para mostrar la imegen resultante interpolada
def mostrar_imagen_interpolada():
    global imagen_interpolada_canvas, imagen_interpolada_tk
    try:
        imagen = Image.open("imagen_interpolada.jpg")
        imagen_interpolada_tk = ImageTk.PhotoImage(imagen)
        imagen_interpolada_canvas.config(width=298, height=298)
        imagen_interpolada_canvas.delete("all")
        imagen_interpolada_canvas.create_image(0, 0, anchor=tk.NW, image=imagen_interpolada_tk)
    except Exception as e:
        print(f"Error al mostrar imagen interpolada: {e}")

# Función que genera la interfaz
def crear_interfaz(root):
    global canvas, imagen_original, imagen_tk, seleccion_label, cuadrante_canvas
    global imagen_interpolada_canvas, seleccion_button

    root.geometry("1200x600")
    root.title("Proyecto 1 de Arquitectura de Computadores 1")
    root.configure(background='#f5c4e6')

    main_frame = tk.Frame(root, bg='#f5c4e6')
    main_frame.pack(fill=tk.BOTH, expand=True)

    left_frame = tk.Frame(main_frame, bg='#f5c4e6')
    left_frame.pack(side=tk.LEFT, padx=20, pady=20, fill=tk.BOTH, expand=True)

    right_frame = tk.Frame(main_frame, bg='#f5c4e6')
    right_frame.pack(side=tk.LEFT, padx=20, pady=20, fill=tk.BOTH, expand=True)

    mensaje = ttk.Label(left_frame, text="Selecciona un cuadrante de la imagen", font=('Times', 24, "bold"), anchor="center")
    mensaje.configure(background='#f5c4e6')
    mensaje.pack(pady=20)

    image_frame = tk.Frame(left_frame)
    image_frame.pack()

    ruta = "imagenes/floresGrises_400x400.png"
    imagen_original = Image.open(ruta)
    imagen_original = imagen_original.resize((400, 400))
    imagen_tk = ImageTk.PhotoImage(imagen_original)

    canvas = tk.Canvas(image_frame, width=400, height=400)
    canvas.pack()
    canvas.create_image(0, 0, anchor=tk.NW, image=imagen_tk)

    dibujar_rejilla() # Poner rejilla

    # Mouse reconoce la imagen y cambia la forma
    canvas.bind("<Enter>", lambda e: canvas.config(cursor="hand2"))
    canvas.bind("<Leave>", lambda e: canvas.config(cursor=""))
    canvas.bind("<Button-1>", obtener_cuadrante_por_pixel)

    # Botón que genera la interpolación
    seleccion_button = ttk.Button(left_frame,
                                  text="Generar interpolación",
                                  command=procedimiento_algoritmo)

    seleccion_button.pack(pady=20)

    top_right_frame = tk.Frame(right_frame, bg='#f5c4e6')
    top_right_frame.pack(fill=tk.BOTH ,expand=True)

    bottom_right_frame = tk.Frame(right_frame, bg='#f5c4e6')
    bottom_right_frame.pack(fill=tk.BOTH, expand=True)

    label_img1 = ttk.Label(top_right_frame, text="Cuadrante seleccionado", font=('Times', 14, "bold"), anchor="center")
    label_img1.configure(background='#f5c4e6')
    label_img1.pack()

    cuadrante_canvas = tk.Canvas(top_right_frame, width=100, height=100)
    cuadrante_canvas.pack(pady=10)

    label_img2 = ttk.Label(bottom_right_frame, text="Imagen interpolada", font=('Times', 14, "bold"), anchor="center")
    label_img2.configure(background='#f5c4e6')
    label_img2.pack()

    imagen_interpolada_canvas = tk.Canvas(bottom_right_frame, width=298, height=298)
    imagen_interpolada_canvas.pack(pady=10)

# Ejecutar la aplicación
if __name__ == "__main__":
    root = tk.Tk()
    crear_interfaz(root)
    root.mainloop()
