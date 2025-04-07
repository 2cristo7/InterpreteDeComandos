# 🧮 Intérprete de expresiones matemáticas

Este proyecto es un **intérprete interactivo** de expresiones matemáticas escrito en **C** usando **Flex** y **Bison**. Permite calcular expresiones, declarar variables, usar funciones matemáticas, constantes y ejecutar comandos especiales como en un mini lenguaje de consola.

---

## ⚙️ Requisitos

Asegúrate de tener instalado lo siguiente:

- `flex`
- `bison`
- `gcc` o cualquier compilador de C
- Sistema compatible con comandos como `clear` (Linux/macOS)

Instalación rápida en Ubuntu/Debian:

```bash
sudo apt install flex bison build-essential
```

---

## 🛠️ Compilación

Desde la carpeta del proyecto, ejecuta:

```bash
make
```

Esto generará el ejecutable `interpreter`.

Para limpiar archivos intermedios:

```bash
make clean
```

---

## 🚀 Ejecución

Lanza el intérprete con:

```bash
./interpreter
```

Verás el prompt interactivo:

```
> 
```

Desde ahí puedes escribir expresiones y comandos. Por ejemplo:

```bash
> a = 3
3.000000
> b = 5
5.000000
> a + b
8.000000
```

---

## 🧠 Funcionalidades soportadas

- **Variables**: `x = 4`, `x + 2`
- **Constantes**: `PI`, `E`
- **Operadores**: `+`, `-`, `*`, `/`, `^` (potencia)
- **Paréntesis**: `(2 + 3) * 4`
- **Notación científica**: `1e3`, `-2.5e-2`
- **Funciones**:
  - `sin()`, `cos()`, `tan()`
  - `log()`, `exp()`
  - `min(x, y)`, `max(x, y)`
- **Comandos**:
  - `CLEAR()` → Borra todas las variables
  - `WORKSPACE()` → Muestra variables definidas
  - `HELP()` → Muestra ayuda con todos los comandos
  - `QUIT()` → Sale del intérprete
  - `ECHO ON` / `ECHO OFF` → Activa o desactiva impresión automática
  - `;` → Suprime impresión en una sola línea
  - `CLEAN()` → Limpia pantalla
  - `LOAD("archivo.txt")` → Ejecuta comandos desde un archivo
  - `echo "mensaje"` → Imprime mensajes personalizados

---

## 📂 Ejecución desde archivo

Puedes crear un archivo llamado `comandos.txt` con contenido como:

```txt
echo "=== Prueba ==="
a = 5;
b = 10;
a + b
```

Y luego ejecutarlo desde el intérprete con:

```bash
> LOAD("comandos.txt")
```

---

## ❌ Errores controlados

- División por cero → error y resultado 0
- Variables no declaradas → mensaje personalizado
- Constantes (`PI`, `E`) no se pueden modificar
- Comandos mal formateados → `Error: Entrada no válida`

---

## 🏁 Salir del programa

Usa:

```bash
> QUIT()
```

para cerrar el intérprete.

---

## 👨‍💻 Autor

- Desarrollado como práctica de la asignatura **Compiladores e Intérpretes**
- Implementado en C con diseño modular y tabla hash para la gestión de símbolos
