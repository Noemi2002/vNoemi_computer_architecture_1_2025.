import tkinter as tk
from tkinter import ttk
from PIL import Image, ImageTk


class App(tk.Frame):
    def __init__(self, master):

        # Aspectos generales de la interfaz
        self.master = master
        self.master.geometry("800x600+560+240")
        self.master.title("Proyecto 1 de Arquitectura de Computadores 1")
        self.master.configure(background='#f5c4e6')

        self.crear_widgets()

    def crear_widgets(self):

        # Etiqueta para el mensaje inicial
        self.mensaje = ttk.Label(self.master, text="Selecciona un cuadrante de la imagen",
                                 font=('Times', 24, "bold"), anchor="center")
        self.mensaje.configure(background='#f5c4e6')
        self.mensaje.pack(pady=20)

        # Frame para la imagen
        self.image_frame = tk.Frame(self.master)
        self.image_frame.pack()

        # Cargar imagen
        ruta = "imagenes/floresGrises_400x400.png"
        imagen_original = Image.open(ruta)
        self.imagen_redimensionada = imagen_original.resize((400, 400))
        self.imagen_tk = ImageTk.PhotoImage(self.imagen_redimensionada)

        # Canvas para imagen
        self.canvas = tk.Canvas(self.image_frame, width=400, height=400)
        self.canvas.pack()
        self.canvas.create_image(0, 0, anchor=tk.NW, image=self.imagen_tk)

        # Dibujar rejilla
        self.dibujar_rejilla()

        # Para seleccionar el cuadrante

        # Cambiar cursor al pasar sobre la imagen
        self.canvas.bind("<Enter>", lambda e: self.canvas.config(cursor="hand2"))
        self.canvas.bind("<Leave>", lambda e: self.canvas.config(cursor=""))

        # Capturar clics sobre la imagen
        self.canvas.bind("<Button-1>", self.obtener_cuadrante_por_pixel)

        # Etiqueta para mostrar selección
        self.seleccion_label = ttk.Label(self.master, text="Cuadrante seleccionado: Ninguno",
                                         font=('Times', 16), anchor="center")
        self.seleccion_label.configure(background='#f5c4e6')
        self.seleccion_label.pack(pady=20)

    def dibujar_rejilla(self):

        # Rejilla 4x4 → cada cuadrante es de 100x100 px
        quadrant_size = 100
        for i in range(1, 4):

            # Líneas verticales
            self.canvas.create_line(i * quadrant_size, 0,
                                    i * quadrant_size, 400,
                                    fill="red", width=2)

            # Líneas horizontales
            self.canvas.create_line(0, i * quadrant_size,
                                    400, i * quadrant_size,
                                    fill="red", width=2)

    def obtener_cuadrante_por_pixel(self, event):
        x, y = event.x, event.y
        if 0 <= x < 400 and 0 <= y < 400:
            col = x // 100
            row = y // 100
            cuadrante = row * 4 + col + 1
            self.seleccion_label.config(text=f"Cuadrante seleccionado: {cuadrante}")
            print(f"Seleccionaste el cuadrante: {cuadrante}")

            # Coordenadas del cuadrante
            x1 = col * 100
            y1 = row * 100
            x2 = x1 + 100
            y2 = y1 + 100
            cuadrante_img = self.imagen_redimensionada.crop((x1, y1, x2, y2))

            # Obtener los valores de píxeles
            pixeles = list(cuadrante_img.getdata())  # Lista de (R, G, B)

            # Convertir a texto separado por espacios
            pixeles_texto = ' '.join(f"{r},{g},{b}" for (r, g, b) in pixeles)

            # Guardar en archivo .txt
            with open("pixeles_cuadrante.txt", "w") as f:
                f.write(f"Cuadrante: {cuadrante}\n")
                f.write("Pixeles (R,G,B) separados por espacios:\n")
                f.write(pixeles_texto)

            print("Pixeles guardados en 'pixeles_cuadrante.txt'")
        else:
            self.seleccion_label.config(text="Cuadrante seleccionado: Ninguno")


if __name__ == "__main__":
    root = tk.Tk()
    myapp = App(root)
    root.mainloop()
