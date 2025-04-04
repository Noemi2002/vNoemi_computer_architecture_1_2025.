import tkinter as tk
from PIL import Image, ImageTk

class RobotControlApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Control del Robot Seguidor de Línea")
        self.root.configure(bg="black")  # Fondo negro para la ventana

        # Cargar la imagen del robot usando Pillow
        self.robot_image = Image.open("imagenes/Girasol.png")
        self.robot_photo = ImageTk.PhotoImage(self.robot_image)
        self.robot_label = tk.Label(root, image=self.robot_photo, bg="black")
        self.robot_label.grid(row=0, column=0, columnspan=4, pady=10)

        # Estilo de los botones
        button_style = {"width": 10, "height": 2, "bg": "red", "fg": "white", "font": ("Helvetica", 12, "bold")}

        # Botón de inicio
        self.start_button = tk.Button(root, text="START", command=self.start_robot, **button_style)
        self.start_button.grid(row=1, column=0, padx=10, pady=10)

        # Botones de control de velocidad
        self.speed_up_button = tk.Button(root, text="SPEED +", command=self.increase_speed, **button_style)
        self.speed_up_button.grid(row=1, column=1, padx=10, pady=10)

        self.speed_down_button = tk.Button(root, text="SPEED -", command=self.decrease_speed, **button_style)
        self.speed_down_button.grid(row=1, column=2, padx=10, pady=10)

        # Botón de paro
        self.stop_button = tk.Button(root, text="STOP", command=self.stop_robot, **button_style)
        self.stop_button.grid(row=1, column=3, padx=10, pady=10)

        # Etiqueta para mostrar la velocidad actual
        self.speed_label = tk.Label(root, text="Velocidad: 0", bg="black", fg="white", font=("Helvetica", 14, "bold"))
        self.speed_label.grid(row=2, column=0, columnspan=4, pady=10)

        # Botón de bifurcación
        self.bifurcation_button = tk.Button(root, text="Bifurcación", command=self.toggle_bifurcation, **button_style)
        self.bifurcation_button.grid(row=3, column=1, columnspan=2, padx=10, pady=10)

        # Variables para almacenar los botones de dirección
        self.left_button = None
        self.right_button = None

        self.speed = 0
        self.is_running = False  # Variable para controlar si el robot está en marcha

    def start_robot(self):
        self.is_running = True  # El robot está en marcha
        print("Robot iniciado")
        self.animate_button(self.start_button)

    def stop_robot(self):
        self.is_running = False  # El robot se detiene
        print("Robot parado")
        self.animate_button(self.stop_button)

    def increase_speed(self):
        if self.is_running:  # Solo aumentar velocidad si el robot está en marcha
            if self.speed < 100:
                self.speed += 10
                self.update_speed_label()
            print(f"Velocidad aumentada a {self.speed}")
            self.animate_button(self.speed_up_button)
        else:
            print("No se puede aumentar la velocidad, el robot no está en marcha")

    def decrease_speed(self):
        if self.is_running:  # Solo disminuir velocidad si el robot está en marcha
            if self.speed > 0:
                self.speed -= 10
                self.update_speed_label()
            print(f"Velocidad disminuida a {self.speed}")
            self.animate_button(self.speed_down_button)
        else:
            print("No se puede disminuir la velocidad, el robot no está en marcha")

    def toggle_bifurcation(self):
        # Verificar si ya se han creado los botones de dirección
        if not self.left_button and not self.right_button:
            # Crear los botones de dirección debajo del botón de bifurcación
            button_style = {"width": 10, "height": 2, "bg": "red", "fg": "white", "font": ("Helvetica", 12, "bold")}
            self.left_button = tk.Button(self.root, text="Izquierda", command=lambda: self.bifurcate("Izquierda"), **button_style)
            self.left_button.grid(row=4, column=1, padx=10, pady=10)

            self.right_button = tk.Button(self.root, text="Derecha", command=lambda: self.bifurcate("Derecha"), **button_style)
            self.right_button.grid(row=4, column=2, padx=10, pady=10)
        else:
            # Si los botones ya están creados, ocultarlos o mostrarlos según su estado
            if self.left_button.winfo_viewable():
                self.left_button.grid_remove()
                self.right_button.grid_remove()
            else:
                self.left_button.grid()
                self.right_button.grid()

    def bifurcate(self, direction):
        print(f"Robot se desvía a la {direction}")
        self.animate_button(self.left_button if direction == "Izquierda" else self.right_button)
        # Aquí podrías añadir lógica para mover el robot en la dirección seleccionada

    def update_speed_label(self):
        self.speed_label.config(text=f"Velocidad: {self.speed}")

    def animate_button(self, button):
        original_color = button.cget("background")
        button.config(background="yellow")
        self.root.after(100, lambda: button.config(background=original_color))

if __name__ == "__main__":
    root = tk.Tk()
    app = RobotControlApp(root)
    root.mainloop()