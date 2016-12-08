package main

import (
	"flag"
	"log"
	"time"
)

var WaitDuration time.Duration

const WaitDefault = time.Millisecond * 1500

func init() {
	flag.DurationVar(&WaitDuration, "wait", WaitDefault, "time to wait for before exiting")
	flag.DurationVar(&WaitDuration, "w", WaitDefault, "time to wait for before exiting")
}

func main() {
	flag.Parse()
	log.Print("Starting")
	if WaitDuration == WaitDefault {
		log.Print("Using default duration")
	}
	log.Printf("Will wait for: %s", WaitDuration)
	time.Sleep(WaitDuration)
	log.Print("Panicing now...")
	panic("FAILING NOW")
}
