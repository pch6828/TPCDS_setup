import sys

def main(argv):
    input_filename = argv[1]
    output_filename = argv[2]

    input_file = open(input_filename, 'r', encoding='cp1252')
    output_file = open(output_filename, 'w', encoding='utf-8')

    while True:
        line = input_file.readline()
        if not line: 
            break
        line = line[:-2]
        line = line.encode('utf-8', errors='replace').decode('utf-8')
        output_file.write(line)
        output_file.write('\n')
    
    input_file.close()
    output_file.close()

if __name__ == "__main__":
    main(sys.argv)