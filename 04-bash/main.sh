#!/bin/bash

filename=$1
readarray lines < $filename

function init() {
    draw_order=(`echo ${lines[0]} | sed -r 's/,/ / g'`)
    draw_num=${#draw_order[@]}

    board=()
    board_num=0
    for i in ${!lines[@]}; do
        if [[ $i -gt 0 ]]; then
            cur_line=(${lines[$i]})
            if [[ -z $cur_line ]]; then
                board_num=$(( board_num + 1 ))
            else
                board=("${board[@]}" "${cur_line[@]}")
                board_size=${#cur_line[@]}
            fi
        fi
    done
    board_count=$(( board_size * board_size ))
    total_count=$(( board_num * board_count ))

    # Storing the information whether specific element was drawn
    drawn=()
    for (( i = 0; i < $total_count; i++ )); do
        drawn+=(0)
    done
}

# get element at row i ($2) col j ($3) from board k ($1)
function get_index() {
    local index=$(( $1 * board_count + $2 * board_size + $3 ))
    echo $index
}

# checks if game is complete, return board sum if complete
# part 1 - the game is complete when any of the board is complete
# part 2 - the game is complete when the last of the boards is complete
function complete() {
    local part=$1
    local last_board=$2   # only for part 2
    local board_complete=0
    local board_idx=0

    for (( k = 0; k < $board_num; k++ )); do
        local board_marked=0

        # check rows
        for (( r = 0; r < $board_size; r++ )); do
            local row_marked=1
            for (( c = 0; c < $board_size; c++ )); do
                local index=`get_index $k $r $c`
                row_marked=$(( row_marked && ${drawn[$index]} ))
            done

            board_marked=$(( board_marked || row_marked))
        done

        # check columns
        for (( c = 0; c < $board_size; c++ )); do
            local col_marked=1
            for (( r = 0; r < $board_size; r++ )); do
                local index=`get_index $k $r $c`
                col_marked=$(( col_marked && ${drawn[$index]}))
            done

            board_marked=$(( board_marked || col_marked))
        done

        if [[ $part -eq 1 ]]; then
            if [[ $board_marked -eq 1 ]]; then
                board_complete=1
                board_idx=$k
                break
            fi
        else
            # keep track of the last incomplete board until all are done
            if [[ $board_marked -eq 0 ]]; then
                board_idx=$k
            fi
            board_complete=$(( board_complete + board_marked ))
        fi
    done

    local calc_sum=0
    if [[ part -eq 1 ]]; then
        calc_sum=$board_complete
    else
        if [[ $board_complete -eq $board_num ]]; then
            calc_sum=1
            board_idx=$last_board
        fi
    fi

    local sum=0
    if [[ $calc_sum -eq 1 ]]; then
        for (( r = 0; r < $board_size; r++ )); do
            for (( c = 0; c < $board_size; c++ )); do
                local index=`get_index $board_idx $r $c`
                if [[ ${drawn[$index]} -eq 0 ]]; then
                    value=${board[$index]}
                    sum=$(( sum + value ))
                fi
            done
        done
    fi

    echo $sum $board_idx
}

function run() {
    local part=$1
    local last_board=0
    for (( i = 0; i < $draw_num; i++ )); do
        draw_value=${draw_order[$i]}
        echo "Draw: $draw_value"

        for (( j = 0; j < $total_count; j++ )); do
            if (( "${board[$j]}" == "$draw_value" )); then
                drawn[$j]=1
            fi
        done

        read sum last_board < <(complete $part $last_board)
        if [[ $sum -gt 0 ]]; then
            result=$(( sum * draw_value ))
            echo "Answer to Part $part: $result"
            break
        fi
    done
}

init
run 1

init
run 2
