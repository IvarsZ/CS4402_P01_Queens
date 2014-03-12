import subprocess
import glob

def run_experiment(part, m, times): 

  results_file = open("results.txt", "a")
  input_file = 'src/m_queens_{0}.eprime'.format(part)
  
  number_of_queens = -1
  
  for i in range(times):
  
    # Run savilerow
    output_file = 'solutions/{0}_queens_{1}_{2}.solution'.format(m, part, i)
    args = './savilerow -in-eprime {0} -run-minion minion -out-solution {1}'.format(input_file, output_file).split() + ['-params', 'letting m be {0}'.format(m)]
    subprocess.call(args)
  
    # read/write output
    nodes = -1
    time = -1
    with open(output_file) as fp:
      for line in fp:
        words = line.split()
        if len(words) >= 4:
          if words[1] == 'numberOfQueens':
            number_of_queens = words[3]
          elif words[2] == 'TotalTime:':
            time = words[3]
          elif words[2] == 'Nodes:':
            nodes = words[3]
    results_file.write(' '.join(str(i) for i in [part, m, i, time, nodes, number_of_queens]) + '\n')
  
  results_file.close()
  
# find the number of solutions for given m and number of queens.
def find_number_of_solutions(part, m, number_of_queens):

  number_of_queens_str = str(number_of_queens)

  input_file = 'src/m_queens_{0}.eprime'.format(part)
  output_file = 'solutions/{0}_queens_{1}.solution'.format(m, part)
  args = './savilerow -in-eprime {0} -run-minion minion -out-solution {1} -all-solutions'.format(input_file, output_file).split() + ['-params', 'letting m be {0}'.format(m)]
  subprocess.call(args)

  # by counting files with number of queens used
  number_of_solutions = 0
  solutions = glob.glob(output_file + "*")
  for solution in solutions: 
    with open(solution) as fp:
      for line in fp:
        words = line.split()
        if len(words) >= 4:
          if words[1] == 'numberOfQueens' and words[3] == number_of_queens_str:
            number_of_solutions += 1

  queens_file = open("number_of_solutions.txt", "a")
  queens_file.write(' '.join(str(i) for i in [part, m, number_of_solutions]) + '\n')
  queens_file.close()

# DEFINE what experiments to run.
def compare_sum_atleast_exists_for_p1():
  for m in range(5, 13):
    for part in ['p1_sum', 'p1_atleast', 'p1_exists']:
      run_experiment(part, m, 1)
compare_sum_atleast_exists_for_p1()

def compare_sum_atleast_exists_explicit_for_p2():
  for m in range(5, 12):
    for part in ['p2_explicit', 'p2_sum', 'p2_atleast', 'p2_exists']:
      run_experiment(part, m, 1)
compare_sum_atleast_exists_explicit_for_p2()

def compare_heuristics_for_p1():
  for m in range(5, 13):
    for part in ['p1_atleast','p1_static', 'p1_sdf', 'p1_conflict', 'p1_srf']:
      run_experiment(part, m, 1)
compare_heuristics_for_p1()

def compare_heuristics_for_p2():
  for m in range(5, 13):
    for part in ['p2_sum', 'p2_static', 'p2_sdf', 'p2_conflict', 'p2_srf']:
      run_experiment(part, m, 1)
compare_heuristics_for_p2()

def compare_heuristics_for_p4():
  for m in range(5, 13):
    for part in ['p4_atleast', 'p4_static', 'p4_sdf', 'p4_conflict', 'p4_srf']:
      run_experiment(part, m, 1)
compare_heuristics_for_p4()

def compare_parts_small():
  for m in range(5, 10):
    for part in ['p1_sdf', 'p2_conflict', 'p4_sdf']:
      run_experiment(part, m, 25)
compare_parts_small()

def find_all_min_solutions():
  number_of_queens = [0, 1, 1, 1, 3, 3, 4, 4, 5, 5, 5, 5, 7, 7, 7]
  for m in range (2, 10): # Too many files for larger m.
    for part in ['p1_all', 'p2_all', 'p4_all']:
      find_number_of_solutions(part, m, number_of_queens[m]) 
#find_all_min_solutions()

def compare_parts_large():
  for m in range(10, 15):
    for part in ['p1_sdf', 'p2_conflict', 'p4_sdf']:
      run_experiment(part, m, 5)
compare_parts_large()
