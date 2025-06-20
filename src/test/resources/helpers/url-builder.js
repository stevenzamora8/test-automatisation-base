function fn() {
    var buildUrl = function(baseUrl, username, id) {
        var url = baseUrl + '/' + username + '/api/characters';
        if (id) {
            url = url + '/' + id;
        }
        return url;
    };

    return {
        buildUrl: buildUrl
    };
}
