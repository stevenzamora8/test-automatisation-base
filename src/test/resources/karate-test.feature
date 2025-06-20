@REQ_CHAP-0001 @REQ_PQBP-4163 @marvel @agente3
Feature: Marvel Characters API Tests

  Background:
    * def baseUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
    * def username = 'bzamora'
    * configure ssl = true
    * def testData = call read('test-data.js')

  @post @setup
  Scenario: Setup - Crear personaje para pruebas
    * def randomName = testData.generateRandomName()
    * def testHero = testData.createCharacter(randomName, "Peter Parker", "Superhéroe arácnido de Marvel", ["Agilidad", "Sentido arácnido", "Trepar muros"])
    Given url baseUrl + '/' + username + '/api/characters'
    And header Content-Type = 'application/json'
    And request testHero
    When method POST
    Then status 201
    And match response contains testHero
    * def characterId = response.id
    * def characterName = response.name
    * def result = { id: '#(characterId)', name: '#(characterName)' }

  @post @id:1 @creacionPersonaje
  Scenario: Crear personaje (exitoso)
    * def randomName = testData.generateRandomName()
    * def newHero = testData.createCharacter(randomName, "Bruce Wayne", "El caballero de la noche", ["Inteligencia", "Artes marciales", "Tecnología"])
    Given url baseUrl + '/' + username + '/api/characters'
    And header Content-Type = 'application/json'
    And request newHero
    When method POST
    Then status 201
    And match response contains newHero
    And match response.id == '#number'
    And match response.name == newHero.name

  @post @id:2 @creacionPersonaje @error
  Scenario: Crear personaje con nombre duplicado
    * def mainChar = call read('karate-test.feature@setup')
    * def duplicateHero = testData.createCharacter(mainChar.result.name, "Peter Parker", "Superhéroe arácnido de Marvel", ["Agilidad", "Sentido arácnido", "Trepar muros"])
    Given url baseUrl + '/' + username + '/api/characters'
    And header Content-Type = 'application/json'
    And request duplicateHero
    When method POST
    Then status 400
    And match response == { error: 'Character name already exists' }

  @post @id:3 @creacionPersonaje @error
  Scenario: Crear personaje con campos requeridos vacíos
    * def emptyHero = testData.createCharacter()
    Given url baseUrl + '/' + username + '/api/characters'
    And header Content-Type = 'application/json'
    And request emptyHero
    When method POST
    Then status 400
    And match response contains { name: 'Name is required' }

  @get @id:4 @consultaPersonajes
  Scenario: Obtener todos los personajes
    * def mainChar = call read('karate-test.feature@setup')
    Given url baseUrl + '/' + username + '/api/characters'
    When method GET
    Then status 200
    And match response == '#array'
    And match response[*].id contains mainChar.result.id

  @get @id:5 @consultaPersonaje
  Scenario: Obtener personaje por ID (exitoso)
    * def mainChar = call read('karate-test.feature@setup')
    Given url baseUrl + '/' + username + '/api/characters/' + mainChar.result.id
    When method GET
    Then status 200
    And match response.id == mainChar.result.id

  @get @id:6 @consultaPersonaje @error
  Scenario: Obtener personaje por ID (no existe)
    Given url baseUrl + '/' + username + '/api/characters/999'
    When method GET
    Then status 404
    And match response == { error: 'Character not found' }

  @put @id:7 @actualizacionPersonaje
  Scenario: Actualizar personaje (exitoso)
    * def mainChar = call read('karate-test.feature@setup')
    * def updatedCharacter = testData.createCharacter("Spider-Man Updated", "Peter Parker", "El trepamuros más famoso", ["Agilidad", "Sentido arácnido", "Trepar muros", "Super fuerza"])
    Given url baseUrl + '/' + username + '/api/characters/' + mainChar.result.id
    And header Content-Type = 'application/json'
    And request updatedCharacter
    When method PUT
    Then status 200
    And match response.description == updatedCharacter.description
    And match response.powers == updatedCharacter.powers

  @put @id:8 @actualizacionPersonaje @error
  Scenario: Actualizar personaje (no existe)
    * def ironMan = testData.createCharacter("Iron Man", "Tony Stark", "Genius billionaire", ["Armor", "Flight"])
    Given url baseUrl + '/' + username + '/api/characters/999'
    And header Content-Type = 'application/json'
    And request ironMan
    When method PUT
    Then status 404
    And match response == { error: 'Character not found' }

  @delete @id:9 @eliminacionPersonaje
  Scenario: Eliminar personaje (exitoso)
    * def mainChar = call read('karate-test.feature@setup')
    Given url baseUrl + '/' + username + '/api/characters/' + mainChar.result.id
    When method DELETE
    Then status 204

    # Verificamos que fue eliminado
    Given url baseUrl + '/' + username + '/api/characters/' + mainChar.result.id
    When method GET
    Then status 404

  @delete @id:10 @eliminacionPersonaje @error
  Scenario: Eliminar personaje (no existe)
    Given url baseUrl + '/' + username + '/api/characters/999'
    When method DELETE
    Then status 404
    And match response == { error: 'Character not found' }
