@REQ_CHAP-0001 @marvel @agente3
Feature: Marvel Characters API Tests

  Background:
    * def baseUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
    * def username = 'bzamora'
    * configure ssl = true
    * def testData = call read('helpers/test-data.js')
    * def urlBuilder = call read('helpers/url-builder.js')

  @post @setup
  Scenario: Setup - Create test character
    * def randomName = testData.generateRandomName()
    * def testHero = testData.createCharacter(randomName, "Peter Parker", "Marvel's spider-powered superhero", ["Agility", "Spider-sense", "Wall-climbing"])
    Given url urlBuilder.buildUrl(baseUrl, username)
    And header Content-Type = 'application/json'
    And request testHero
    When method POST
    Then status 201
    And match response contains testHero
    * def characterId = response.id
    * def characterName = response.name
    * def result = { id: '#(characterId)', name: '#(characterName)' }

  @post @id:1 @characterCreation
  Scenario: Create character successfully
    * def randomName = testData.generateRandomName()
    * def newHero = testData.createCharacter(randomName, "Bruce Wayne", "The Dark Knight", ["Intelligence", "Martial Arts", "Technology"])
    Given url urlBuilder.buildUrl(baseUrl, username)
    And header Content-Type = 'application/json'
    And request newHero
    When method POST
    Then status 201
    And match response contains newHero
    And match response.id == '#number'
    And match response.name == newHero.name

  @post @id:2 @characterCreation @error
  Scenario: Create character with duplicate name
    * def mainChar = call read('karate-test.feature@setup')
    * def duplicateHero = testData.createCharacter(mainChar.result.name, "Peter Parker", "Marvel's spider-powered superhero", ["Agility", "Spider-sense", "Wall-climbing"])
    Given url urlBuilder.buildUrl(baseUrl, username)
    And header Content-Type = 'application/json'
    And request duplicateHero
    When method POST
    Then status 400
    And match response == { error: 'Character name already exists' }

  @post @id:3 @characterCreation @error
  Scenario: Create character with empty required fields
    * def emptyHero = testData.createCharacter()
    Given url urlBuilder.buildUrl(baseUrl, username)
    And header Content-Type = 'application/json'
    And request emptyHero
    When method POST
    Then status 400
    And match response contains { name: 'Name is required' }

  @get @id:4 @characterRetrieval
  Scenario: Get all characters
    * def mainChar = call read('karate-test.feature@setup')
    Given url urlBuilder.buildUrl(baseUrl, username)
    When method GET
    Then status 200
    And match response == '#array'
    And match response[*].id contains mainChar.result.id

  @get @id:5 @characterRetrieval
  Scenario: Get character by ID successfully
    * def mainChar = call read('karate-test.feature@setup')
    Given url urlBuilder.buildUrl(baseUrl, username, mainChar.result.id)
    When method GET
    Then status 200
    And match response.id == mainChar.result.id

  @get @id:6 @characterRetrieval @error
  Scenario: Get character by ID - Not found
    Given url urlBuilder.buildUrl(baseUrl, username, '999')
    When method GET
    Then status 404
    And match response == { error: 'Character not found' }

  @put @id:7 @characterUpdate
  Scenario: Update character successfully
    * def mainChar = call read('karate-test.feature@setup')
    * def updatedCharacter = testData.createCharacter("Spider-Man Updated", "Peter Parker", "The most famous wall-crawler", ["Agility", "Spider-sense", "Wall-climbing", "Super strength"])
    Given url urlBuilder.buildUrl(baseUrl, username, mainChar.result.id)
    And header Content-Type = 'application/json'
    And request updatedCharacter
    When method PUT
    Then status 200
    And match response.description == updatedCharacter.description
    And match response.powers == updatedCharacter.powers

  @put @id:8 @characterUpdate @error
  Scenario: Update character - Not found
    * def ironMan = testData.createCharacter("Iron Man", "Tony Stark", "Genius billionaire", ["Armor", "Flight"])
    Given url urlBuilder.buildUrl(baseUrl, username, '999')
    And header Content-Type = 'application/json'
    And request ironMan
    When method PUT
    Then status 404
    And match response == { error: 'Character not found' }

  @delete @id:9 @characterDeletion
  Scenario: Delete character successfully
    * def mainChar = call read('karate-test.feature@setup')
    Given url urlBuilder.buildUrl(baseUrl, username, mainChar.result.id)
    When method DELETE
    Then status 204

    # Verify character was deleted
    Given url urlBuilder.buildUrl(baseUrl, username, mainChar.result.id)
    When method GET
    Then status 404

  @delete @id:10 @characterDeletion @error
  Scenario: Delete character - Not found
    Given url urlBuilder.buildUrl(baseUrl, username, '999')
    When method DELETE
    Then status 404
    And match response == { error: 'Character not found' }
