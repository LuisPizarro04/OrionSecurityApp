# 🏗️ Orion Security App 🚧

> **Sistema de control de accesos y libro de novedades para el área de seguridad en construcción.**

Orion Security App es una aplicación móvil desarrollada en **Flutter** con un backend en **Django + DRF**. Su objetivo es gestionar accesos de personas y vehículos a una obra, además de permitir el registro de novedades y reportes de seguridad.

---

## 🚀 **Objetivos del Proyecto**
✅ Facilitar el control de acceso de trabajadores, visitantes y proveedores.  
✅ Registrar la entrada y salida de personas y vehículos.  
✅ Gestionar reportes de novedades diarias e incidentes en la obra.  
✅ Proveer un sistema eficiente para el equipo de seguridad en la construcción.

---

## 📌 **Alcance del Proyecto**
🔹 **Gestión de accesos:** Registro de personas y vehículos.  
🔹 **Libro de Novedades:** Reportes de seguridad, novedades diarias e incidentes.  
🔹 **Indicadores de control:** Visualización de cantidad de trabajadores y vehículos en la obra.  
🔹 **Menú lateral:** Acceso rápido a diferentes módulos.  
🔹 **Autenticación segura:** Login con almacenamiento de token.

---

## 🛠️ **Tecnologías Utilizadas**
### **Frontend (Aplicación Móvil)**
- **Flutter**  (Dart)
- **Provider** / **Riverpod** (para manejo de estado)
- **http** (para consumir APIs)
- **SharedPreferences** (para almacenamiento local)

### **Backend (API REST)**
- **Django** + **Django Rest Framework (DRF)**
- **Autenticación con Token**
- **PostgreSQL** (Base de datos)
- **NGINX / Gunicorn** (para despliegue)

---

## 📋 **Requisitos del Proyecto**
### **🖥️ Requisitos para ejecutar el Backend (Django)**
- **Python 3.9+**
- **Django 4+**
- **Django Rest Framework**
- **PostgreSQL** (o SQLite para pruebas)
- **CORS Headers** para permitir conexiones desde Flutter

📌 **Instalar dependencias en el backend:**
```bash
pip install -r requirements.txt
```


## 📌 **Estructura del Proyecto en Flutter**
```bash
lib/                        # Carpeta principal del código en Flutter
├── main.dart               # Punto de entrada de la aplicación
├── screens/                # Pantallas de la app
│   ├── home_screen.dart    # Página principal con indicadores
│   ├── dashboard_screen.dart  # Dashboard de accesos
│   ├── novedades_screen.dart  # Libro de novedades
│   ├── registro_personas_screen.dart  # Formulario de acceso de personas
│   ├── registro_vehiculos_screen.dart # Formulario de acceso de vehículos
│   ├── login_screen.dart   # Pantalla de inicio de sesión
│   └── ... Otras pantallas
├── models/                 # Modelos de datos
│   ├── persona.dart        # Modelo de PersonaAcceso
│   ├── registro_acceso.dart # Modelo de RegistroAcceso
│   ├── registro_vehiculo.dart # Modelo de RegistroVehiculo
│   ├── novedades.dart      # Modelo de Novedades y Reportes
│   └── ... Otros modelos
├── services/               # Llamadas a APIs y lógica de negocio
│   ├── auth_service.dart   # Autenticación y manejo de tokens
│   ├── acceso_service.dart # Gestión de accesos
│   ├── novedades_service.dart # Gestión de novedades y reportes
│   ├── api_client.dart     # Cliente HTTP centralizado
│   └── ... Otros servicios
├── providers/              # Manejo de estado (Provider o Riverpod)
│   ├── auth_provider.dart  # Provider de autenticación
│   ├── acceso_provider.dart # Provider de accesos
│   ├── novedades_provider.dart # Provider de novedades
│   └── ... Otros providers
├── widgets/                # Componentes reutilizables
│   ├── custom_button.dart  # Botón personalizado
│   ├── input_field.dart    # Campos de entrada reutilizables
│   ├── card_widget.dart    # Widget para mostrar tarjetas de información
│   └── ... Otros widgets
├── utils/                  # Utilidades y funciones comunes
│   ├── constants.dart      # Constantes globales
│   ├── helpers.dart        # Funciones auxiliares
│   ├── validators.dart     # Validadores de formularios
│   └── ... Otras utilidades
├── assets/                 # Recursos estáticos
│   ├── images/             # Imágenes de la aplicación
│   ├── icons/              # Íconos personalizados
│   ├── fonts/              # Fuentes tipográficas
│   └── ... Otros recursos
└── pubspec.yaml            # Archivo de configuración del proyecto