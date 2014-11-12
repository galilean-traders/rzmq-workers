#!/usr/bin/env Rscript

library(rzmq)
library(rjson)

remote.exec <- function(socket, msg) {
    send.string(socket, data=msg)
    receive.socket(socket)
}

context <- init.context()
socket <- init.socket(context,"ZMQ_REQ")
connect.socket(socket,"tcp://localhost:41932")

msg <- toJSON(list(fun="sqrt", args=list(x=10000)))
print(msg)
ans <- remote.exec(socket, msg)
print(ans)
