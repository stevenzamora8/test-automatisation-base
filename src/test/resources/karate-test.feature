@REQ_CHAP-0001 @REQ_PQBP-4163 @marvel @agente3
Feature: Marvel Characters API Tests

  Background:
    * def baseUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
    * def username = 'bzamora'
    * configure ssl = true
    * def ironMan = 
    """
    {
      "name": "Iron Man",
      "alterego": "Tony Stark",
      "description": "Genius billionaire",
      "powers": ["Armor", "Flight"]
    }
    """
    * def generateRandomName = function(){ return 'Hero-' + java.util.UUID.randomUUID().toString().substring(0,8) }
    * def emptyCharacter = 
    """
    {
      "name": "",
      "alterego": "",
      "description": "",
      "powers": []
    }
    """

  @get @id:1 @consultaPersonajes
  Scenario: Obtener todos los personajes
    Given url baseUrl + '/' + username + '/api/characters'
    When method GET
    Then status 200
    And match response == '#array'
  @get @id:2 @consultaPersonaje
  Scenario: Obtener personaje por ID (exitoso)
    # Primero obtenemos la lista de personajes
    Given url baseUrl + '/' + username + '/api/characters'
    When method GET
    Then status 200
    * def characterId = response.length > 0 ? response[0].id : karate.call('classpath:create-character.feature').id

    # Obtenemos el personaje creado
    Given url baseUrl + '/' + username + '/api/characters/' + characterId
    When method GET
    Then status 200
    And match response == { id: '#(characterId)', name: '#(ironMan.name)', alterego: '#(ironMan.alterego)', description: '#(ironMan.description)', powers: '#(ironMan.powers)' }

  @get @id:3 @consultaPersonaje @error
  Scenario: Obtener personaje por ID (no existe)
    Given url baseUrl + '/' + username + '/api/characters/999'
    When method GET
    Then status 404
    And match response == { error: 'Character not found' }
  @post @id:4 @creacionPersonaje
  Scenario: Crear personaje (exitoso)
    * def randomName = generateRandomName()
    * def testHero = 
    """
    {
      "name": "#(randomName)",
      "alterego": "Peter Parker",
      "description": "Superhéroe arácnido de Marvel",
      "powers": ["Agilidad", "Sentido arácnido", "Trepar muros"]
    }
    """
    Given url baseUrl + '/' + username + '/api/characters'
    And header Content-Type = 'application/json'
    And request testHero
    When method POST
    Then status 201
    And match response contains testHero
    * def characterId = response.id
  @post @id:5 @creacionPersonaje @error
  Scenario: Crear personaje (nombre duplicado)
    # Primero creamos un personaje con nombre aleatorio
    * def randomName = generateRandomName()
    * def firstHero = 
    """
    {
      "name": "#(randomName)",
      "alterego": "John Doe",
      "description": "Test hero",
      "powers": ["Test power"]
    }
    """
    Given url baseUrl + '/' + username + '/api/characters'
    And header Content-Type = 'application/json'
    And request firstHero
    When method POST
    Then status 201

    # Intentamos crear otro con el mismo nombre
    Given url baseUrl + '/' + username + '/api/characters'
    And header Content-Type = 'application/json'
    And request firstHero
    When method POST
    Then status 400
    And match response == { error: 'Character name already exists' }

  @post @id:6 @creacionPersonaje @error
  Scenario: Crear personaje (faltan campos requeridos)
    Given url baseUrl + '/' + username + '/api/characters'
    And header Content-Type = 'application/json'
    And request emptyCharacter
    When method POST
    Then status 400
    And match response contains { name: 'Name is required' }  @put @id:7 @actualizacionPersonaje
  Scenario: Actualizar personaje (exitoso)
    # Primero creamos un personaje con nombre aleatorio
    * def randomName = generateRandomName()
    * def testHero = 
    """
    {
      "name": "#(randomName)",
      "alterego": "Peter Parker",
      "description": "Superhéroe base",
      "powers": ["Agilidad"]
    }
    """
    Given url baseUrl + '/' + username + '/api/characters'
    And header Content-Type = 'application/json'
    And request testHero
    When method POST
    Then status 201
    * def characterId = response.id

    # Lo actualizamos
    * def updatedCharacter = 
    """
    {
      "name": "Iron Man",
      "alterego": "Tony Stark",
      "description": "Genius billionaire playboy philanthropist",
      "powers": ["Armor", "Flight", "Intelligence"]
    }
    """
    Given url baseUrl + '/' + username + '/api/characters/' + characterId
    And header Content-Type = 'application/json'
    And request updatedCharacter
    When method PUT
    Then status 200
    And match response.description == updatedCharacter.description
    And match response.powers == updatedCharacter.powers

  @put @id:8 @actualizacionPersonaje @error
  Scenario: Actualizar personaje (no existe)
    Given url baseUrl + '/' + username + '/api/characters/999'
    And header Content-Type = 'application/json'
    And request ironMan
    When method PUT
    Then status 404
    And match response == { error: 'Character not found' }

  @delete @id:9 @eliminacionPersonaje
  Scenario: Eliminar personaje (exitoso)
    # Creamos un personaje primero
    * def randomName = generateRandomName()
    * def testHero = 
    """
    {
      "name": "#(randomName)",
      "alterego": "Peter Parker",
      "description": "Superhéroe arácnido de Marvel",
      "powers": ["Agilidad", "Sentido arácnido", "Trepar muros"]
    }
    """
    Given url baseUrl + '/' + username + '/api/characters'
    And header Content-Type = 'application/json'
    And request testHero
    When method POST
    Then status 201
    * def characterId = response.id

    # Lo eliminamos
    Given url baseUrl + '/' + username + '/api/characters/' + characterId
    When method DELETE
    Then status 204

    # Verificamos que fue eliminado
    Given url baseUrl + '/' + username + '/api/characters/' + characterId
    When method GET
    Then status 404

  @delete @id:10 @eliminacionPersonaje @error
  Scenario: Eliminar personaje (no existe)
    Given url baseUrl + '/' + username + '/api/characters/999'
    When method DELETE
    Then status 404
    And match response == { error: 'Character not found' }
