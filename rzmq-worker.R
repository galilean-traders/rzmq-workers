#!/usr/bin/env Rscript

library(rzmq)
library(TTR)
library(argparse)
library(rjson)

argument.parser <- ArgumentParser(
        description="ZMQ REP server that runs an R function with json input and returns the output as json")
argument.parser$add_argument('-p', '--port',
            type='integer',
            nargs='?',
            default=41932,
            help='listening to this port')
args <- argument.parser$parse_args()

context <- init.context()
socket <- init.socket(context, "ZMQ_REP")
bind.socket(socket, paste("tcp://*:", args$port))

while(1) {
    msg <- fromJSON(receive.socket(socket))
    print(msg)
    fun <- msg$fun
    args <- msg$args
    print(args)
    ans <- do.call(fun, args)
    send.socket(socket, toJSON(ans))
}
