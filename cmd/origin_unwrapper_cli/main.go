package main

import (
	"flag"

	"github.com/ricochhet/origin_unwrapper"
	"github.com/ricochhet/readwrite"
	"github.com/ricochhet/simplelog"
)

func main() {
	inputPath := flag.String("input", "", "input path")
	outputPath := flag.String("output", "", "output path")
	dlfKey := flag.String("key", "", "dlf key")
	version := flag.String("version", "", "hash version")
	getDlfKey := flag.String("dlf-path", "", "dlf path")
	addDll := flag.Bool("add-dll", false, "true / false")
	flag.Parse()

	if len(*inputPath) == 0 || len(*outputPath) == 0 || len(*dlfKey) == 0 || len(*version) == 0 {
		simplelog.SharedLogger.Fatal("Error: not enough arguments specified")
	}

	fileMap, err := readwrite.Open(*inputPath)
	if err != nil {
		simplelog.SharedLogger.Fatalf("Error opening file: %s", err)
	}

	origin_unwrapper.Unwrap(fileMap, *version, *getDlfKey, *dlfKey, *outputPath, *addDll)
}
