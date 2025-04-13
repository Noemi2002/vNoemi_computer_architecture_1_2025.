# 🖼️ Proyecto de Interpolación Lineal para Imágenes

Proyecto que implementa interpolación bilineal a una imagen 400x400 en escala de grises empleando python y ensamblador.

## 📋 Requisitos

- Python 3.12+  
- NASM (Netwide Assembler)  
- Paquetes de Python:
  - Pillow (`python3-pil`, `python3-pil.imagetk`)
  - NumPy (`python3-numpy`)

## 🚀 Instalación

```bash
# Clonar el repositorio
git clone https://github.com/Noemi2002/vNoemi_computer_architecture_1_2025.

# Compilar el algoritmo en ensamblador
cd ensamblador/algo
nasm -felf64 -o algoritmo.o algoritmo.asm
ld -o algoritmo algoritmo.o
cd ../..

# Instalar dependencias de Python
sudo apt update
sudo apt install python3-pil python3-pil.imagetk
sudo apt install python3-numpy
```

## 🖥️ Uso

```bash
python3 interfaz.py
```

## ✍️ Autor

- **Nombre**: Noemí Vargas Soto 
- **Contacto**: noemivargas2902@gmail.com
