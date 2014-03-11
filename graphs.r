queries <- read.table("results.txt", head = TRUE, sep=" ", fill=TRUE)

# Collect results, calcute mean value for times and errors.
q <- aggregate(queries[c("i", "time", "nodes", "queens")], by=queries[c("part", "m")], FUN=mean)
q$time <- round(q$time, 3)

cilLow <- function(x) {
  result <- t.test(x, conf.level = 0.95)$conf.int[1]
  return (result)
}

q.cilLow <- aggregate(queries[c("time")], by=queries[c("part", "m")], FUN=cilLow)
q$cilLow = round(q.cilLow$time, 4)

q.sd <- aggregate(queries[c("time")], by=queries[c("part", "m")], FUN=sd)
q$sd = round(q.cilLow$time, 3)

q$absError <- q$time - q$cilLow
q$relError <- round(q$absError / q$time, 1) * 100

q$cilUp <- q$time + q$absError

plot_parts_time <- function(p_range, name, x_max, y_max) {
  
  p <- 0
  zero <-c(0)
  c_range <-c(seq(1, length(p_range)))
  plot(zero, zero, xlab="m", ylab="Time, s", log="y", main=name, pch=p, xlim=c(0, x_max), ylim=c(0.001, y_max), yaxt="n")
  for (c in c_range) {
    p_set <- subset(q, q$part == p_range[c])
    lines(p_set$m, p_set$time, col=c)
    points(p_set$m, p_set$time, col=c)
  }
  legend("topleft", title="parts", legend=p_range, col=c_range, cex=0.5, pch=1)
  aty <- axTicks(2)
  labels <- sapply(aty,function(i)
    as.expression(bquote(.(i)))
  )
  axis(2,at=aty,labels=labels)
}

# Plot different p1 implementations.
plot_parts_time(c('p1_atleast', 'p1_sum', 'p1_exists'), "Different p1 implementations", 13, 1000)

# Plot different p2 implementations.
plot_parts_time(c('p2_atleast', 'p2_sum', 'p2_exists', 'p2_explicit'), "Different p2 implementations", 12, 1000)

# Plot different p1 heuristics.
plot_parts_time(c('p1_atleast', 'p1_static', 'p1_sdf', 'p1_conflict', 'p1_srf'), "Different p1 heuristics", 13, 1000)

# Plot different p2 heuristics.
plot_parts_time(c('p2_sum', 'p2_static', 'p2_sdf', 'p2_conflict', 'p2_srf'), "Different p2 heuristics", 13, 1000)

# Plot different p4 heuristics.
plot_parts_time(c('p4_sum', 'p4_static', 'p4_sdf', 'p4_conflict', 'p4_srf'), "Different p4 heuristics", 13, 1000)

# Plot different parts (best for each)
plot_parts_time(c('p1_sdf', 'p2_conflict', 'p4_sdf'), "Best of each part", 13, 1000)

plot(zero, zero, xlab="m", ylab="Nodes, no.", log="y", main="Nodes", pch=p, xlim=c(0, 13), ylim=c(1, 100000000), yaxt="n")
for (c in c_range) {
  p_set <- subset(q, q$part == p_range[c])
  lines(p_set$m, p_set$nodes, col=c)
  points(p_set$m, p_set$nodes, col=c)
}
legend("topleft", title="parts", legend=p_range, col=c_range, cex=0.5, pch=1)
aty <- axTicks(2)
labels <- sapply(aty,function(i)
  as.expression(bquote(.(i)))
)
axis(2,at=aty,labels=labels)

plot(zero, zero, xlab="m", ylab="queens, no.", main="Number of queens", pch=p, xlim=c(0, 12), ylim=c(0, 7))
p_set <- subset(q, q$part == "p1")
lines(p_set$m, p_set$queens)
points(p_set$m, p_set$queens)
