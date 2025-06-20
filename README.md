# Marvel Characters API Test Automation

Este proyecto contiene pruebas automatizadas para el API de Marvel Characters usando Karate Framework.

## Configuración del Proyecto

### URL Base y Usuario
```
URL: http://bp-se-test-cabcd9b246a5.herokuapp.com
Usuario: bzamora
```

## Estructura del Proyecto e Instrucciones de uso

### 1. Descarga del proyecto

Clona este repositorio en tu máquina local:

```sh
git clone https://github.com/dg-juacasti/test-automatisation-base
cd karate-test
```

### 2. Escribe tus pruebas

- Implementa los escenarios de prueba en el archivo:  - `src/test/resources/karate-test.feature` - Escenarios de prueba
  - `src/test/resources/test-data.js` - Funciones auxiliares y estructuras de datos
  - `src/test/java/KarateBasicTest.java` - Runner de pruebas

### Escenarios Implementados

1. **Crear Personaje** (POST `/api/characters`)
   - ✅ Crear un nuevo personaje exitosamente
   - ❌ Validar error al crear con nombre duplicado
   - ❌ Validar error con campos requeridos vacíos

2. **Consultar Personajes**
   - ✅ Obtener lista de personajes (GET `/api/characters`)
   - ✅ Obtener personaje por ID (GET `/api/characters/{id}`)
   - ❌ Validar error al consultar personaje no existente

3. **Actualizar Personaje** (PUT `/api/characters/{id}`)
   - ✅ Actualizar personaje existente
   - ❌ Validar error al actualizar personaje no existente

4. **Eliminar Personaje** (DELETE `/api/characters/{id}`)
   - ✅ Eliminar personaje existente
   - ❌ Validar error al eliminar personaje no existente

### 3. Ejecuta las pruebas

Asegúrate de tener Java 17, 18 o 21 instalado y activo. Luego ejecuta:

```sh
./gradlew test o gradlew test
```

Esto compilará el proyecto y ejecutará todas las pruebas automatizadas.

### Ejemplo de Estructura de Datos

```json
{
    "name": "Iron Man",
    "alterego": "Tony Stark",
    "description": "Genius billionaire",
    "powers": ["Armor", "Flight"]
}
```

### Notas Adicionales

- Se usa `configure ssl = true` en el Background para manejar HTTPS
- Los reportes se generan en:
  - HTML: `build/karate-reports/karate-summary.html`
  - JSON: `build/karate-reports/karate-summary-json.txt`

## Tecnologías Utilizadas

- Java (17, 18 o 21)
- Gradle
- Karate Framework
