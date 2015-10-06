module Http.Server
  ( createServer, listen
  , writeHead, write
  , end
  , Port, Code, Echo, Header
  , Server, Method(..)
  , emptyReq, Request
  , emptyRes, Response
  , writeHtml, url) where

import Task exposing (Task, succeed, andThen)
import Signal exposing (Address, Mailbox, mailbox)
import Native.Http

type Server       = Server
type Request      = Request
type Response     = Response

type Method
  = GET
  | POST
  | PUT
  | DELETE

type alias Port   = Int
type alias Code   = Int
type alias Echo   = String
type alias Url    = String
type alias Header = (String, String)

createServer : Address (Request, Response) -> Task x Server
createServer = Native.Http.createServer

listen : Port -> Echo -> Server -> Task x Server
listen = Native.Http.listen

writeHead : Code -> Header -> Response -> Task x Response
writeHead = Native.Http.writeHead

write : String -> Response -> Task x Response
write = Native.Http.write

end : Response -> Task x ()
end = Native.Http.end

emptyReq : Request
emptyReq = Native.Http.emptyReq

emptyRes : Response
emptyRes = Native.Http.emptyRes

url : Request -> Url
url = Native.Http.url

method : Request -> Method
method req =
  case Native.Http.method req of
    "GET"    -> GET
    "POST"   -> POST
    "PUT"    -> PUT
    "DELETE" -> DELETE

statusCode : Request -> Code
statusCode = Native.Http.statusCode

writeAs : Header -> Response -> String -> Task x ()
writeAs header res html =
  writeHead 200 header res
  `andThen` write html `andThen` end

textHtml : Header
textHtml = ("Content-Type", "text/html")

writeHtml : Response -> String -> Task x ()
writeHtml = writeAs textHtml

applicationJson : Header
applicationJson = ("Content-Tyoe", "application/json")

writeJson : Response -> String -> Task x ()
writeJson = writeAs applicationJson
