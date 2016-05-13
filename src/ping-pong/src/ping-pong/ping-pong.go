package main

import (
	"flag"
	"fmt"
	"io"
	"net/http"
	"os"
	"time"
)

var (
	RemoteAddress string
	ServerAddress string
)

func init() {
	flag.StringVar(&RemoteAddress, "remote", "", "")
	flag.StringVar(&RemoteAddress, "r", "", "")

	flag.StringVar(&ServerAddress, "server", "", "")
	flag.StringVar(&ServerAddress, "s", "", "")
}

func Ping(w http.ResponseWriter, r *http.Request) {
	if _, err := io.WriteString(w, "Pong"); err != nil {
		Fatal(err)
	}
}

func main() {
	flag.Parse()
	if RemoteAddress == "" {
		Fatal("Invalid RemoteAddress")
	}
	if ServerAddress == "" {
		Fatal("Invalid ServerAddress")
	}

	http.HandleFunc("/ping", Ping)
	go func() {
		if err := http.ListenAndServe(ServerAddress, nil); err != nil {
			Fatal(err)
		}
	}()
	fmt.Printf("%s: listening on address: %s\n",
		time.Now().Format(time.RFC3339), ServerAddress)

	http.DefaultClient.Timeout = time.Second * 10
	fmt.Printf("%s: client timeout set to: %s\n",
		time.Now().Format(time.RFC3339), time.Second*10)

	fmt.Printf("%s: pinging address: %s\n",
		time.Now().Format(time.RFC3339), RemoteAddress)

	ticker := time.NewTicker(time.Second * 1)
	for _ = range ticker.C {
		res, err := http.Get(RemoteAddress)
		if err != nil {
			fmt.Fprintf(os.Stderr, "%s: sending request (%s): %s\n",
				time.Now().Format(time.RFC3339), RemoteAddress, err)
			continue
		}
		fmt.Fprintf(os.Stdout, "%s: recieved status code (%s): %d\n",
			time.Now().Format(time.RFC3339), RemoteAddress, res.StatusCode)
		defer res.Body.Close()
	}
}

func Fatal(err interface{}) {
	if err != nil {
		switch err.(type) {
		case error, string:
			fmt.Fprintf(os.Stderr, "%s: Error: %s\n",
				time.Now().Format(time.RFC3339), err)
		default:
			fmt.Fprintf(os.Stderr, "%s: Error: %#v\n",
				time.Now().Format(time.RFC3339), err)
		}
	}
	os.Exit(1)
}
