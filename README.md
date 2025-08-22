# TiendaExpress: App TPV con Flutter, Stripe y Supabase

## 🚀 Acerca del Proyecto

`TiendaExpress` es una aplicación de punto de venta (TPV) desarrollada con **Flutter**. Este proyecto fue creado con el objetivo principal de consolidar habilidades de desarrollo móvil *full-stack*, integrando una pasarela de pago real, un sistema de autenticación y una API externa. Es un excelente ejemplo práctico de cómo conectar múltiples servicios para construir una aplicación funcional y robusta.

## ✨ Características Principales

  - **Autenticación de Usuarios:** Registro e inicio de sesión seguro usando el servicio de autenticación de **Supabase**.
  - **Catálogo de Productos Dinámico:** Los productos se cargan en tiempo real desde la **FakeStore API**, lo que demuestra el manejo de APIs externas.
  - **Carrito de Compras:** Funcionalidad completa para añadir, gestionar y eliminar productos.
  - **Gestión de Favoritos:** Los usuarios pueden guardar productos en una lista de favoritos.
  - **Procesamiento de Pagos:** Integración con **Stripe PaymentSheet** para procesar pagos de prueba de forma segura.
  - **Backend Local:** Un servidor local en **Python/Flask** gestiona la creación de un `PaymentIntent`, manteniendo las claves secretas de Stripe seguras.
  - **Registro de Errores:** Un sistema de *logging* en tiempo real que guarda los errores en una base de datos de Supabase para facilitar la depuración.
  - **Persistencia de Datos:** El carrito y los favoritos persisten localmente en la sesión del usuario.

-----

## 💻 Tecnologías y Herramientas

  - **Frontend:** `Flutter`, `Provider` (gestión de estado), `flutter_dotenv`.
  - **Backend:** `Python` y `Flask`.
  - **Servicios:** `Supabase` (autenticación y BBDD), `Stripe` (pagos), `FakeStore API` (datos de productos).
  - **Base de Datos:** `PostgreSQL` (a través de Supabase).

-----

## ⚙️ Guía de Configuración

Sigue estos pasos para configurar y ejecutar el proyecto en tu entorno local.

### Prerrequisitos

  - [Flutter SDK](https://flutter.dev/docs/get-started/install)
  - [Python 3](https://www.python.org/downloads/)
  - Una cuenta de [Supabase](https://supabase.io/).
  - Una cuenta de [Stripe](https://stripe.com/docs).

### 1\. Clonar el Repositorio

```sh
git clone https://github.com/tu-usuario/tienda-express.git
cd tienda-express
```

### 2\. Configurar el Backend (Python/Flask)

1.  Navega a la carpeta del servidor:
    ```sh
    cd server
    ```
2.  Crea un entorno virtual y actívalo:
    ```sh
    python -m venv venv
    # En Windows
    venv\Scripts\activate
    # En macOS/Linux
    source venv/bin/activate
    ```
3.  Instala las dependencias:
    ```sh
    pip install -r requirements.txt
    ```
4.  Crea un archivo `.env` en la carpeta `server` y añade tu clave secreta de Stripe:
    ```env
    STRIPE_SECRET_KEY=sk_test_...
    ```
5.  Inicia el servidor:
    ```sh
    python server.py
    ```

### 3\. Configurar el Frontend (Flutter)

1.  Navega de nuevo a la carpeta principal:
    ```sh
    cd ..
    ```
2.  Instala las dependencias de Flutter:
    ```sh
    flutter pub get
    ```
3.  Crea un archivo `.env` en la raíz del proyecto y añade tus claves de API:
    ```env
    SUPABASE_URL=tu_url_de_supabase
    SUPABASE_ANON_KEY=tu_clave_anon_de_supabase
    STRIPE_PUBLISHABLE_KEY=pk_test_...
    SERVER_URL=http://10.0.2.2:4242  # Para emulador Android
    ```
4.  Ejecuta la app:
    ```sh
    flutter run
    ```

### 4\. Configuración Nativa de Android

Para que la integración de Stripe funcione, los archivos nativos de Android deben estar configurados:

  - **`android/app/src/main/kotlin/com/example/tienda_express/MainActivity.kt`**: Debe heredar de `FlutterFragmentActivity`.
  - **`android/app/src/main/res/values/styles.xml`**: El tema de la app debe heredar de `Theme.MaterialComponents.DayNight.NoActionBar`.

-----

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Si encuentras un error o tienes alguna sugerencia, no dudes en abrir un *issue* o un *pull request*.

## 📄 Licencia

Este proyecto está bajo la licencia MIT.
