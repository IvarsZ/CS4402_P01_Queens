import subprocess

min = 4
max = 4
times = 1
parts = ['p1', 'p2', 'p4']

for m in range(min, max + 1):
  results_file = open("results.txt", "a")
  
  for part in parts:
    for i in range(times):

      # Run savilerow
      input_file = 'm_queens_{0}.eprime'.format(part)
      output_file = 'solutions/{0}_queens_p{1}_{2}.solution'.format(m, part, i)
      args = './savilerow -in-eprime {0} -run-minion minion -out-solution {1}'.format(input_file, output_file).split() + ['-params', 'letting n be {0}'.format(m)]
      subprocess.call(args)

      # Read/write output
      number_of_queens = -1
      nodes = -1
      time = -1
      with open(output_file) as fp:
        for line in fp:
          words = line.split()
          if words[1] == 'numberOfQueens':
            number_of_queens = words[3]
          elif words[2] == 'TotalTime:':
            time = words[3]
          elif words[2] == 'Nodes:':
            nodes = words[3]
      #results_file.write(part + ' ' + m + ' ' + i + ' ' + time + ' ' + nodes + ' ' + number_of_queens)
      results_file.write(' '.join(str(i) for i in [part, m, i, time, nodes, number_of_queens]) + '\n')
  
  results_file.close()
