import tkinter as tk
from tkinter import ttk
from PIL import Image, ImageTk

class App(tk.Frame):
    def __init__(self, master):

        # Aspectos generales de la interfaz
        self.master = master
        self.master.geometry("800x600+560+240")
        self.master.title("Proyecto 1 de Arquitectura de Computadores 1")
        self.master.configure(background='#f5c4e6'),

        self.crear_widgets()

    def crear_widgets(self):

        # Etiqueta de título
        self.mensaje = ttk.Label(self.master, text="Selecciona un cuadrante de la imagen", font=('Times', 24, "bold"), anchor = "center")
        self.mensaje.configure(background='#f5c4e6')
        self.mensaje.pack(pady=20)

        # Imagen
        ruta = "floresGrises_400x400.png"
        imagen_original = Image.open(ruta)
        imagen_redimensionada = imagen_original.resize((300, 300))  # Ajusta tamaño si quieres
        self.imagen_tk = ImageTk.PhotoImage(imagen_redimensionada)

        self.etiqueta_imagen = ttk.Label(self.master, image=self.imagen_tk)
        self.etiqueta_imagen.pack(pady=10)


if __name__ == "__main__":
    root = tk.Tk()
    myapp = App(root)
    root.mainloop()