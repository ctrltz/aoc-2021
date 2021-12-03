package main

import (
    "fmt"
    "os"
    "strconv"
    "strings"
)

func part1(data string) {
    chunks := strings.Split(data, "\n")
    chunk_len := len(strings.TrimSpace(chunks[0]))
    acc := make([]int, chunk_len)
    gamma := make([]byte, chunk_len)
    epsilon := make([]byte, chunk_len)

    for _, chunk := range chunks {
        if len(chunk) > 0 {
            for pos, ch := range chunk {
                if ch == '1' {
                    acc[pos]++
                } else {
                    acc[pos]--
                }
            }
        }
    }

    for i, val := range acc {
        if val > 0 {
            gamma[i] = '1'
            epsilon[i] = '0'
        } else {
            gamma[i] = '0'
            epsilon[i] = '1'
        }
    }

    g, err := strconv.ParseInt(string(gamma), 2, 32)
    if err != nil {
        fmt.Println("Failed to parse the gamma rate")
        panic(err)
    }

    e, err := strconv.ParseInt(string(epsilon), 2, 32)
    if err != nil {
        fmt.Println("Failed to parse the epsilon rate")
        panic(err)
    }

    pc := g * e;

    fmt.Println("Part 1:", pc)
}


func filter(chunks []string, pos int, criteria byte) (ret []string) {
    for _, chunk := range chunks {
        if len(chunk) > 0 {
            if chunk[pos] == criteria {
                ret = append(ret, chunk)
            }
        }
    }
    return
}


func get_rating(chunks []string, most_common bool) string {
    pos := 0

    for len(chunks) > 1 {
        acc := 0
        for _, chunk := range chunks {
            if len(chunk) > 0 {
                if chunk[pos] == '1' {
                    acc++
                } else {
                    acc--
                }
            }
        }

        var criteria byte = '0'
        if most_common && acc >= 0 || !most_common && acc < 0 {
            criteria = '1'
        }

        chunks = filter(chunks, pos, criteria)
        pos++
    }

    return chunks[0]
}

func part2(data string) {
    chunks := strings.Split(data, "\n")

    o2_rating := get_rating(chunks, true)
    co2_rating := get_rating(chunks, false)

    o2r, err := strconv.ParseInt(o2_rating, 2, 32)
    if err != nil {
        fmt.Println("Failed to parse the oxygen rating")
        panic(err)
    }

    co2r, err := strconv.ParseInt(co2_rating, 2, 32)
    if err != nil {
        fmt.Println("Failed to parse the CO2 rating")
        panic(err)
    }

    lsr := o2r * co2r;

    fmt.Println("Part 2:", lsr);
}

func main() {
    args := os.Args[1:]
    if len(args) != 1 {
        fmt.Println("Usage: ./main filename")
        panic("Could not derive the filename")
    }

    fname := args[0]
    contents, err := os.ReadFile(fname)
    if err != nil {
        panic(err)
    }
    data := string(contents)

    part1(data)
    part2(data)
}
