import argparse

# create a function called part1 that takes a list of lists as an argument
def part1(data):
    # treat the data array as a matrix
    # find sum of all elements that are less than all of their neighbors
    # store the sum in a variable called sum
    sum = 0
    for row in range(len(data)):
        for col in range(len(data[row])):
            # create an empty list called neighbors
            neighbors = []
            # iterate over the neighbors of the current element
            for i in range(-1, 2):
                for j in range(-1, 2):
                    # if the current element is not a neighbor of itself
                    if i != 0 or j != 0:
                        # if the current element is in the bounds of the matrix
                        if 0 <= row+i < len(data) and 0 <= col+j < len(data[row]):
                            # append the value of the neighbor to the neighbors list
                            neighbors.append(data[row+i][col+j])
            # if the current element is less than each of its neighbors
            if data[row][col] < min(neighbors):
                # add the current element incremented by 1 to the sum
                sum += data[row][col] + 1

    # print "Answer to part 1: " + str(sum)
    print("Answer to part 1: " + str(sum))


# create an empty function called part2 that takes a list of lists as an argument
def part2(data):
    # treat the data array as a matrix
    # find all elements that are less than all of their neighbors
    
    # create an array called marked that is the same size as the data array
    marked = [[False for i in range(len(data[0]))] for j in range(len(data))]

    # store the steps count in the list named steps_count
    steps_count = []    

    for row in range(len(data)):
        for col in range(len(data[row])):
            # create an empty list called neighbors
            neighbors = []
            # iterate over the neighbors of the current element
            for i in range(-1, 2):
                for j in range(-1, 2):
                    # if the current element is not a neighbor of itself
                    if i != 0 or j != 0:
                        # if the current element is in the bounds of the matrix
                        if 0 <= row+i < len(data) and 0 <= col+j < len(data[row]):
                            # append the value of the neighbor to the neighbors list
                            neighbors.append(data[row+i][col+j])
            # if the current element is less than each of its neighbors
            if data[row][col] < min(neighbors):
                # run breadth first search on the current element until numbers are increasing
                # store the number of steps in a variable called steps
                steps = 0
                # create an empty list called queue
                queue = []
                # append the current element to the queue
                queue.append((row, col))
                # while the queue is not empty
                while len(queue) > 0:
                    # pop the first element from the queue
                    current = queue.pop(0)
                    # increment the steps
                    steps += 1
                    # iterate over the neighbors of the current element
                    for i in range(-1, 2):
                        for j in range(-1, 2):
                            # if the current element is not a neighbor of itself
                            if i != 0 or j != 0:
                                # if the current neighbor is a horizontal or vertical neighbor
                                if i == 0 or j == 0:
                                    # if the current neighbor is in the bounds of the matrix
                                    if 0 <= current[0]+i < len(data) and 0 <= current[1]+j < len(data[current[0]]):
                                        # if the current neighbor is greater than the current element and is not equal to 9
                                        if data[current[0]+i][current[1]+j] > data[current[0]][current[1]] and data[current[0]+i][current[1]+j] != 9:
                                            # append the current neighbor to the queue if not marked
                                            if not marked[current[0]+i][current[1]+j]:
                                                queue.append((current[0]+i, current[1]+j))
                                                # mark the current neighbor
                                                marked[current[0]+i][current[1]+j] = True
                                            
                # append the steps to the steps_count list
                steps_count.append(steps)

    # select top 3 elements from the steps_count list
    top_3 = sorted(steps_count)[-3:]

    # multiply the top 3 elements
    product = 1
    for i in top_3:
        product *= i

    # print "Answer to part 2: " + str(product
    print("Answer to part 2: " + str(product))


def main():
    # parse command line arguments and get the file name
    parser = argparse.ArgumentParser(description='Process some integers.')
    parser.add_argument('file', metavar='file', type=str,
                        help='the file to process')

    args = parser.parse_args()
    file_name = args.file

    # create an empty list called data
    data = []

    # open the file
    with open(file_name, 'r') as f:
        # iterate over the lines in the file
        for line in f:
            # create an empty list called line_data
            line_data = []
            # strip whitespace from the line and iterate over the characters
            for char in line.strip():
                # convert the character to an integer and append it to the list
                line_data.append(int(char))
            # append the line_data to the data list
            data.append(line_data)

    # call the part1 function with the data list as an argument
    part1(data)

    # call the part2 function with the data list as an argument
    part2(data)
    

# Call the main function
if __name__ == "__main__":
    main()