function fn() {
    var generateRandomName = function() {
        return 'Hero-' + java.util.UUID.randomUUID().toString().substring(0,8);
    };

    var createCharacter = function(name, alterego, description, powers) {
        return {
            "name": name || "",
            "alterego": alterego || "",
            "description": description || "",
            "powers": powers || []
        };
    };

    return {
        generateRandomName: generateRandomName,
        createCharacter: createCharacter
    };
}
