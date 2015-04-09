#!/usr/bin/env Rscript

library(rzmq)
library(xts)
library(TTR)
library(argparse)
library(rjson)
library(data.table)

stoch.json <- function(data) {
    df <- as.data.frame(rbindlist(data)[, time := as.POSIXct(time,
                                          format="%Y-%m-%dT%H:%M:%OSZ",
                                          tz="UTC")])
    asxts <- xts(subset( df, select=-time), order.by=df$time)
    s <- stoch(
        HLC=asxts[, c("highMid", "lowMid", "closeMid")],
        nFastK=15,
        nFastD=3,
        nSlowD=3)
    return(data.frame(s))
}

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
    payload <- receive.string(socket)
    print(payload)
    msg <- fromJSON(payload)
    print(msg)
    fun <- msg$fun
    args <- msg$args
    print(args)
    ans <- do.call(fun, args)
    print(ans)
    send.raw.string(socket, toJSON(ans))
}
