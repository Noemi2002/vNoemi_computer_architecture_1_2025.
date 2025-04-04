import tkinter as tk

class App(tk.Frame):
    def __init__(self, master):
        super().__init__(master)
        self.pack()


        # Aspectos generales de la interfaz
        self.master.geometry("800x600+560+240")
        self.master.title("Proyecto 1 de Arquitectura de Computadores 1")

        # Etiqueta

        # Este Label ahora sí debería moverse
        mensaje = tk.Label(self, text="Selecciona un cuadrante de la imagen", font=('Times', 24, "bold"))
        mensaje.pack(side="bottom", pady=20)


font=('Times', 24)


root = tk.Tk()
myapp = App(root)
myapp.mainloop()