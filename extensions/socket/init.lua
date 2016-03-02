--- === hs.socket ===
---
--- Talk to custom protocols using asynchronous TCP sockets. For UDP sockets see [`hs.socket.udp`](./hs.socket.udp.html)
---
--- `hs.socket` is implemented with [CocoaAsyncSocket](https://github.com/robbiehanson/CocoaAsyncSocket). CocoaAsyncSocket's [tagging features](https://github.com/robbiehanson/CocoaAsyncSocket/wiki/Intro_GCDAsyncSocket#reading--writing) provide a handy way to implement custom protocols.
---
--- For example, you can easily implement a basic HTTP client as follows (though using [`hs.http`](./hs.http.html) is recommended for the real world):
---
--- ~~~
--- TAG_HTTP_HEADER = 1
--- TAG_HTTP_CONTENT = 2
---
--- body = ""
---
--- local function httpCallback(data, tag)
---   if tag == TAG_HTTP_HEADER then
---     print(tag, "TAG_HTTP_HEADER")
---     print(data)
---     local _, _, contentLength = data:find("\r\nContent%-Length: (%d+)\r\n")
---     client:read(tonumber(contentLength), TAG_HTTP_CONTENT)
---   elseif tag == TAG_HTTP_CONTENT then
---     print(tag, "TAG_HTTP_CONTENT")
---     print(data)
---     body = data
---   end
--- end
---
--- client = hs.socket.new("google.com", 80, httpCallback)
--- client:write("GET /index.html HTTP/1.0\r\nHost: google.com\r\n\r\n")
--- client:read("\r\n\r\n", TAG_HTTP_HEADER)
--- ~~~
--- Resulting in the following console output:
--- ~~~
--- *** INFO:    Socket connected
--- *** INFO:    Data written to socket
--- *** INFO:    Data read from socket
--- 1 TAG_HTTP_HEADER
--- HTTP/1.0 301 Moved Permanently
--- Location: http://www.google.com/index.html
--- Content-Type: text/html; charset=UTF-8
--- Date: Tue, 16 Feb 2016 13:43:08 GMT
--- Expires: Thu, 17 Mar 2016 13:43:08 GMT
--- Cache-Control: public, max-age=2592000
--- Server: gws
--- Content-Length: 229
--- X-XSS-Protection: 1; mode=block
--- X-Frame-Options: SAMEORIGIN
---
---
--- *** INFO:    Data read from socket
--- 2 TAG_HTTP_CONTENT
--- <HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
--- <TITLE>301 Moved</TITLE></HEAD><BODY>
--- <H1>301 Moved</H1>
--- The document has moved
--- <A HREF="http://www.google.com/index.html">here</A>.
--- </BODY></HTML>
---
--- *** INFO:    Socket disconnected
--- ~~~
---

--- === hs.socket.udp ===
---
--- Talk to custom protocols using asynchronous UDP sockets. For TCP sockets see [`hs.socket`](./hs.socket.html)
---

local module = require("hs.socket.internal")

module.udp = require("hs.socket.udp")

local tcpSocketObject = hs.getObjectMetatable("hs.socket")
local udpSocketObject = hs.getObjectMetatable("hs.socket.udp")

--- hs.socket.timeout
--- Variable
--- Timeout for read and write operations, in seconds. New [`hs.socket`](#new) objects will be created with this timeout value, but can individually change it with the [`setTimeout`](#setTimeout) method
--- If the timeout value is negative, the operations will not use a timeout. The default value is -1
---
module.timeout = -1

--- hs.socket.udp.timeout
--- Variable
--- Timeout for read and write operations, in seconds. New [`hs.socket.udp`](#new) objects will be created with this timeout value, but can individually change it with the [`setTimeout`](#setTimeout) method
--- If the timeout value is negative, the operations will not use a timeout. The default value is -1
---
module.udp.timeout = -1

--- hs.socket.udp.parseAddress(sockaddr) -> table
--- Function
--- Alias for [`hs.socket.parseAddress`](./hs.socket.html#parseAddress)
---
module.udp.parseAddress = module.parseAddress

--- hs.socket.server(port[, fn]) -> hs.socket object
--- Constructor
--- Creates and binds an [`hs.socket`](#new) instance to a port for listening to 0 or more clients
---
--- Parameters:
---  * port - A port number [0-65535]. Ports [1-1023] are privileged. Port 0 allows the OS to select any available port
---  * fn - An optional callback function to process data on reads. Can also be set with the [`setCallback`](#setCallback) method
---
--- Returns:
---  * An [`hs.socket`](#new) object
---
module.server = function(port, callback)
  return module.new(callback):listen(port)
end

--- hs.socket.udp.server(port[, fn]) -> hs.socket object
--- Constructor
--- Creates and binds an [`hs.socket.udp`](#new) instance to a port for listening
---
--- Parameters:
---  * port - A port number [0-65535]. Ports [1-1023] are privileged. Port 0 allows the OS to select any available port
---  * fn - An optional callback function to process data on reads. Can also be set with the [`setCallback`](#setCallback) method
---
--- Returns:
---  * An [`hs.socket.udp`](#new) object
---
module.udp.server = function(port, callback)
  return module.udp.new(callback):listen(port)
end

--- hs.socket:receive(delimiter[, tag]) -> self
--- Method
--- Alias for [`hs.socket:read`](#read)
---
tcpSocketObject.receive = tcpSocketObject.read

--- hs.socket:send(message[, tag]) -> self
--- Method
--- Alias for [`hs.socket:write`](#write)
---
tcpSocketObject.send = tcpSocketObject.write

--- hs.socket.udp:read(delimiter[, tag]) -> self
--- Method
--- Alias for [`hs.socket.udp:receive`](#receive)
---
udpSocketObject.read = udpSocketObject.receive

--- hs.socket.udp:readOne(delimiter[, tag]) -> self
--- Method
--- Alias for [`hs.socket.udp:receiveOne`](#receiveOne)
---
udpSocketObject.readOne = udpSocketObject.receiveOne

--- hs.socket.udp:write(message[, tag]) -> self
--- Method
--- Alias for [`hs.socket.udp:send`](#send)
---
udpSocketObject.write = udpSocketObject.send

return module
