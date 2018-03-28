package ballerina.net.http;

@Description {value:"Represent 'content-length' header name"}
public const string CONTENT_LENGTH = "content-length";

const string HEADER_KEY_LOCATION = "Location";

documentation {
    Represents HTTP connection.

    F{{remote}}  - Circuit Breaker start time.
                             The threshold should be a value between 0 and 1.
    F{{local}} - Total request count from the start.
    F{{protocol}} - The protocol associated with the connection.
}
public struct Connection {
    Remote remote;
    Local local;
    string protocol;
}

documentation {
    Represents the details of remote address.

    F{{host}}  - The remote server host.
    F{{port}} - The remote server port.
}
public struct Remote {
    string host;
    int port;
}

documentation {
    Represents the details of local address.

    F{{host}}  - The local server host.
    F{{port}} - The local server port.
}
public struct Local {
    string host;
    int port;
}

//////////////////////////////
/// Native Implementations ///
//////////////////////////////
@Description {value:"Sends outbound response to the caller"}
@Param {value:"conn: The server connector connection"}
@Param {value:"res: The outbound response message"}
@Return {value:"Error occured during HTTP server connector respond"}
@Return {value:"Returns null if any error does not exist."}
public native function <Connection conn> respond(Response res) returns (HttpConnectorError | null);

@Description {value:"Forwards inbound response to the caller"}
@Param {value:"conn: The server connector connection"}
@Param {value:"res: The inbound response message"}
@Return {value:"Error occured during HTTP server connector forward"}
@Return {value:"Returns null if any error does not exist."}
public native function <Connection conn> forward(Response res) returns (HttpConnectorError | null);

@Description { value:"Sends a push promise to the caller."}
@Param { value:"conn: The server connector connection" }
@Param { value:"promise: Push promise message" }
@Return { value:"Error occured during HTTP server connector forward" }
@Return {value:"Returns null if any error does not exist."}
public native function <Connection conn> promise(PushPromise promise) returns (HttpConnectorError | null);

@Description { value:"Sends a promised push response to the caller."}
@Param { value:"conn: The server connector connection" }
@Param { value:"promise: Push promise message" }
@Param { value:"res: The outbound response message" }
@Return { value:"Error occured during HTTP server connector forward" }
@Return {value:"Returns null if any error does not exist."}
public native function <Connection conn> pushPromisedResponse(PushPromise promise, Response res) returns (HttpConnectorError | null);

/////////////////////////////////
/// Ballerina Implementations ///
/////////////////////////////////
@Description { value:"Status codes for HTTP redirect"}
@Field { value:"MULTIPLE_CHOICES_300: Represents status code 300 - Multiple Choices."}
@Field { value:"MOVED_PERMANENTLY_301: Represents status code 301 - Moved Permanently."}
@Field { value:"FOUND_302: Represents status code 302 - Found."}
@Field { value:"SEE_OTHER_303: Represents status code 303 - See Other."}
@Field { value:"NOT_MODIFIED_304: Represents status code 304 - Not Modified."}
@Field { value:"USE_PROXY_305: Represents status code 305 - Use Proxy."}
@Field { value:"TEMPORARY_REDIRECT_307: Represents status code 307 - Temporary Redirect."}
public enum RedirectCode {
    MULTIPLE_CHOICES_300,
    MOVED_PERMANENTLY_301,
    FOUND_302,
    SEE_OTHER_303,
    NOT_MODIFIED_304,
    USE_PROXY_305,
    TEMPORARY_REDIRECT_307
}

@Description { value:"Sends a 100-continue response to the client."}
@Param { value:"conn: The server connector connection" }
@Return { value:"Returns an HttpConnectorError if there was any issue in sending the response." }
@Return {value:"Returns null if any error does not exist."}
public function <Connection conn> respondContinue () returns (HttpConnectorError | null) {
    Response res = {};
    res.statusCode = 100;
    return conn.respond(res);
}

@Description { value:"Sends a redirect response to the user with given redirection status code." }
@Param { value:"conn: The server connector connection" }
@Param { value:"response: Response to be sent to client." }
@Param { value:"redirectCode: Status code of the specific redirect." }
@Param { value:"locations: Array of locations where the redirection can happen." }
@Return { value:"Returns an HttpConnectorError if there was any issue in sending the response." }
@Return { value:"Returns null if any error does not exist." }
public function <Connection conn> redirect (Response response, RedirectCode code, string[] locations) returns (HttpConnectorError | null) {
    if (code == RedirectCode.MULTIPLE_CHOICES_300) {
        response.statusCode = 300;
    } else if (code == RedirectCode.MOVED_PERMANENTLY_301) {
        response.statusCode = 301;
    } else if (code == RedirectCode.FOUND_302) {
        response.statusCode = 302;
    } else if (code == RedirectCode.SEE_OTHER_303) {
        response.statusCode = 303;
    } else if (code == RedirectCode.NOT_MODIFIED_304) {
        response.statusCode = 304;
    } else if (code == RedirectCode.USE_PROXY_305) {
        response.statusCode = 305;
    } else if (code == RedirectCode.TEMPORARY_REDIRECT_307) {
        response.statusCode = 307;
    }

    string locationsStr = "";
    foreach location in locations {
        locationsStr = locationsStr + location + ",";
    }
    locationsStr = locationsStr.subString(0, (lengthof locationsStr) - 1);

    response.setHeader(HEADER_KEY_LOCATION, locationsStr);
    return conn.respond(response);
}